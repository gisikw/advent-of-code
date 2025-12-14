| inputFile part lines |
inputFile := Smalltalk arguments at: 1.
part := Smalltalk arguments at: 2.
lines := (File name: inputFile) contents lines.
Smalltalk at: #infinity put: 2147483647.

Object subclass: Machine [
  | password lights buttons presses pressCount charge cache |

  Machine class >> bestSoFar [ ^BestSoFar ]
  Machine class >> bestSoFar: x [ BestSoFar := x ]

  Machine class >> parse: line [ | inst |
    inst := self new.
    inst init: line.
    ^inst
  ]

  init: line [
    presses := OrderedCollection new.
    pressCount := 0.

    Machine bestSoFar: infinity.
    cache := Dictionary new.

    buttons := line substrings: $ .

    password := buttons first .
    password := password copyFrom: 2 to: (password size) - 1.
    password := password asOrderedCollection collect: [ :a | a = $# ].
    lights := password collect: [ :a | false].

    charge := buttons last.
    charge := charge copyFrom: 2 to: (charge size) - 1.
    charge := (charge substrings: $,) collect: [ :a | a asInteger ].

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
    pressCount := pressCount + 1.
    (buttons at: n) do: [ :i |
      lights at: i + 1 put: ((lights at: i + 1) not).
      charge at: i + 1 put: (charge at: i + 1) - 1.
    ]
  ]

  " Only used for part 2, so partial implementation "
  press: n times: t [
    pressCount := pressCount + t.
    (buttons at: n) do: [ :i |
      charge at: i + 1 put: (charge at: i + 1) - t.
    ]
  ]

  presses [
    ^presses size
  ]

  unlocked [
    ^(lights = password)
  ]

  charged [
    ^charge conform: [ :c | c = 0 ]
  ]

  overcharged [
    ^(charge conform: [ :c | c >= 0 ]) not
  ]

  " Heuristics are fun "
  mostConstrainedIndex [ |minVal minIndex|
    minVal := infinity.
    ((1 to: (charge size)) reject: [ :i | (charge at: i) = 0 ]) do: [ :i | |heuristic value rows|
      rows := ((buttons select: [ :btn | btn includes: i - 1 ]) size).
      value := charge at: i.

      " Try various options; some are faster for various inputs. binomial
      should theoretically be best, but was too slow here. "
      heuristic := rows.
      "
      heuristic := value.
      heuristic := rows * value.
      heuristic := self binomial: (value + rows - 1) choose: (rows - 1).
      "

      (heuristic < minVal) ifTrue: [ minVal := heuristic. minIndex:= i ]
    ]. 
    ^minIndex
  ]

  binomial: n choose: k [ |res|
    res := 1.
    1 to: k do: [ :i | res := res * (n - n + i) / i. ].
    ^res
  ]

  countPartitions: rows toMake: num [ |count|
    ((rows size) = 1) ifTrue: [^1].
    count := 0.
    0 to: num do: [ :n |
      count := count + (self countPartitions: (rows copyFrom: 2) toMake: num - n).
    ].
    ^count.
  ]

  chargeStr [
    ^charge inject: '' into: [ :str :c | str,',',(c printString) ]
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

  bestPartitions [ |minPartition minSize|
    minSize := infinity.
    minPartition := 5.
    ((1 to: (charge size)) do: [ :col |
      ((charge at: col) > 0) ifTrue: [ |partition partitionSize|
        partition := self allRowPartitions: col.
        partitionSize := partition size.
        ((partition size) < minSize) ifTrue: [
          minPartition := partition.
          minSize := partitionSize.
        ]
      ]
    ]).
    ^minPartition.
  ]

  countRowPartitions: col [ |val rows|
    val := charge at: col.
    rows := (1 to: (buttons size)) select: [ :b | (buttons at: b) includes: col - 1 ].
    ^self countRowPartitions: rows toMake: val
  ]

  "
  countRowPartitions: rows toMake: num [
    ((rows size = 1)) ifTrue: [ ^1 ].
    (0 to :num) do: [ :n |

    ]
  ]
  "

  allRowPartitions: col [ |val rows|
    val := charge at: col.
    rows := (1 to: (buttons size)) select: [ :b | (buttons at: b) includes: col - 1 ].
    ^self allRowPartitions: rows toMake: val
  ]

  allRowPartitions: rows toMake: num [ |res|
    res := OrderedCollection new.
    self allRowPartitions: rows toMake: num into: res.
    ^res select: [ :dict | self validPartition: dict ]
  ]

  allRowPartitions: rows toMake: num into: results [
    ((rows size = 1)) ifTrue: [
      results add: (Dictionary new at: (rows first) put: num; yourself).
    ] ifFalse: [
      (0 to: num) do: [ :n |
        self allRowPartitions: (rows copyFrom: 2) 
          toMake: num - n 
          into: results 
          with: (Dictionary new at: (rows first) put: n; yourself)
      ]
    ]
  ]

  allRowPartitions: rows toMake: num into: results with: partial [
    ((rows size = 1)) ifTrue: [
      partial at: (rows first) put: num.
      results add: (partial copy).
    ] ifFalse: [
      (0 to: num) do: [ :n |
        partial at: (rows first) put: n.
        self allRowPartitions: (rows copyFrom: 2)
          toMake: num - n
          into: results
          with: partial
      ]
    ]
  ]

  validPartition: dict [
    ^(1 to: (charge size)) conform: [ :col | |val|
      val := charge at: col. 
      dict keysAndValuesDo: [ :idx :coefficient |
        ((buttons at: idx) includes: col - 1) ifTrue: [
          val := val - coefficient.
        ]
      ].
      val >= 0
    ]
  ]

  "
  minStepsToJolt [ |minSeen|
    (pressCount + (charge inject: 0 into: [ :m :c | m max: c ]) >= Machine bestSoFar) ifTrue: [ ^infinity ].
    (self charged) ifTrue: [ Machine bestSoFar: ((Machine bestSoFar) min: pressCount). ^pressCount ].

    minSeen := infinity.
    (self bestPartitions) do: [ :partitions | |res inst|
      inst := self copy.
      partitions keysAndValuesDo: [ :idx :coefficient |
        inst press: idx times: coefficient
      ].
      res := inst minStepsToJolt.
      minSeen := minSeen min: res.
    ].
    ^minSeen.
  ]
  "

  minStepsToJolt [ |idx options res|
    " (pressCount >= Machine bestSoFar) ifTrue: [ ^infinity ]. "
    (pressCount + (charge inject: 0 into: [ :m :c | m max: c ]) >= Machine bestSoFar) ifTrue: [ ^infinity ].
    (self charged) ifTrue: [ Machine bestSoFar: ((Machine bestSoFar) min: pressCount). ^pressCount ].
    (self overcharged) ifTrue: [ ^infinity ].
    "
    (cache includesKey: charge) ifTrue: [ 
      'cache hit' displayNl.
      ^cache at: charge
    ].
    "

    idx := self mostConstrainedIndex.
    options := ((1 to: (buttons size)) 
      select: [ :i | (buttons at: i) includes: idx - 1 ])
      sorted: [ :a :b | (buttons at: 1) size < (buttons at: b) size ].

    res := self minStepsPartition: (charge at: idx) between: options.
    "cache at: charge put: res."
    ^res
  ]

  minStepsPartition: coefficient between: btns [ |minSeen|
    ((btns size) = 1) ifTrue: [ |inst|
      inst := self copy.
      inst press: (btns first) times: coefficient.
      ^inst minStepsToJolt 
    ].
    minSeen := infinity.
    (0 to: coefficient) do: [ :num | |inst res|
      inst := self copy.
      inst press: (btns first) times: num.
      res := (inst minStepsPartition: (coefficient - num) between: (btns copyFrom: 2)).
      minSeen := minSeen min: res.
    ].
    ^minSeen
  ]

  printOn: stream [
    super printOn: stream.
    (lights inject: '' into: [:str :c | str,(c ifTrue: ['#'] ifFalse: ['.']) ]) printOn: stream.
    stream nextPutAll: ' ('.
    (password inject: '' into: [:str :c | str,(c ifTrue: ['#'] ifFalse: ['.']) ]) printOn: stream.
    stream nextPutAll: ') - '.
    charge printOn: stream.
  ]
]

"
m := Machine parse: (lines first).
m minStepsToJolt displayNl.
"
"
('!aoc skip') displayNl.
m := Machine parse: (lines first).
m displayNl.
m allRowPartitions: 6 displayNl.
(m bestPartitions) displayNl.
m mostConstrainedIndex displayNl.
"

((lines collect: [ :line |
  part = '1' ifTrue: [
    (Machine parse: line) minStepsToUnlock
  ] ifFalse: [ |res|
    " This ran successfully on a good ~170 lines before the logic was ported to
    Rust. I'm confident that it would have gotten there eventually, but we'd be
    looking at runtime of weeks. Lots of optimizations were tried; the overhead
    or memory constraints necessitated unrolling them. "
    line displayNl.
    res := (Machine parse: line) minStepsToJolt.
    res displayNl.
    res
  ]
]) inject: 0 into: [ :sum :i | sum + i ]) displayNl.
