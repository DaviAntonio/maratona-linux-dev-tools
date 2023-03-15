#!/bin/bash

binaries() {
	local -r repo="$1"
	local -r packages_dir="$2"
	local -r packages_info_dir="$3"

	# go into directory
	cd "$repo" || exit

	# clean repo
	debclean

	# compile
	# see manpages for debuild, dpkg-buildpackage, dpkg-genchanges
	# and dpkg-source

	# Run lintian
	# Sign everything (to not sign everything, add --no-sign)
	# Build binary and source packages
	# Forces the original source
	# Assumes DEBUILD_DPKG_BUILDPACKAGE_OPTS="--sign-key=key -sa"
	# debuild might not like --build=full, go with -F
	printf "\nCompiling 'full' build arifacts\n"
	time debuild -F -i \
		-I.git -I.gitattributes -I.gitignore -I.gitmodules -I.gitreview \
		--lintian-opts -EviIL +pedantic --profile ubuntu
	printf "\nFinished compiling 'full' build arifacts\n"

	# clean repo again
	debclean

	# return
	cd ..

	# move results
	printf "\nMoving 'full' build arifacts\n"
	mv --verbose -- *.deb "$packages_dir"

	mv --verbose -- *.build "$packages_info_dir"
	mv --verbose -- *.buildinfo "$packages_info_dir"
	mv --verbose -- *.changes "$packages_info_dir"
	mv --verbose -- *.dsc "$packages_info_dir"
	mv --verbose -- *.tar.* "$packages_info_dir"

	# create links if dput mixed upload
	for p in "$(pwd)"/"$packages_dir"/*.deb; do
		[ -e "$p" ] || continue
		printf "Linking %s -> %s\n" "$p" "${packages_info_dir}/$(basename "$p")"
		ln -sT "$p" "${packages_info_dir}/$(basename "$p")"
	done

	printf "\nDone\n"
	return 0
}
