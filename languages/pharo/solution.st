| args f p n |
args := Smalltalk arguments.
f := args at: 2. p := args at: 3.
n := f asFileReference contents lines size.
Stdio stdout nextPutAll: 'Received ', n printString, ' lines of input for part ', p; lf; flush.
Smalltalk snapshot: false andQuit: true.
