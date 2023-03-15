#!/bin/bash

source ./compile-aux.sh
source ./compile-binary.sh
source ./compile-source.sh
source ./compile-scan.sh
source ./compile-graphs.sh
source ./create-orig.sh

readonly repos=(
"maratona-background"
"maratona-firewall"
"maratona-meta"
"maratona-submission"
"maratona-team-tools"
"maratona-usuario-icpc"
"maratona-flatpak-common"
"maratona-kairos"
"maratona-visual-studio-code"
"maratona-intellij-idea"
"maratona-intellij-pycharm"
"maratona-intellij-clion"
"boca"
"maratona-fancy-tools"
)

main() {
	initial_setup

	for repo in "${repos[@]}"; do
		make_orig "$repo"
		binaries "$repo" "$packages_dir" "$packages_info_dir"
		make_orig "$repo"
		sources "$repo" "$packages_source_info_dir"
	done

	# Scan the packages
	scan "$packages_dir"

	# Generating graph
	graphs "$pdg_path" "$packages_dir"

	printf "\nDone\n"
	exit 0
}

main 2>&1 | tee "$(date --iso-8601='minutes').log"
