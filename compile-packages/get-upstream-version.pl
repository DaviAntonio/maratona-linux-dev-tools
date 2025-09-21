use Capture::Tiny qw(capture);

my $changelog = ${ARGV[0]};

if (! -f $changelog) {
	exit 1;
}

my @cmd = ('dpkg-parsechangelog', '--file', $changelog, '--show-field', 'Version');
my ($stdout, $stderr, $exit_code) = capture(sub {
	system @cmd;
});

if ($exit_code != 0) {
	exit 2;
}

my $regex = qr/((?<epoch>\d):)?(((?<upstream_non_native>\d[A-Za-z0-9.+\-~]*)(-(?<revision>[A-Za-z0-9.+~]+)))|((?<upstream_native>\d[A-Za-z0-9.+~]*)))/m;

if ($stdout =~ /$regex/g) {
	if (! defined $+{upstream_non_native} && ! defined $+{upstream_native}) {
		exit 3;
	} else {
		printf "%s\n", defined $+{upstream_non_native} ? $+{upstream_non_native} : $+{upstream_native};
	}
} else {
	exit 4;
}

exit 0;
