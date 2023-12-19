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

my @accepts;

sub DFS {
  my ($name, $minX, $maxX, $minM, $maxM, $minA, $maxA, $minS, $maxS) = @_;
  return if $name eq "R";
  if($name eq "A") {
    push(@accepts, [$minX,$maxX,$minM,$maxM,$minA,$maxA,$minS,$maxS]);
    return;
  }
  my @workflow = @{$workflows{$name}};
  my @rules = @{$workflow[1]};
  my $else = $workflow[0];

  for ( @rules ) {
    my ($value, $comparator, $threshold, $target) = @{$_};
    if ($value == 0) {
      if ($comparator eq "<") {
        DFS($target, $minX, $threshold - 1, $minM, $maxM, $minA, $maxA, $minS, $maxS);
        $minX = $threshold;
      } else {
        DFS($target, $threshold + 1, $maxX, $minM, $maxM, $minA, $maxA, $minS, $maxS);
        $maxX = $threshold;
      }
    } elsif ($value == 1) {
      if ($comparator eq "<") {
        DFS($target, $minX, $maxX, $minM, $threshold - 1, $minA, $maxA, $minS, $maxS);
        $minM = $threshold;
      } else {
        DFS($target, $minX, $maxX, $threshold + 1, $maxM, $minA, $maxA, $minS, $maxS);
        $maxM = $threshold;
      }
    } elsif ($value == 2) {
      if ($comparator eq "<") {
        DFS($target, $minX, $maxX, $minM, $maxM, $minA, $threshold - 1, $minS, $maxS);
        $minA = $threshold;
      } else {
        DFS($target, $minX, $maxX, $minM, $maxM, $threshold + 1, $maxA, $minS, $maxS);
        $maxA = $threshold;
      }
    } else {
      if ($comparator eq "<") {
        DFS($target, $minX, $maxX, $minM, $maxM, $minA, $maxA, $minS, $threshold - 1);
        $minS = $threshold;
      } else {
        DFS($target, $minX, $maxX, $minM, $maxM, $minA, $maxA, $threshold + 1, $maxS);
        $maxS = $threshold;
      }
    }
  }
  DFS($else, $minX, $maxX, $minM, $maxM, $minA, $maxA, $minS, $maxS);
}

DFS("in", 1, 4000, 1, 4000, 1, 4000, 1, 4000);
my $sum = 0;
for ( @accepts ) {
  my ($minX, $maxX, $minM, $maxM, $minA, $maxA, $minS, $maxS) = @{$_};
  $sum += ($maxX - $minX + 1) * ($maxM - $minM + 1) * ($maxA - $minA + 1) * ($maxS - $minS + 1);
}
print("$sum\n");
