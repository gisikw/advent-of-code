set inputFile [lindex $argv 0]
set part [lindex $argv 1]

set file [open $inputFile]
set content [read $file]
close $file

set lines [split $content "\n"]

set patterns [list]
foreach line $lines {
  if { $line == "" } {
    set patterns [lappend patterns $pattern]
    set pattern [list]
    continue
  }
  set pattern [lappend pattern $line]
}

proc HorizontalReflection {pattern {ignore -1}} {
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

proc VerticalReflection {pattern {ignore -1}} {
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


proc SummarizePattern {pattern} {
  set result [VerticalReflection $pattern]
  if {$result > 0} { return $result }
  set result [expr {100*[HorizontalReflection $pattern]}]
  return $result
}

proc Mangle {pattern} {
  set oldResult [SummarizePattern $pattern]
  set width [string length [lindex $pattern 0]]
  set height [llength $pattern]
  for {set row 0} {$row < $height} {incr row} {
    for {set col 0} {$col < $width} {incr col} {
      set rowStr [lindex $pattern $row]
      set oldChar [string index $rowStr $col]
      if {$oldChar == "#"} { set c "." } else { set c "#" }
      set newPattern [lreplace $pattern $row $row [string replace $rowStr $col $col $c]]
      set newVert [VerticalReflection $newPattern $oldResult]
      if {$newVert > 0 && $newVert != $oldResult} { return $newVert }
      set newHoriz [expr {100*[HorizontalReflection $newPattern [expr {$oldResult / 100}]]}]
      if {$newHoriz > 0 && $newHoriz != $oldResult} { return $newHoriz }
    }
  }
  return 0
}

set sum 0
foreach pattern $patterns {
  if {$part == 1} {
    incr sum [SummarizePattern $pattern]
  } else {
    incr sum [Mangle $pattern]
  }
}
puts $sum
