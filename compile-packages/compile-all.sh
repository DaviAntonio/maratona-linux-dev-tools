#!/bin/bash

source ./compile-aux.sh
source ./compile-scan.sh
source ./compile-graphs.sh
source ./create-orig.sh

timestamp="$(date --iso-8601='minutes')"
readonly timestamp

logfile="${timestamp}.log"
readonly logfile

resultsfile="${timestamp}-results.log"
readonly resultsfile

readonly repos=(
"maratona-background"
"maratona-firewall"
"maratona-meta"
"maratona-submission"
"maratona-team-tools"
"maratona-usuario-icpc"
"maratona-kairos"
"maratona-visual-studio-code"
"maratona-intellij-idea"
"maratona-intellij-pycharm"
"maratona-intellij-clion"
"boca"
"maratona-fancy-tools"
)

readonly include_binaries=(
"N"
"N"
"N"
"N"
"Y" # "N"
"N"
"N"
"Y"
"Y"
"Y"
"Y"
"N"
"N"
)

readonly distro='noble'

# Create noble schroot (old way, sbuild schroot)
# sbuild-createchroot --include=eatmydata --command-prefix=eatmydata --alias=jammy jammy /srv/chroot/jammy-amd64-sbuild http://localhost:3142/archive.ubuntu.com/ubuntu
# sbuild-createchroot --include=eatmydata --command-prefix=eatmydata --alias=noble noble /srv/chroot/noble-amd64-sbuild http://localhost:3142/archive.ubuntu.com/ubuntu
# sbuild-createchroot --include=eatmydata --command-prefix=eatmydata --alias=sid unstable /srv/chroot/unstable-amd64-sbuild http://localhost:3142/deb.debian.org/debian
# Delete old-style chroots
# sbuild-destroychroot jammy
# Before deleting the chroot, make sure that it is not in use anymore.
# Specifically, make sure that no open schroot session is using it
# anymore by running:
#
#     schroot --all-sessions --list
#
# Make sure that no other process is using the chroot directory anymore,
# for example by running:
#
#     lsof /srv/chroot/jammy-amd64-sbuild
#
# Delete the chroot, for example by running:
#
#     rm --recursive --one-file-system /srv/chroot/jammy-amd64-sbuild
#
# Finally, delete the schroot configuration file, for example by running:
#
#     rm /etc/schroot/chroot.d/jammy-amd64-sbuild-btJYAV
# sbuild-destroychroot noble
# sbuild-destroychroot unstable

# New style chroot (unshare)
# apt install sbuild mmdebstrap uidmap
# mkdir -p ~/.cache/sbuild
# mmdebstrap --include=ca-certificates --skip=output/dev --variant=buildd unstable ~/.cache/sbuild/unstable-amd64.tar.zst https://deb.debian.org/debian
# Caso use apt-cacher-ng
# mmdebstrap --skip=output/dev --variant=buildd unstable ~/.cache/sbuild/unstable-amd64.tar.zst http://deb.debian.org/debian --aptopt='Acquire::http { Proxy "http://127.0.0.1:3142"; }'
# mmdebstrap --skip=output/dev --variant=buildd noble ~/.cache/sbuild/noble-amd64.tar.zst http://archive.ubuntu.com/ubuntu --aptopt='Acquire::http { Proxy "http://127.0.0.1:3142"; }'

# Fix possibly broken packages (file(s) with a time stamp too far in the past)
# See https://bugs.launchpad.net/launchpad/+bug/836935
# for d in maratona-team-tools/extensions maratona-team-tools/kotlinc maratona-visual-studio-code/vscode maratona-intellij-pycharm/pycharm-community maratona-intellij-idea/intellij-idea-community maratona-intellij-clion/clion; do ./make-files-new.sh "$d"; done

main() {
	initial_setup

	# New style chroot (unshare)
	# skips the device node generation from the tarball
	# enables connection to apt-proxy-ng
	mkdir -p "${HOME}/.cache/sbuild"
	mmdebstrap \
		--skip='output/dev' \
		--variant=buildd \
		--components='main universe' \
		--aptopt='Acquire::http { Proxy "http://127.0.0.1:3142"; }' \
		"$distro" \
		"${HOME}/.cache/sbuild/${distro}-amd64.tar.xz" \
		'http://archive.ubuntu.com/ubuntu'

	printf '%s,%s\n' "package" "sbuild_return" > "${resultsfile}"

	for ((i = 0; i < ${#repos[@]}; i++)); do
	#for repo in "${repos[@]}"; do
		local repo="${repos[$i]}"
		local sbuild_rcode

		is_native "$repo"
		local native=$?

		make_orig "$repo"

		if [[ $native == 0 && "${include_binaries[$i]}" == "Y" ]]; then
			sbuild \
				--dist="${distro}" \
				--dpkg-source-opt='--include-binaries' \
				--dpkg-source-opt='--include-removal' \
				--dpkg-source-opts='--compression=xz --compression-level=9' \
				"$repo"
			sbuild_rcode=$?
			#--extra-repository="deb http://localhost:3142/archive.ubuntu.com/ubuntu ${distro} universe" \
		else
			sbuild \
				--dist="${distro}" \
				--dpkg-source-opts='--compression=xz --compression-level=9' \
				"$repo"
			sbuild_rcode=$?
		fi

		printf '%s,%s\n' "$repo" "$sbuild_rcode" >> "${resultsfile}"

		mv --verbose -- *.deb "$packages_dir"
		mv --verbose -- *.ddeb "$packages_dir"

		mv --verbose -- *.dsc "$packages_info_dir"
		mv --verbose -- *.orig.tar.* "$packages_info_dir"
		mv --verbose -- *.tar.* "$packages_info_dir"
		mv --verbose -- *.buildinfo "$packages_info_dir"
		mv --verbose -- *.build "$packages_info_dir"
		mv --verbose -- *amd64.changes "$packages_info_dir"

		mv --verbose -- *source.changes "$packages_source_info_dir"

		# Linking Debian packages from the binary packages directory to the
		# binary changes directory
		printf "Fixing the binary changes file\n"
		for f in "$(pwd)/$packages_dir"/*; do
			[[ -e "$packages_info_dir/$(basename "$f")" ]] && continue
			if [[ "$f" =~ .*\.deb|.*\.ddeb ]]; then
				ln -svT "$f" "$packages_info_dir/$(basename "$f")"
			fi
		done

		# Linking the artifacts to the source changes directory
		printf "Fixing the source packages file\n"
		for f in "$(pwd)/$packages_info_dir"/*; do
			[[ -e "$packages_source_info_dir/$(basename "$f")" ]] && continue
			# if [[ "$f" =~ .*\.dsc|.*\.orig.tar.*|.*\.buildinfo ]]; then
			if [[ "$f" =~ .*\.dsc|.*\.tar\.*|.*\.buildinfo ]]; then
				ln -svT "$f" "$packages_source_info_dir/$(basename "$f")"
			fi
		done
	done

	# Scan the packages
	scan "$packages_dir"

	# Generating graph
	graphs "$pdg_path" "$packages_dir"

	printf "\nDone\n"
	exit 0
}

# Launchpad bugs with modern Debian tooling
# https://bugs.launchpad.net/launchpad/+bug/1699763

# Fix *.changes for Canonical's Launchpad (PPA)
# perl -i -nle 'print unless /buildinfo/' *.changes

# Sign the package
# debsign *.changes

# Upload the package
# dput ${my_repo} *.changes

main 2>&1 | tee "${logfile}"
