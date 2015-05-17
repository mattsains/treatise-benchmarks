  ;Finds prime numbers using the Sieve of Eratosthenes
function primesieve
  int n
  ptr list
  int x
  movc r1, 1000000 ;find primes up to this number
  ; for 1 000 000, should take around three minutes
  setl .n, r1

  movc r5, 2
  newo r0, r3 ;r0: linked list
  mov r4, r0 ;save linked list so we can rewind

  ;Fill linked list with n elements
  movc r2, 2
  .cloop:
  movc r5, 0 ;value
  seto r0, r5, r2
  movc r5, 2 ;2 items
  newo r3, r5
  movc r5, 1 ;next
  seto r0, r5, r3
  mov r0, r3
  addc r2, 1
  jcmp r2, r1, .cloop, .cloop, .cend
  .cend:
  null r2
  movc r5, 1 ;next
  seto r0, r5, r2
  mov r0, r4 ;rewind linked list

  .loop:
  jnullp r0, $, .end
  movc r5, 0 ;value
  geto r1, r0, r5
  movc r5, 1 ;next
  geto r0, r0, r5
  jnullp r0, $, .end
  setl primesieve.list, r0
  setl primesieve.x, r1
  call removeMultiples, primesieve.list, 2
  jmp .loop
  
  .end:
  mov r1, r4 ;rewind list again

  .ploop:
  jnullp r1, $, .pend
  movc r5, 0 ; value
  geto r0, r1, r5
  setl primesieve.x, r0
  call i_to_s, primesieve.x, 1
  out r0
  movc r5, 1; next
  geto r1, r1, r5
  jmp .ploop
  .pend:
ret

  ;object LinkedList (length: 2)
  ; 0 int value
  ; 1 ptr next

function removeMultiples
  ptr list
  int n
  ptr sl
  int sn
  
  getl r1, .list
  getl r2, .n
  mov r3, r2
  .loop:
  jnullp r1, $, .end
  movc r5, 1 ; next
  geto r3, r1, r5
  jnullp r3, $, .end
  movc r5, 0 ; value
  geto r3, r3, r5
  div r3, r2
  jcmpc r0, 0, .remove, .remove, .continue
  .remove:
  movc r5, 1 ; next
  geto r3, r1, r5
  geto r3, r3, r5
  seto r1, r5, r3
  .continue:
  movc r5, 1 ; next
  geto r1, r1, r5
  jmp .loop    
  .end:
  getl r0, .list
ret

%include ../stdlib.asm