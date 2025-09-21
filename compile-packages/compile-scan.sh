#!/bin/bash

scan() {
	local -r original_dir="$(pwd)"
	local -r packages_dir="$1"

	printf "Generating '%s'\n" "${packages_dir}/Packages.gz"

	# go into directory
	cd "$packages_dir" || exit

	# Scan the packages
	printf "\nRun dpkg-scanpackages\n"
	dpkg-scanpackages . | gzip > "Packages.gz"

	cd "$original_dir"

	return 0
}
