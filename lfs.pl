#! /usr/bin/perl -w

use strict;

my $DEBUG = 1;
my $PATH = "9.0"; # chunks .gz file untarred in pwd

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

my $instr =<<EOT;
#! /bin/bash -x

source funcs.sh

EOT
while($book =~ m!<h2 class="title">\s*<a.*?></a>([\d.]+)&nbsp;(.*?)</h2>!mgs) {
	my ($section, $pkg) = ($1, $2);

	#print "PKG: $pkg\n";
	$pkg = clean_pkg($pkg);

	# compile upto tcl by hand
	# stop _before_ stripping
	$start = 1 if ($pkg =~ /tcl/);
	$end = 1 if ($pkg =~ /stripping/);
	next unless ($start);
	next if ($end);

	$instr .= get_instr($section, $pkg);
}
print $instr . "\n";

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
	my ($section, $topic) = @_;

	my $chapter = substr($section, 0, 1);
	my $file = '';
       	if($topic =~ /^(.*)-/) {
		$file = $1
	}
	$file = "$PATH/chapter0$chapter/$file.html";

	if(! -e $file) {
		print STDERR "$section, $topic, $file\n";
		return;
	}
	open(FH, $file) or die "Could not open $file: $!";
	my $book = do {local $/; <FH>};
	close FH;

	$topic =~ s/tcl-/tcl/;

	my $script =<<EOT;
#============================
startup $section $topic
#----------------------------
untar $topic
#--------
COMMANDS
#--------
cleanup $topic

EOT

	my $cmd;
	while($book =~ m!<kbd.*?>(.*?)</kbd>!mgs) {
		$cmd .= "$1\n";
	}
	chomp $cmd;
	$cmd =~ s/&lt;/</g;
	$cmd =~ s/&gt;/>/g;
	$cmd =~ s/&amp;/&/g;
	$cmd =~ s!<code class="literal">!!g;
	$cmd =~ s!</code>!!g;

	$cmd =~ s!^(\./configure --)!chmod u+x ./configure\n$1!m if($topic =~ /xpect/);

	$script =~ s/COMMANDS/$cmd/;

	return $script;

}
