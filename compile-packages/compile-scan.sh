#!/bin/bash

scan() {
	local packages_dir="$1"

	# Scan the packages
	printf "\nRun dpkg-scanpackages\n"
	dpkg-scanpackages "$packages_dir" | gzip > "${packages_dir}/Packages.gz"

	printf "\nDone\n"
	return 0
}
