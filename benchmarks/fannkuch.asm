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
  ptr buffer
  int length
  ;r1, r2 - indexes of elements to be swapped
  ;r4 - count
  ;p0 - buffer
  ;set up buffer:
  movc r5, 7
  newb p0, r5
  
  movc r5, '1'
  movc r4, 0
  setb p0, r4, r5
  movc r5, '2'
  movc r4, 1
  setb p0, r4, r5
  movc r5, '3'
  movc r4, 2
  setb p0, r4, r5
  movc r5, '4'
  movc r4, 3
  setb p0, r4, r5
  movc r5, '5'
  movc r4, 4
  setb p0, r4, r5
  movc r5, '6'
  movc r4, 5
  setb p0, r4, r5
  movc r5, '7'
  movc r4, 6
  setb p0, r4, r5
  
  movc r3, 0
  setl fannkuch.max, r3 ;let max be 0

  movc r3, 7
  setl fannkuch.length, r3
  movc r4, 0

  ;save buffer
  setl fannkuch.buffer, r0
  ;copy it and mess with the copy only
  call bufferclone, fannkuch.buffer, 2
  
  jmp pancake
inputloop:
  getl r3, fannkuch.max 
  jcmp r3, r4, $, notbigger, notbigger ;if count > max
  setl fannkuch.max, r4 ;then new max found
notbigger:
  call permute, fannkuch.buffer, 2
  ;out p0 
  setl fannkuch.buffer, r0
  call bufferclone, fannkuch.buffer, 2
  movc r4, 0 ;reset count to 0 for new input
  getb r3, p0, r4
  jcmpc r3, 3, $, done, $ ;lt should never happen

pancake:
  movc r3, 0
  getb r2, p0, r3
  addc r2, -49 ;ascii -> int - 1(convert to int-1 for an index)
  jcmpc r2, 0, $, inputloop, $; if we read 1 then we are done (don't inc count)
  movc r1, 0
flip:
  jcmp r1, r2, $, inccount, inccount
  getb r3, p0, r2
  getb r5, p0, r1
  setb p0, r2, r5
  setb p0, r1, r3
  addc r1, 1
  addc r2, -1 
  jmp flip 
inccount:
  addc r4, 1
  jmp pancake

done:
  call i_to_s, fannkuch.max, 1
  out p0
ret

  ; generate permutations based on lexicographic order
  ; takes a buffer as input and returns the next permutation,
  ; if done returns a buffer with first character: ASCII EOT (0x3)
function permute
  ptr buffer
  int length
  int start

  getl r0, permute.buffer
  getl r3, permute.length ;k + 2
  mov r2, r3
  mov r1, r2
  addc r3, -1 
  addc r1, -1
  ;r3 = last index
  ;r1 = last index
  ;r2 = last index + 1

  .largekloop:
  addc r1, -1 ; k
  addc r2, -1 ; k + 1
  setl permute.start, r2 ;can i make this only happen once?
  jcmpc r1, 0, .doneperms, $, $ ;check if we are done
  getb r4, p0, r1 ;buffer[k]
  getb r5, p0, r2 ;buffer[k + 1]
  jcmp r4, r5, .largelloop, .largekloop, .largekloop
  ;permute.start = k + 1
  ;r4 = buffer[k]
  ;r3 = last index
  ;r2 = k + 1
  
  .largelloop:
  mov r1, r2 ;store current l
  .largelloop2:
  jcmp r2, r3, $, .swaprotate, $ ;gt should never happen
  addc r2, 1
  getb r5, p0, r2
  jcmp r5, r4, .largelloop2, .largelloop2, .largelloop
  ;r1 = l

  .doneperms:
  movc r2, 3
  movc r1, 0
  setb p0, r1, r2 ;buffer[0] = 0x3 (EOT)
  jmp .end

  .swaprotate:
  getl r2, permute.start
  addc r2, -1 ;k
  ;swap buffer[k] and buffer[l]
  getb r4, p0, r2 ;r4 = buffer[k]
  getb r5, p0, r1 ;r5 = buffer[l]
  setb p0, r2, r5 ;buffer[k] = r5
  setb p0, r1, r4 ;buffer[l] = r4
  setl permute.buffer, r0
  setl permute.length, r3
  call rotate, permute.buffer, 3
  .end:
ret

function rotate
  ptr buffer
  int lastindex
  int start
  getl r0, rotate.buffer
  getl r2, rotate.lastindex ;end
  mov r3, r2
  addc r3, 1 ;end + 1
  getl r1, rotate.start ;start
  sub r3, r1
  mov r5, r0 ;get out of way of remainder :'(
  divc r3, 2 ;length/2
  mov r0, r5
  .rotloop:
  addc r3, -1
  getb r4, p0, r2
  getb r5, p0, r1
  ;swap
  setb p0, r1, r4
  setb p0, r2, r5
  addc r2, -1
  addc r1, 1
  jcmpc r3, 0, $, $, .rotloop
ret

%include ../stdlib.asm
  


