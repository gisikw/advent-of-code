<?php
$inputFile = $argv[1];
$part = $argv[2];

$lines = file($inputFile, FILE_IGNORE_NEW_LINES | FILE_SKIP_EMPTY_LINES);

$sum = 0;
for ($i = 0; $i < count($lines); $i += 3) {
  preg_match('/X\+(\d+).*Y\+(\d+)/', $lines[$i], $matches);
  $aX = $matches[1];
  $aY = $matches[2];

  preg_match('/X\+(\d+).*Y\+(\d+)/', $lines[$i+1], $matches);
  $bX = $matches[1];
  $bY = $matches[2];

  preg_match('/X=(\d+).*Y=(\d+)/', $lines[$i+2], $matches);
  $x = $matches[1];
  $y = $matches[2];

  if ($part == "2") {
    $x = $x + 10000000000000;
    $y = $y + 10000000000000;
  }

  $divisor = $aX * $bY - $bX * $aY;
  $a = ($x * $bY - $bX * $y) / $divisor;
  $b = ($aX * $y - $x * $aY) / $divisor;
  if ((int) $a == $a && (int) $b == $b) {
    $sum += ($a * 3 + $b);
  }
}
echo $sum;
