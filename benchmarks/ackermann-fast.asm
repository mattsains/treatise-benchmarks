function ackermann
  ;hardcoded inputs
  movc r1, 4 ;m
  movc r0, 1 ;n
  call A, 0, 0
  ;r0 now has the result of the ackermann function
  ;should be 65533 for (4,1)
  ; takes about 3 minutes
  print r0
ret
 
function A ;r1 is m, r0 is n
  jcmpc r1, 0, c1, c1, c23
c1:
  addc r0, 1
ret
c23:
  jcmpc r0, 0, c2, c2, c3
c2:
  addc r1, -1
  movc r0, 1
  call A, 0, 0
ret
c3:
  addc r0, -1
  call A, 0, 0
  ;r0 now result
  addc r1, -1
  ;restore r1
  call A, 0, 0
ret