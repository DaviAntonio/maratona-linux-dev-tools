#!/bin/bash

make_orig() {
	local -r repo="$1"

		# Check if directory contains a source package
	if grep '(quilt)' "${repo}/debian/source/format"; then
		printf "'%s' is a source package, reading its version\n" "${repo}"

		local version=$(dpkg-parsechangelog --file "${repo}/debian/changelog" --show-field 'Version')
		local exit_code=$?

		if [[ $exit_code == 0 ]]; then
			printf "Found version '%s'\n" "${version}"
			version="${version%-*}"
			printf "Upstream version is '%s'\n" "${version}"
			tar --exclude=debian --exclude=.git \
				--use-compress-program='xz -9' \
				-cvf "${repo}-${version}.tar.xz" "${repo}"
			ln --verbose \
				--symbolic \
				"${repo}-${version}.tar.xz" "${repo}_${version}.orig.tar.xz"
		else
			printf "Could not find version\n"
			printf "dpkg-parsechangelog returned '%d'\n" "${exit_code}"
		fi
	else
		printf "'%s' is not a source package\n" "${repo}"
	fi

	return 0
}
