proc readLines {filename} {
  set file [open $filename]
  set content [read $file]
  close $file
  return [split $content "\n"]
}

proc parsePatterns {lines} {
  set patterns [list]
  set patterm [list]
  foreach line $lines {
    if {$line == ""} {
      lappend patterns $pattern
      set pattern [list]
    } else {
      lappend pattern $line
    }
  }
  return $patterns
}

proc horizontalReflection {pattern {ignore -1}} {
  set height [llength $pattern]
  for {set row 1} {$row < $height} {incr row} {
    if { $row == $ignore } { continue }
    if {[lindex $pattern $row] == [lindex $pattern [expr {$row - 1}]]} {
      set offset 1
      while {0 < 1} {
        set upper [expr { $row + $offset }]
        set lower [expr { $row - $offset - 1}]
        if { $upper == $height } { return $row }
        if { $lower < 0 } { return $row }
        if {[lindex $pattern $upper] != [lindex $pattern $lower]} { break }
        incr offset
      }
    }
  }
  return 0
}

proc Col {pattern  c} {
  set result ""
  foreach line $pattern {
    set result $result[string index $line $c] 
  }
  return $result
}

proc verticalReflection {pattern {ignore -1}} {
  set width [string length [lindex $pattern 0]]
  for {set col 1} {$col < $width} {incr col} {
    if { $col == $ignore } { continue }
    if {[Col $pattern $col] == [Col $pattern [expr {$col - 1}]]} {
      set offset 1
      while {0 < 1} {
        set right [expr { $col + $offset }]
        set left [expr { $col - $offset - 1 }]
        if { $right == $width } { return $col }
        if { $left < 0 } { return $col }
        if {[Col $pattern $left] != [Col $pattern $right]} { break }
        incr offset
      }
    }
  }
  return 0
}

proc summarizePattern {pattern} {
  set result [verticalReflection $pattern]
  if {$result > 0} { return $result }
  set result [expr {100*[horizontalReflection $pattern]}]
  return $result
}

proc mangle {pattern} {
  set oldResult [summarizePattern $pattern]
  set width [string length [lindex $pattern 0]]
  set height [llength $pattern]
  for {set row 0} {$row < $height} {incr row} {
    for {set col 0} {$col < $width} {incr col} {
      set rowStr [lindex $pattern $row]
      set oldChar [string index $rowStr $col]
      if {$oldChar == "#"} { set c "." } else { set c "#" }
      set newPattern [lreplace $pattern $row $row [string replace $rowStr $col $col $c]]
      set newVert [verticalReflection $newPattern $oldResult]
      if {$newVert > 0 && $newVert != $oldResult} { return $newVert }
      set newHoriz [expr {100*[horizontalReflection $newPattern [expr {$oldResult / 100}]]}]
      if {$newHoriz > 0 && $newHoriz != $oldResult} { return $newHoriz }
    }
  }
  return 0
}

set inputFile [lindex $argv 0]
set part [lindex $argv 1]

set sum 0
foreach pattern [parsePatterns [readLines $inputFile]] {
  if {$part == 1} {
    incr sum [summarizePattern $pattern]
  } else {
    incr sum [mangle $pattern]
  }
}
puts $sum
