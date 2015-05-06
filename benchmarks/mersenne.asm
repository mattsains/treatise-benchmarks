;An MT19937 twister with state vector of 624 ints
;Based on pseudocode at https://en.wikipedia.org/wiki/Mersenne_Twister

function mersenne
  ptr state
  int index_or_seed
  int random_num

  movc r1, 5489 ;put seed here
  movc r2, 624
  newa r0, r2                 ;r0 points to MT[624]
  setlp .state, r0            ;.state points to MT[624]
  movc r2, 0                  ;r2 is now 0
  setl .index_or_seed, r1     ;.index_or_seed is 5489
  call initialize, .state, 2  ; initialize(MT[624], 5489) -> off we go to line 37ish

  ;generate some numbers
  movc r1, 0                  
  ;using r1 just for the 0 here:
  setl .index_or_seed, r1    
  
  .loop:
  ;recap:
  ;r1 - loop counter
  ;r2 - index
  call extract_number, .state, 2
  setl .index_or_seed, r0
  setl .random_num, r5
  call i_to_s, .random_num, 1
  out r0
  addc r1, 1
  jcmpc r1, 100, .loop, $, $ 
ret

; Intitialize the state array.
; Returns the state array ptr
function initialize
  ptr state
  int seed

  getlp r0, .state  
  getl r1, .seed
  
  movc r2, 0            ;index=0
  seta r0, r2, r1       ;state[0]=seed

  movc r3, 1            ;for i=1 ...
  .loop:
  mov r4, r3            
  addc r4, -1           ;i is r3, i-1 is r4
  geta r4, r0, r4       ;r4=state[i-1]
  mov r5, r4
  shrc r5, 30           ;r5=state[i-1]>>30
  xor r4, r5            ;r4=state[i-1] ^ (state[i-1]>>30)
  add r4, r3            ;r4=state[i-1] ^ (state[i-1]>>30) + i
  mulc r4, 1812433253   ;1812433253 * (state[i-1] ^ (state[i-1]>>30) + i)
  andc r4, 0xFFFFFFFF ; lowest 32 bits of ^
  seta r0, r3, r4 ;state[i] = ^

  addc r3, 1
  jcmpc r3, 624, .loop, $, $ ;for i=1 to 623
ret

function generate_numbers
  ptr state

  getlp r0, .state  
  movc r1, 0 ;for i=0 ...
  .loop:
  geta r2, r0, r1 ;r2=state[i]
  andc r2, 0x80000000; state[i] & 0x80000000
  mov r3, r2 ;r3=i
  addc r3, 1 ;r3=i+1
  movp r5, r0 ;preserve r0 for div
  divc r3, 624
  mov r3, r0 ;r3=r3 mod 624
  movp r0, r5 ;restore r0
  geta r3, r0, r3 ;r3=state[(i+1) mod 624]
  andc r3, 0x7fffffff ;first 31 bits
  add r2, r3 ;r2=(state[i]&(1<<31)) + (state[(i+1) mod 624]&0x7fffffff)
  shrc r2, 1
  movc r3, 397
  add r3, r1 ;r3=i+397
  movp r5, r0 ;preserve r0 for div
  divc r3, 624
  mov r3, r0
  movp r0, r5 ;r3=(i+397) mod 624
  geta r3, r0, r3 ;r3=state[(i+397) mod 624]
  xor r2, r3 ;okay just figure it out, the expression is getting complicated
  mov r3, r2
  andc r3, 1 ;mod 2
  jcmpc r3, 0, .even, .even, $
  ;if the number is odd, do this xor
  movc r3, 2567483615
  xor r2, r3
  .even:
  andc r2, 0xffffffff
  seta r0, r1, r2
  ;now end off the for loop
  addc r1, 1
  jcmpc r1, 623, .loop, .loop, $
  ;returns state ptr:
ret

; Use this function to generate numbers
; Returns new index in r0, random number in r5
function extract_number
  ptr state
  int index

  getlp r0, .state
  getl r1, .index

  jcmpc r1, 0, $, $, .gotnums
  call generate_numbers, .state, 1
  .gotnums:
  geta r2, r0, r1
  
  mov r3, r2
  shrc r3, 29
  andc r3, 0x5555555555555555
  xor r2, r3 ;r2 ^= (r2 >> 29) & 0x5555555555555555ULL
  
  mov r3, r2
  shlc r3, 17
  andc r3, 0x71D67FFFEDA60000
  xor r2, r3 ;r2 ^= (r2 << 17) & 0x71D67FFFEDA60000

  mov r3, r2
  shlc r3, 37
  andc r3, 0xFFF7EEE000000000
  xor r2, r3 ;r2 ^= (r2 << 37) & 0xFFF7EEE000000000

  mov r3, r2
  shrc r3, 43
  xor r2, r3 ;r2 ^=(r2 >> 43)

  addc r1, 1
  movp r5, r0
  divc r1, 624
  ;now r0 is new index
  mov r5, r2
  ;and r5 is actual random number
  andc r5, 0xffffffff
ret

%include ../stdlib.asm