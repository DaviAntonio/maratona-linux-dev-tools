#!/bin/bash

sources() {
	local -r repo="$1"
	local -r packages_source_info_dir="$2"

	# go into directory
	cd "$repo" || exit

	# clean repo again
	debclean

	# For launchpad
	# Run lintian
	# Sign everything (to not sign everything, add --no-sign)
	# Build only source packages
	# Forces the original source
	# Assumes DEBUILD_DPKG_BUILDPACKAGE_OPTS="--sign-key=key -sa"
	# debuild does not like --build=source, go with -S
	printf "\nCompiling 'source' build arifacts\n"
	time debuild -S -i \
		-I.git -I.gitattributes -I.gitignore -I.gitmodules -I.gitreview \
		--lintian-opts -EviIL +pedantic --profile ubuntu
	printf "\nFinished compiling 'source' build arifacts\n"

	# clean repo again
	debclean

	# return
	cd .. || exit

	# move results
	printf "\nMoving 'source' build arifacts\n"

	mv --verbose -- *.build "$packages_source_info_dir"
	mv --verbose -- *.buildinfo "$packages_source_info_dir"
	mv --verbose -- *.changes "$packages_source_info_dir"
	mv --verbose -- *.dsc "$packages_source_info_dir"
	mv --verbose -- *.tar.* "$packages_source_info_dir"

	printf "\nDone\n"
	return 0
}
