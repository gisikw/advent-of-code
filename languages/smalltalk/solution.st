| inputFile part lines |
inputFile := Smalltalk arguments at: 1.
part := Smalltalk arguments at: 2.
lines := (File name: inputFile) contents lines.

('Received ', lines size printString, ' lines of input for part ', part) displayNl.
