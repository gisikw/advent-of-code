#!/usr/bin/env raku

sub MAIN($input-file, $part) {
    my @lines = $input-file.IO.lines;
    my $lines-count = @lines.elems;
    say "Received $lines-count lines of input for part $part";
}
