;This is purely the flipping algorithm and does not generate permutations
;
;Algorithm is as follows:
; let max be 0 
; let count be 0
; Go through all permutations of 7 integers from 1 to 7
;  e.g. {2,3,4,1,5,6,7}
;  flip the first 2 {3,2,4,1,5,6,7}, count++
;  flip the first 3 {4,2,3,1,5,6,7}, count++
;  flip the first 4 {1,3,2,4,5,6,7}, count++
;  if (count > max)
;     max = count
; print max

function fannkuch
int max
    movc r3, 0
    setl r3, fannkuch.max ;do i need this to guarantee mostflips starts at 0?
inputloop:
    getl r3, fannkuch.max ;
    jcmp r3, r4, $, notbigger, notbigger    
    setl r4, fannkuch.max
notbigger:
    newa r3
    in r3 ;crud can i read in binary? nyeh this aint gonna work
ret
