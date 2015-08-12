#!/bin/awk -f

/^\s*;/ {next} #comments
/^\s*$/ {next} #blanks
/:/{next} #labels
/function|int|ptr|object|include/{next} #silly stuff
!seen[$1]++ {print $1} #prints unique instructions... however that works
