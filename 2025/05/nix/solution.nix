let
  pkgs = import <nixpkgs> { };
  lib = pkgs.lib;
  inputFile = builtins.getEnv "INPUT_FILE";
  part = builtins.getEnv "PART";
  content = builtins.readFile inputFile;
  lines =
    builtins.filter (x: builtins.isString x) (builtins.split "\n" content);
  split = builtins.partition (lib.strings.hasInfix "-") lines;
  unmergedRanges = (builtins.sort (a: b: a.min < b.min) (map (s:
    let
      nums = map lib.strings.toInt
        (builtins.filter (x: builtins.isString x) (builtins.split "-" s));
    in {
      min = (builtins.elemAt nums 0);
      max = (builtins.elemAt nums 1);
    }) split.right));
  ranges = builtins.foldl' (acc: el:
    (let
      head = builtins.head acc;
      tail = builtins.tail acc;
    in if el.max <= head.max then
      acc
    else if el.min <= head.max then
      [{
        min = head.min;
        max = el.max;
      }] ++ tail
    else
      [ el ] ++ acc)) [ (builtins.head unmergedRanges) ]
    (builtins.tail unmergedRanges);
  ingredients = map (s: lib.strings.toInt s)
    (builtins.filter (x: (builtins.stringLength x) > 0) split.wrong);
  fresh = (builtins.filter (ingredient:
    (builtins.any (range: ingredient >= range.min && ingredient <= range.max)
      ranges)) ingredients);
  freshCount = (builtins.length fresh);
  possibleFreshCount = (builtins.foldl' builtins.add 0
    (map (range: range.max - range.min + 1) ranges));
  solution = if part == "1" then freshCount else possibleFreshCount;
in toString solution
