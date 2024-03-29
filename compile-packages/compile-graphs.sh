#!/bin/bash

graphs() {
	local -r pdg_path="$1"
	local -r packages_dir="$2"

	# Generating graph
	printf "\nGenerating dependency graph\n"
	"${pdg_path}" g "${packages_dir}/Packages.gz" | dot -Teps > "depgraph-$(date --iso-8601='minutes').eps"

	printf "\nGenerating legend graph\n"
	"${pdg_path}" l "${packages_dir}/Packages.gz" | dot -Teps > "legend-$(date --iso-8601='minutes').eps"

	printf "\nDone\n"
	return 0
}
