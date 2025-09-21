#!/bin/bash

is_native() {
	local -r repo="$1"

	if grep '(quilt)' "${repo}/debian/source/format" 2>&1 >/dev/null; then
		return 0
	else
		return 1
	fi
}

make_orig() {
	local -r repo="$1"

	printf "Checking if '%s' is a source package\n" "$repo"

	# Check if directory contains a source package
	if grep '(quilt)' "${repo}/debian/source/format"; then
		printf "'%s' is a source package, reading its version\n" "${repo}"

		#local version=$(dpkg-parsechangelog --file "${repo}/debian/changelog" --show-field 'Version')
		local version=$(perl get-upstream-version.pl "${repo}/debian/changelog")
		local exit_code=$?

		if [[ $exit_code == 0 ]]; then
			printf "Found version '%s'\n" "${version}"
			version="${version%-*}"
			printf "Upstream version is '%s'\n" "${version}"
			#find "${repo}" -type d \
			#	\( -path "${repo}/.git" -o -path "${repo}/debian" \) -prune -o \
			#	-type f -exec strip-nondeterminism {} \+
			tar --exclude=debian --exclude=.git \
				--use-compress-program='pixz -9' \
				-cvf "${repo}-${version}.tar.xz" "${repo}"
			if ! ln --verbose --symbolic -T "${repo}-${version}.tar.xz" "${repo}_${version}.orig.tar.xz"; then
				printf "Failed to link '%s' to '%s'\n" \
					"${repo}_${version}.orig.tar.xz" "${repo}-${version}.tar.xz"
				return 1
			fi
		else
			printf "Could not find version\n"
			printf "dpkg-parsechangelog returned '%d'\n" "${exit_code}"
		fi
	else
		printf "'%s' is not a source package\n" "${repo}"
	fi

	return 0
}
