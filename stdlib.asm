;Calculates x^y, y>=0
function pow
  int x
  int y

getl r1, pow.x ;r1: x
movc r0, 1 ;r0: 1
getl r2, pow.y ;r2: y
.loop:
    jcmpc r2, 0, .eloop, .eloop, $
    mul r0, r1
    addc r2, -1
    jmp .loop
.eloop:
ret
;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Takes in an integer, returns a string in a byte buffer
function i_to_s
  int i
  int ten
  int pow

movc r1, 21 ;max digits in int64_t + 2 (negatives+\0)
newa r0, r1 ;r0: output

getl r1, i_to_s.i ;r1: i
movc r2, 0 ;r2: index into output

jcmpc r1, 0, $, .positive, .positive
movc r3, 45 ;ASCII minus
setb r0, r2, r3
movc r3, -1 ;all ones
xor r1, r3 ;inverts r1
addc r1, 1
addc r2, 1
.positive:
movc r3, 18 ;first possible digit of int64
movc r4, 10
setl i_to_s.ten, r4
setl i_to_s.pow, r3
mov r4, r0
call pow, i_to_s.ten, 2
mov r3, r0
mov r5, r4
mov r0, r1
;to recap:
;r0: i
;r1: undefined
;r2: index into output
;r3: 10^18
;r4: undefined
;r5: output
mov r4, r0
.preloop:
    div r4, r3 ;r4: value of nth digit
    jcmpc r4, 0, $, $, .endpre
    .prenext:
    mov r4, r0
    divc r3, 10
    jcmpc r3, 0, .prefail, .prefail, .preloop

.prefail:
    ;this means the number is zero
    movc r4, 48
    setb r5, r2, r4
    addc r2, 1
    jmp .end

.endpre:
    ;we've cleared zeros
    addc r4, 48
    setb r5, r2, r4
    addc r2, 1
    mov r4, r0
    divc r3, 10
    jcmpc r3, 0, .end, .end, .loop
      
.loop:
    div r4, r3 ;r4: value of nth digit
    addc r4, 48 ;ASCII 0
    setb r5, r2, r4
    addc r2, 1
    mov r4, r0
    divc r3, 10
    jcmpc r3, 0, .end, .end, .loop
.end:
movc r4, 0
setb r5, r2, r4 ;\0
mov r0, r5
ret


function strconcat
  ptr a
  ptr b

getl r1, strconcat.a ;r1: a
movc r0, 0 ;r0: length
.cloop1:
    getb r2, r1, r0
    jcmpc r2, 0, .cloop1e, .cloop1e, $
    addc r0, 1
    jmp .cloop1
.cloop1e:
mov r5, r0 ;store length of a for later
getl r1, strconcat.b ;r1: b
movc r2, 0 ;r2: index
.cloop2:
    getb r4, r1, r2
    jcmpc r4, 0, .cloop2e, .cloop2e, $
    addc r0, 1
    addc r2, 1
    jmp .cloop2
.cloop2e:
addc r0, 1 ;add \0
newa r4, r0
;recap:
;r0: length of new array
;r1: b
;r2: length of b
;r3: nothing
;r4: output
;r5: length of a
;rearrange for ease of use
mov r0, r4           ;r0: output
mov r1, r5           ;r1: len(a)
                     ;r2: len(b)
getl r3, strconcat.a ;r3: a
movc r4, 0           ;r4: index into a
.mloop1:
    jcmpc r1, 0, .mloop1e, .mloop1e, $
    getb r5, r3, r4
    setb r0, r4, r5
    addc r1, -1
    addc r4, 1
    jmp .mloop1
.mloop1e:
getl r3, strconcat.b
mov r1, r4
movc r4, 0
.mloop2:
    jcmpc r2, 0, .mloop2e, .mloop2e, $
    getb r5, r3, r4
    setb r0, r1, r5
    addc r4, 1
    addc r1, 1
    addc r2, -1
    jmp .mloop2
.mloop2e:
movc r5, 0
setb r0, r1, r5
ret
