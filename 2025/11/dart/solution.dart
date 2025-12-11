import 'dart:io';

Map<String,List<String>> paths = new Map<String,List<String>>();

void main(List<String> arguments) async {
  String inputFilePath = arguments[0];
  String part = arguments[1];

  var file = File(inputFilePath);
  var lines = await file.readAsLines();
  for (var line in lines) {
    var parts = line.split(': ');
    paths[parts[0]] = parts[1].split(' ');
  }

  if (part == "1") {
    print(pathsBetween('you','out', 8));
  } else {
    // Note: visually inspected this with graphviz to determine the necessary
    // routing steps and max depth.
    var step1 = pathsBetween('svr', 'fft', 11);
    var step2 = pathsBetween('fft','dac', 17);
    var step3 = pathsBetween('dac','out', 9);
    print(step1 * step2 * step3);
  }
}

int pathsBetween(String src, String tgt, int depth) {
  var neighbors = paths[src];
  if (neighbors == null) return 0;
  if (depth == 0) return 0;
  var result = 0;
  for (String neighbor in neighbors!) {
    if (neighbor == tgt) return 1;
    result += pathsBetween(neighbor, tgt, depth - 1);
  }
  return result;
}
