# Package compilation scripts for Maratona Linux

The scripts in this directory may be used to compile the Debian packages that
compose Maratona Linux. These packages, with the exception of `boca` and
`maratona-fancy-tools` can be found in the
[Maratona-Linux](https://github.com/maratona-linux/maratona-linux) repository.

Maratona-Linux's source code is found in the organisation pages in
[GitHub](https://github.com/maratona-linux) and
[GitLab](https://gitlab.com/maratona-linux). The closely related package `boca`
can be found at its Github [repository](https://github.com/cassiopc/boca).

One of the scripts depends on the `pdg` tool, which can be found in its
[GitLab](https://gitlab.com/DaviAntonio/pdg) or
[GitHub](https://github.com/DaviAntonio/pdg) repositories. The aforementioned
script also depends on Graphviz and the Python 3 interpreter.

## The compilation procedures and their outputs

The following steps are necessary to compile the packages. Depending on the
machine that will be used to compile the packages, some modifications may
need to be performed on the scripts.

### Compilation instructions

The standard package compilation routine can be performed by executing the
`compile-all.sh` script. It will compile source and binary Debian packages
for the following projects, which MUST be present in the script's directory:
- maratona-background
- maratona-firewall
- maratona-meta
- maratona-submission
- maratona-team-tools
- maratona-usuario-icpc
- maratona-flatpak-common
- maratona-kairos
- maratona-visual-studio-code
- maratona-intellij-idea
- maratona-intellij-pycharm
- maratona-intellij-clion
- boca
- maratona-fancy-tools

If any of the packages listed above are not available in the scripts'
directory, they must be removed from the list of packages to compile in the
`compile-all.sh` script.

The `compile-all.sh` script will also generate a packages index file,
`Packages.gz`; generate a dependency graphs in the EPS format of all the
compiled packages; and generate a report containing the build information.

The generation of the "upstream tarballs" required to compile a Debian source
package is delegated to an auxiliary script, which automatically generates them
when it detects that the project to be compiled is a regular, non-native,
Debian package.
