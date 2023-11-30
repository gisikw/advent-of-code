use strict;
use warnings;

my ($input_file, $part) = @ARGV;
open my $fh, '<', $input_file or die "Can't open file $!";
my $lines = 0;
$lines++ while (<$fh>);
close $fh;

print "Received $lines lines of input for part $part\n";
