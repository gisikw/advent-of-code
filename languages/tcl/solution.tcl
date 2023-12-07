set inputFile [lindex $argv 0]
set part [lindex $argv 1]

set file [open $inputFile]
set content [read $file]
close $file

set lines [split $content "\n"]
set linesCount [expr {[llength $lines] - 1}]

puts "Received $linesCount lines of input for part $part"
