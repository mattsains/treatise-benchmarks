;;;;;;;;;;;;;;;;;;;;;;;;
; Calculates x^y, y>=0
function pow
  int x
  int y

getl r1, pow.x ;r1: x
movc r0, 1 ;r0: 1
getl r2, pow.y ;r2: y
pow_loop:
    jcmpc r2, 0, eloop, eloop, loopnext
    loopnext:
    mul r0, r1
    addc r2, -1
    jmp pow_loop
eloop:
ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Takes in an integer,
; returns a \0-terminated string in a byte buffer
function i_to_s
  int i
  int ten
  int pow

movc r1, 3 ;max digits in int64_t + 2 (negatives+\0) /8
newa r0, r1 ;r0: output

getl r1, i_to_s.i ;r1: i
movc r2, 0 ;r2: index into output

jcmpc r1, 0, i_to_s_next, i_to_s_positive, i_to_s_positive
i_to_s_next:
movc r3, 45 ;ASCII minus
setb r0, r2, r3
xor r1, r2 ;just using r2=0 to invert r1
addc r1, 1
addc r2, 1
i_to_s_positive:
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
;r3: 10^19
;r4: undefined
;r5: output
mov r4, r0
prestrloop:
    div r4, r3 ;r4: value of nth digit
    jcmpc r4, 0, prenext, prenext, endpre
    prenext:
    mov r4, r0
    divc r3, 10
    jcmpc r3, 0, prefail, prefail, prestrloop

prefail:
    ;this means the number is zero
    movc r4, 48
    setb r5, r2, r4
    jmp i_to_s_end

endpre:
    ;we've cleared zeros
    addc r4, 48
    setb r5, r2, r4
    addc r2, 1
    mov r4, r0
    divc r3, 10
    jcmpc r3, 0, i_to_s_end, i_to_s_end, strloop
      
strloop:
    div r4, r3 ;r4: value of nth digit
    addc r4, 48 ;ASCII 0
    setb r5, r2, r4
    addc r2, 1
    mov r4, r0
    divc r3, 10
    jcmpc r3, 0, i_to_s_end, i_to_s_end, strloop
i_to_s_end:
movc r4, 0
setb r5, r2, r4 ;\0
mov r0, r5
ret

;;;;;;;;;;;;;;;;;;;;;;;
; Takes as input two string buffers
; returns a string buffer that is the
; concatenation of the two
function strconcat
  ptr a
  ptr b

getl r1, strconcat.a ;r1: a
movc r0, 0 ;r0: length
strconcat_cloop1:
    getb r2, r1, r0
    jcmp r2, 0, strconcat_cloop1e, strconcat_cloop1e, strconcat_cloop1c
    strconcat_cloop1c:
    addc r0, 1
    jmp strconcat_cloop1
strconcat_cloop1e:
mov r5, r0 ;store length of 0 for later
getl r1, strconcat.b ;r1: b
movc r2, 0 ;r2: index
strconcat_cloop2:
    getb r4, r1, r2
    jcmp r4, 0, strconcat_cloop2e, strconcat_cloop2e, strconcat_cloop2c
    strconcat_cloop2c:
    addc r0, 1
    addc r2, 1
    jmp strconcat_cloop2
strconcat_cloop2e:
addc r0, 1 ;add \0
mov r3, r0
addc r3, 7
shrc r3, 3 ;r=(r0+7)/64
newa r4, r3
;recap:
;r0: length of new array
;r1: b
;r2: length of b
;r3: size of output
;r4: output
;r5: length of a
;rearrange for ease of use
mov r0, r4           ;r0: output
mov r1, r5           ;r1: len(a)
                     ;r2: len(b)
getl r3, strconcat.a ;r3: a
movc r4, 0           ;r4: index into a
strconcat_mloop1:
    jcmpc r1, 0, strconcat_mloop1e, strconcat_mloop1e, strconcat_mloop1c
    strconcat_mloop1c:
    getb r5, r3, r4
    setb r0, r4, r5
    addc r1, -1
    addc r4, 1
    jmp strconcat_mloop1
strconcat_mloop1e:
getl r3, strconcat.b
mov r1, r4
movc r4, 0
strconcat_mloop2:
    jcmpc r2, 0, strconcat_mloop2e, strconcat_mloop2e, strconcat_mloop2c
    strconcat_mloop2c:
    getb r5, r3, r4
    setb r0, r1, r5
    addc r4, 1
    addc r1, 1
    addc r2, -1
    jmp strconcat_mloop2
strconcat_mloop2e:
movc r5, 0
setb r0, r1, r5
ret