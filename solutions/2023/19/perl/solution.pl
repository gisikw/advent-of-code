use strict;
use warnings;
use Data::Dumper;

my %workflows;
my @parts;


my $indices = "xmas";

sub ParseRule {
  my ($str) = @_;
  $str =~ /(\w)([<>])(\d+):(\w+)/;
  [index($indices, $1),$2,$3,$4];
}

sub ParseWorkflow {
  my ($str) = @_;
  $str =~ /^([^{]+)\{(.*),(\w+)\}$/;
  my @parsedRules = map { ParseRule $_ } split(/,/, $2);
  ($1, $3, @parsedRules);
}

my ($input_file, $part) = @ARGV;
open my $fh, '<', $input_file or die "Can't open file $!";

# Parse Workflows
while (my $line = <$fh>) {
  last if $line eq "\n";
  next if $line eq "\n";
  my ($name, $else, @rules) = ParseWorkflow($line);
  $workflows{$name} = [$else, [@rules]];
}

# Parse Parts
while (my $line = <$fh>) {
  my @matches = ($line =~ /=(\d+)/g);
  push @parts, [@matches];
}

close $fh;

if($part eq "1") {
  my $sum = 0;
  for ( @parts ) {
    my @p = @{$_};
    my $next = "in";

    while ($next ne "R" && $next ne "A") {
      my @workflow = @{$workflows{$next}};
      my @rules = @{$workflow[1]};

      $next = $workflow[0];
      for ( @rules ) {
        my ($value, $comparator, $threshold, $target) = @{$_};
        if($comparator eq "<") {
          if($p[$value] < $threshold) {
            $next = $target;
            last;
          }
        } elsif($p[$value] > $threshold) {
          $next = $target;
          last;
        }
      }
    }

    if ($next eq "A") {
      $sum += $p[0] + $p[1] + $p[2] + $p[3];
    }
  }

  print("$sum\n");
  exit 0;
}

# Graph traversal - find the min/max accepted ranges for x,m,a,s...except no!
# That won't work, because the conditions aren't free to vary independently.
# e.g. 100 <= x <= 200 may only be fine when m < 4
# 
# Does it make sense to crawl this backwards? Find all accepts, and branch out
# backwards? This feels like a repeat of a prior day as well. Day 5
#
# I feel like we can merge these nodes? Bubble them up, so to speak?
# mtn is R,R, so any direct to mtn can be replaced with a direct to R, and we can remove that node
# pk{s<2557:A,R}
# hrq{m>912:zn,s<2570:pk,x<3198:A,A} could thus be replaced as
# hrq{m>912:zn,(s<2557:A,2557 < s < 2570:R),x<3198:A,A} could thus be replaced as
#
# Okay, so how about this:
# - Convert every rule to x,m,a,s lb-ub to be accepted
# - Propagate backward from terminals, until we have a range for x,m,a, and s
