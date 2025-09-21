#!/bin/bash

readonly original_dir="$(pwd)"
readonly packages_dir="packages"
readonly packages_info_dir="packages-buildinfo"
readonly packages_source_info_dir="source-packages-buildinfo"
readonly pdg_path="./link-pdg"

trash() {
	printf "Sending '%s' to thrash directory\n" "$1"
	gio trash "$1"
}

glob_trash() {
	for file in $1; do
		[ -e "$file" ] || continue
		trash "$file"
	done
}

cleanup() {
	if [[ $(command -v gio) != 0 ]]; then
		# Definitive removal
		rm -vf -- *.deb

		rm -vf -- *.build
		rm -vf -- *.buildinfo
		rm -vf -- *.changes
		rm -vf -- *.dsc
		rm -vf -- *.tar.*
	else
		# Send to the thrash directory
		glob_trash ./*.deb

		glob_trash ./*.build
		glob_trash ./*.buildinfo
		glob_trash ./*.changes
		glob_trash ./*.dsc
		glob_trash ./*.tar.*
	fi
}

initial_setup() {
	mkdir -p "$packages_dir" || exit
	mkdir -p "$packages_info_dir" || exit
	mkdir -p "$packages_source_info_dir" || exit

	printf "\nCleaning remains\n"
	cleanup

	printf "\nCleaning %s\n" "$packages_dir"
	trash "$packages_dir" || exit

	printf "\nCleaning %s\n" "$packages_info_dir"
	trash "$packages_info_dir" || exit

	printf "\nCleaning %s\n" "$packages_source_info_dir"
	trash "$packages_source_info_dir" || exit

	# create dirs for build artifacts
	mkdir "$packages_dir" || exit
	mkdir "$packages_info_dir" || exit
	mkdir "$packages_source_info_dir" || exit

	return 0
}
