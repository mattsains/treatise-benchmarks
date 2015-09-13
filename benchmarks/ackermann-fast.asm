function ackermann
  ;hardcoded inputs
  movc r0, 4 ;m
  movc r5, 1 ;n
  call A, 0, 0
  ;r0 now has the result of the ackermann function
  ;should be 65533 for (4,1)
  ; takes about 3 minutes
  print r5
ret
 
function A ;r0 is m, r5 is n
  jcmpc r0, 0, c1, c1, c23
c1:
  addc r5, 1
ret
c23:
  jcmpc r5, 0, c2, c2, c3
c2:
  addc r0, -1
  movc r5, 1
  call A, 0, 0
ret
c3:
  addc r5, -1
  mov r3, r0 ; save r0 (m)
  call A, 0, 0
  ;r5 now result
  addc r3, -1
  ;restore r0
  mov r0, r3
  call A, 0, 0
ret