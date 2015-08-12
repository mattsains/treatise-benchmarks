#!/bin/awk -f

/^\s*;/ {next} #comments
/^\s*$/ {next} #blanks
/:/{next} #labels
/function|int|ptr|object/{next} #silly stuff
!seen[$1]++ {print $1} #however that works
