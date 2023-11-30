<?php
$inputFile = $argv[1];
$part = $argv[2];

$lines = file($inputFile, FILE_IGNORE_NEW_LINES | FILE_SKIP_EMPTY_LINES);
$linesCount = count($lines);

echo "Received $linesCount lines of input for part $part\n";
