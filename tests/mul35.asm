; Calculates the sum of all multiples of 3 or 5 under 1000
; This program should end with r5 = 0x38ed0 = 233168
function main

movc r1, 1
movc r5, 0

loop:
    mov r2, r1
    divc r1, 3
    mov r1, r2
    jcmpc r0, 0, acc, acc, cont
    cont:
    divc r1, 5
    mov r1, r2
    jcmpc r0, 0, acc, acc, reject
    acc:
    add r5, r1
    reject:
    addc r1, 1

    jcmpc r1, 1000, loop, end, end

end:
    ;Don't know how to print a value to the screen
    mov r0, r5 ;so I just put it in r0
    ret