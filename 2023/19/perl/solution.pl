use strict;
use warnings;

my $indices = "xmas";
sub parse_rule {
  my ($str) = @_;
  $str =~ /(\w)([<>])(\d+):(\w+)/;
  [index($indices, $1),$2,$3,$4];
}

sub parse_workflow {
  my ($str) = @_;
  $str =~ /^([^{]+)\{(.*),(\w+)\}$/;
  my @parsedRules = map { parse_rule $_ } split(/,/, $2);
  ($1, $3, @parsedRules);
}

sub parse_file {
  my ($input_file) = @_;
  my %workflows;
  my @parts;
  open my $fh, '<', $input_file or die "Can't open file $!";
  while (my $line = <$fh>) {
    last if $line eq "\n";
    my ($name, $else, @rules) = parse_workflow($line);
    $workflows{$name} = [$else, [@rules]];
  }
  while (my $line = <$fh>) {
    my @matches = ($line =~ /=(\d+)/g);
    push @parts, [@matches];
  }
  close $fh;
  return (\%workflows, \@parts);
}

sub process_workflow {
  my ($workflows, $current, $part) = @_;
  my @rules = @{$workflows->{$current}[1]};
  my $default = $workflows->{$current}[0];

  for my $rule (@rules) {
    my ($value, $comparator, $threshold, $target) = @$rule;
    if (($comparator eq "<" && $part->[$value] < $threshold) || 
        ($comparator eq ">" && $part->[$value] > $threshold)) {
      return $target;
    }
  }
  return $default;
}

my @accepts;
my ($input_file, $part) = @ARGV;
my ($workflows_ref, $parts_ref) = parse_file($input_file);
my %workflows = %{$workflows_ref};
my @parts = @{$parts_ref};

sub DFS {
  my ($name, @bounds) = @_;
  return if $name eq "R";
  if($name eq "A") {
    push(@accepts, [@bounds]);
    return;
  }
  my @workflow = @{$workflows{$name}};
  my @rules = @{$workflow[1]};
  my $else = $workflow[0];
  for my $rule (@rules) {
    my ($value, $comparator, $threshold, $target) = @$rule;
    my $min_index = $value * 2;
    my $max_index = $min_index + 1;
    if ($comparator eq "<") {
      DFS($target, @bounds[0..$min_index], $threshold - 1, @bounds[$max_index+1..$#bounds]);
      $bounds[$min_index] = $threshold;
    } else {
      DFS($target, @bounds[0..$min_index-1], $threshold + 1, @bounds[$max_index..$#bounds]);
      $bounds[$max_index] = $threshold;
    }
  }
  DFS($else, @bounds);
}

my $sum = 0;
if($part eq "1") {
  for my $elfpart (@parts) {
    my $next = "in";
    while ($next ne "R" && $next ne "A") {
      ($next) = process_workflow(\%workflows, $next, $elfpart);
    }
    if ($next eq "A") {
      $sum += $elfpart->[0] + $elfpart->[1] + $elfpart->[2] + $elfpart->[3];
    }
  }
} else {
  DFS("in", 1, 4000, 1, 4000, 1, 4000, 1, 4000);
  for ( @accepts ) {
    my ($minX, $maxX, $minM, $maxM, $minA, $maxA, $minS, $maxS) = @{$_};
    $sum += ($maxX - $minX + 1) * ($maxM - $minM + 1) * ($maxA - $minA + 1) * ($maxS - $minS + 1);
  }
}
print("$sum\n");
