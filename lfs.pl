#! /usr/bin/perl -w

use strict;

my $DEBUG = 1;
my $PATH = "9.0/chapter05"; # chunks .gz file untarred in pwd

# Read no chunks html
open(FH, 'lfs.html') or die "Could not open book: $!";
my $book = do {local $/; <FH>};
close FH;

# match sections like the below
# Extract package name from it
# e.g Tcl-8.6.9
=head
#                  <h2 class="title">
#                    <a id="ch-tools-tcl" name=
#                    "ch-tools-tcl"></a>5.11.&nbsp;Tcl-8.6.9
#                  </h2>
=cut

my $sect;
my $start = 0;
my $end = 0;
while($book =~ m!<h2 class="title">\s*<a.*?></a>5.[\d.]+&nbsp;(.*?)</h2>!mgs) {
	my $pkg .= $1;

	#print "PKG: $pkg\n";
	$pkg = clean_pkg($pkg);

	# compile upto tcl by hand
	# stop _before_ stripping
	$start = 1 if ($pkg =~ /tcl/);
	$end = 1 if ($pkg =~ /stripping/);
	next unless ($start);
	next if ($end);

	my $instr = get_instr($pkg);
	print $instr . "\n";
}

sub clean_pkg {
	my($pkg) = @_;
	$pkg =~ s/^\s*//;   # strip leading whitespace
	$pkg =~ s/\s*$//;   # strip trailing whitespace
	$pkg =~ s/\s+/ /sg; # squash whitespace

	# Specific adjustments
	$pkg = lc $pkg unless ($pkg =~ /Python/);

	#print "CLEAN: $pkg\n" if($DEBUG);
	return $pkg;
}

sub get_instr {
	my ($topic) = @_;

	my $file = '';
       	if($topic =~ /^(.*)-/) {
		$file = $1
	}
	$file = "$PATH/$file.html";

	open(FH, $file) or die "Could not open $file: $!";
	my $book = do {local $/; <FH>};
	close FH;

	$topic =~ s/tcl-/tcl/;
	my $script = "untar($topic)\n";;
	while($book =~ m!<kbd.*?>(.*?)</kbd>!mgs) {
		my $instr = $1;
		$script .= $instr . "\n";
	}
	$script .= "cleanup($topic)\n";
	return $script;

}
