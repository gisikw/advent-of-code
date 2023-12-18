import 'dart:io';

void main(List<String> arguments) async {
  String inputFilePath = arguments[0];
  String part = arguments[1];

  var file = File(inputFilePath);
  var lines = await file.readAsLines();
  int linesCount = lines.length;

  print('Received $linesCount lines of input for part $part');
}
