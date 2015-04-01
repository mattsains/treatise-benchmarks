; So these are just a few examples of how my assembler does syntax

; literals can be defined:
dw 1 ; Inserts a 16-bit literal 1
dq 0x1515 ; Inserts a 64-bit literal 0x1515
align 8 ; Only 8 is supported at present. The next entity will start at a 64-bit aligned address

; Constant operands are automatically relocated to an 8-byte aligned
; constant area at the end of the program
addc r0, 1

; This translates into:
;   addc r0 _imm_1
;   ...
;   align 8
;   _imm_1:
;   dq 1

; Labels are supported
loop:
    addc r0, 1
    jmp loop

; Object prototypes can be defined:
object LinkedList
    ptr Next
    ptr Previous
    int Count
    ptr Data

; This translates into:
;   LinkedList:
;   dq 4 <= size of object
;   dq 0b1011 <= bitmap
; It also creates "labels" LinkedList.Next, LinkedList.Previous, etc,
;  corresponding to 0, 1, etc., so that you can index easily into the object.
; Here's an example of using an object

newp r1, LinkedList ;using label defined at start of object prototype
setm LinkedList.Count, r1, r0 ;not sure of the order of operands yet

; You can also define functions
; Functions start with a sort of object definition for the parameters.
; This is so similar to object definitions, they are synonyms:
function Print
    ptr string
    int length
; however, functions also have an additional entry for the number of locals they will have:
    locals 4
; Which is similar enough to dw to be a synonym too. (I was lazy)

    ; (code)

; (some sort of ret)


;TODO
; Make ri/pi different registers and do type checking on it.
;  This is not a concern for the dynamically typed VMs