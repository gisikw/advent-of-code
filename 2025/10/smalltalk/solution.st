| inputFile part lines |
inputFile := Smalltalk arguments at: 1.
part := Smalltalk arguments at: 2.
lines := (File name: inputFile) contents lines.
Smalltalk at: #infinity put: 2147483647.

Object subclass: Machine [
  | password lights buttons presses demand charge cache |

  Machine class >> parse: line [ | inst |
    inst := self new.
    inst init: line.
    ^inst
  ]

  init: line [
    cache := Dictionary new.
    presses := OrderedCollection new.

    buttons := line substrings: $ .

    password := buttons first .
    password := password copyFrom: 2 to: (password size) - 1.
    password := password asOrderedCollection collect: [ :a | a = $# ].
    lights := password collect: [ :a | false].

    demand := buttons last.
    demand := demand copyFrom: 2 to: (demand size) - 1.
    demand := (demand substrings: $,) collect: [ :a | a asInteger ].
    charge := demand collect: [ :a | 0 ].

    buttons removeFirst.
    buttons removeLast.

    buttons := buttons collect: [ :button | |btn|
      btn := button copyFrom: 2 to: (button size) - 1.
      (btn substrings: $,) collect: [ :a | a asInteger ]
    ].
  ]

  postCopy [
    lights := lights copy.
    charge := charge copy.
    presses := presses copy.
  ]

  press: n [
    presses add: n.
    (buttons at: n) do: [ :i |
      lights at: i + 1 put: ((lights at: i + 1) not).
      charge at: i + 1 put: (charge at: i + 1) + 1.
    ]
  ]

  presses [
    ^presses size
  ]

  unlocked [
    ^(lights = password)
  ]

  charged [
    ^(demand = charge)
  ]

  overcharged [
    ^(((1 to: (charge size)) conform: [ :i | (charge at: i) <= (demand at: i) ]) not)
  ]

  gap [
    ^((1 to: (charge size)) inject: 0 into: [ :acc :i | acc + (demand at: i) - (charge at: i) ])
  ]

  chargeStr [
    ^charge inject: '' into: [ :str :c | str,',',(c printString) ]
  ]

  demandStr [
    ^demand inject: '' into: [ :str :c | str,',',(c printString) ]
  ]

  children: repeats [ |btns|
    btns := 1 to: (buttons size).
    btns := repeats ifTrue: [ btns ] ifFalse: [ btns reject: [ :n | presses includes: n ] ].
    ^(btns collect: [:button | |inst|
      inst := self copy.
      inst press: button.
      inst
    ]) asOrderedCollection
  ]

  " Look...should this have been a XOR permutation check instead of BFS? Yes.
    But would I have been playing with Smalltalk in a Smalltalky-way if I had
    done so? "
  minStepsToUnlock [ |queue|
    (self unlocked) ifTrue: [^0].
    queue := self children: false.
    [true] whileTrue: [ |next|
      next := queue removeFirst.
      next unlocked ifTrue: [^next presses].
      queue addAll: (next children: false).
    ]
  ]

  minStepsToJolt [ ^self minStepsToJolt: 0 ]

  minStepsToJolt: depth [ |kids|
    (self charged) ifTrue: [ ^depth ].
    (self overcharged) ifTrue: [ ^nil ].

    kids := SortedCollection sortBlock: [:a :b | (a gap) < (b gap) ].
    kids addAll: (self children: true).

    kids do: [ :kid | |value|
      value := kid minStepsToJolt: (depth + 1).
      (value isNil) ifFalse: [ ^value ]
    ].

    ^nil
  ]

  printOn: stream [
    super printOn: stream.
    (lights inject: '' into: [:str :c | str,(c ifTrue: ['#'] ifFalse: ['.']) ]) printOn: stream.
    stream nextPutAll: ' ('.
    (password inject: '' into: [:str :c | str,(c ifTrue: ['#'] ifFalse: ['.']) ]) printOn: stream.
    stream nextPutAll: ') - '.
    charge printOn: stream.
    stream nextPutAll: ' ('.
    demand printOn: stream.
    stream nextPutAll: ')'.
  ]
]

('!aoc skip') displayNl.
 
((lines collect: [ :line |
  part = '1' ifTrue: [
    (Machine parse: line) minStepsToUnlock
  ] ifFalse: [
    line displayNl.
    (Machine parse: line) minStepsToJolt
  ]
]) inject: 0 into: [ :sum :i | sum + i ]) displayNl.
