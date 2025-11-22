let
  inputFile = builtins.getEnv "INPUT_FILE";
  part = builtins.getEnv "PART";
  content = builtins.readFile inputFile;
  lines = builtins.filter (x: builtins.isString x) (builtins.split "\n" content);
in
 "Received ${toString ((builtins.length lines) - 1)} lines of input for part ${part}\n"
