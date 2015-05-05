;This is purely the flipping algorithm and does not generate permutations
;
;Algorithm is as follows:
; let max be 0 
; let count be 0
; Go through all permutations of 7 integers from 1 to 7
;  e.g. {2,3,4,1,5,6,7}
;  flip the first 2 -> {3,2,4,1,5,6,7}, count++
;  flip the first 3 -> {4,2,3,1,5,6,7}, count++
;  flip the first 4 -> {1,3,2,4,5,6,7}, count++
;  if (count > max)
;     max = count
; print max

function fannkuch
  int max
  ;r1, r2 - indexes of elements to be swapped
  ;r4 - count
  ;p3 - current input from file
  movc r3, 0
  setl fannkuch.max, r3 ;let max be 0
  jmp notbigger
inputloop:
  getl r3, fannkuch.max 
  jcmp r3, r4, $, notbigger, notbigger ;if count > max
  setl fannkuch.max, r4 ;then new max found
notbigger:
  movc r5, 8
  newa p3, r5
  in p3 ;get new input (EOF behaviour?)
  movc r4, 0 ;reset count to 0 for new input
pancake:
  getb r2, p3, r1
  addc r2, -48 ;ascii -> int
  jcmpc r2, 1, $, inputloop, $; if we read 1 then we are done (don't inc count)
  addc r2, -1; make r2 an index
  movc r1, 0; make r1 point to start
flip:
  jcmp r1, r2, inccount, inccount, $
  getb r0, p3, r2
  getb r5, p3, r1
  setb p3, r1, r5
  setb p3, r2, r0
  addc r1, 1
  addc r2, -1 
  jmp flip 
inccount:
  addc r4, 1
  jmp pancake
ret
  

