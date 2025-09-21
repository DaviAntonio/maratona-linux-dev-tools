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

Some features depend on havinga valid GLib2 and GVFS installation. They can be
easily replaced by standard, yet less convenient, tools.

## Dependencies

Without any customisation, the scripts currently depend on:

- GLib2
- GVFS
- [pdg](https://gitlab.com/DaviAntonio/pdg)
- GNU Bash
- Graphviz
- Debian devscripts
- Debian dpkg
- Debian dpkg-dev
- Debian debhelper
- sbuild (unshare-based setup)
- Perl with Capture::Tiny
- apt-cacher-ng
- mmdebstrap
- pixz

### Setting sbuild up

Install as root the packages: `apt install sbuild mmdebstrap uidmap apt-cacher-ng`

Create a build directory. You may place it in your home directory, as the build
script expects this location: `mkdir -p ~/.cache/sbuild`.

Generate a *chroot* for Ubuntu 24.04 with the *buildd* profile and pointing to
the APT cache:
`mmdebstrap --skip=output/dev --variant=buildd noble ~/.cache/sbuild/noble-amd64.tar.zst http://archive.ubuntu.com/ubuntu --aptopt='Acquire::http { Proxy "http://127.0.0.1:3142"; }'`

Copy the following contents to `~/.config/sbuild/config.pl`:
```perl
# example for ~/.sbuildrc.  (Also see /etc/sbuild/sbuild.conf.)  -*- Perl -*-
# Note: this file now should be located at ~/.config/sbuild/config.pl
#
# Default settings are commented out.
# Additional options found in /etc/sbuild/sbuild.conf may be
# overridden here.


##
## DPKG-BUILDPACKAGE OPTIONS
##

# Name to use as override in .changes files for the Maintainer: field
# Defaults to the DEBEMAIL environment variable, if set, or else the
# Maintainer: field will not be overridden unless set here.
#$maintainer_name='Francesco Paolo Lovergine <frankie@debian.org>';

# Name to use as override in .changes file for the Changed-By: field.
#$uploader_name='Francesco Paolo Lovergine <frankie@debian.org>';

# Key ID to use in .changes for the current upload.
# It overrides both $maintainer_name and $uploader_name
#$key_id='Francesco Paolo Lovergine <frankie@debian.org>';

# PGP-related option to pass to dpkg-buildpackage. Usually neither .dsc
# nor .changes files shall be signed automatically.
#$pgp_options = ['-us', '-uc'];

# By default, do not build a source package (binary only build).
# Set to 1 to force creation of a source package, but note that
# this is inappropriate for binary NMUs, where the option will
# always be disabled.
#$build_source = 0;

# By default, the -s option only includes the .orig.tar.gz when needed
# (i.e. when the Debian revision is 0 or 1).  By setting this option
# to 1, the .orig.tar.gz will always be included when -s is used.
# This is equivalent to --force-orig-source.
#$force_orig_source = 0;

# PATH to set when running dpkg-buildpackage.
#$path = "/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/X11R6/bin:/usr/games";

# This command is run with the dpkg-buildpackage command line passed to it
# (in the chroot, if doing a chrooted build).  It is used by the sparc buildd
# (which is sparc64) to call the wrapper script that sets the environment to
# sparc (32-bit).  It could be used for other build environment setup scripts
#
#$build_env_cmnd = "";


##
## SBUILD BEHAVIOUR
##

# Default distribution.  By default, no distribution is defined, and
# the user must specify it with the -d option.  However, a default may
# be configured here if desired.  Users must take care not to upload
# to the wrong distribution when this option is set, for example
# experimental packages will be built for upload to unstable when this
# is not what is required.
#$distribution = 'unstable';

# Default chroot (defaults to distribution[-arch][-sbuild])
#$chroot = 'unstable-powerpc-sbuild';

# When to purge the build directory afterwards; possible values are "never",
# "successful", and "always"
#$purge_build_directory="successful";

# sbuild behaviour; possible values are "user" (exit status reports
# build failures) and "buildd" (exit status does not report build
# failures) for use in a buildd setup.
#$sbuild_mode = "user";


##
## TIMEOUTS
##

# Time to wait for a source dependency lock.  The default is 1 minute.
#$srcdep_lock_wait = 1; # 1 minute

# Time (in minutes) of inactivity after which a build is terminated. Activity
# is measured by output to the log file.
#$stalled_pkg_timeout = 150;

# Some packages may exceed the general timeout (e.g. redirecting output to
# a file) and need a different timeout. Below are some examples.
#%individual_stalled_pkg_timeout = (smalleiffel => 300,
#				   jade => 300,
#				   atlas => 300,
#				   glibc => 1000,
#				   'gcc-3.3' => 300,
#				   kwave => 600);
#

##
## FILE AND DIRECTORY LOCATIONS
##

# This option is deprecated.  Directory for chroot symlinks and sbuild
# logs.  Defaults to the current directory if unspecified.  It is used
# as the location of chroot symlinks (obsolete) and for current build
# log symlinks and some build logs.  There is no default; if unset, it
# defaults to the current working directory.  $HOME/build is another
# common configuration.
#$build_dir = undef;

# Directory for writing build logs to
#$log_dir = "$HOME/logs";

# Directory for writing build statistics to
#$stats_dir = "$HOME/stats";


################################################################################

## Configurações da construção

# -d
# Por padrão realiza o build para unstable
$distribution = 'unstable';

# -A
# Faz o build de pacotes arch-independent.
$build_arch_all = 1;

# -s
# Produz um source package (.dsc) além do pacote binário.
$build_source = 1;

# --source-only-changes
# Uploads para o Debian precisam ser, na grande maioria das vezes, source-only.
$source_only_changes = 1;

# Não executa o "clean" target fora do chroot.
$clean_source = 0;

# -v
$verbose = 1;

# parallel build
$ENV{'DEB_BUILD_OPTIONS'} = 'parallel=16';

# --chroot-mode=schroot|sudo|autopkgtest|unshare
# modo de execução do chroot
# O Debian passou a usar o modo unshare
# O modo antigo é ativado com a sseguintes opções:
# $chroot_mode = "schroot";
# $schroot = "schroot";
$chroot_mode = 'unshare';

## Configurações pós-construção

# Sempre executa o lintian no final dos builds.
$run_lintian = 1;
#$lintian_opts = ['--info', '--display-info'];
#-EviIL +pedantic --profile ubuntu/ -EviI
$lintian_opts = ['--display-experimental', '--verbose', '--info', '--display-info', '--display-level', '+pedantic'];

################################################################################

# don't remove this, Perl needs it:
1;
```

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

## Signing the packages

The packages must be signed before sending them to the PPA. This is done using
the `debsign *.changes`. This requires a valid Debian GPG key and the following
variables available: `DEBEMAIL`, `DEBFULLNAME` and
`DEBUILD_DPKG_BUILDPACKAGE_OPTS` with their correct contents pointing to the
signing key.