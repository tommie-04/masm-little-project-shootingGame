; ============================================================
; File     : MoveCharacter.asm
; ============================================================

INCLUDE Irvine32.inc
INCLUDE globals.inc

PUBLIC MoveCharacter@0

.code

MoveCharacter@0 PROC
    mov dh, curr_Y
    mov dl, curr_X
    call GotoXY
    mov al, 32
    call WriteChar

    mov al, X_dir
    mov ah, Y_dir
    add curr_X, al
    add curr_Y, ah

    cmp curr_Y, 0
    jl  BoundaryHit
    mov cl, MAX_HEIGHT
    cmp curr_Y, cl
    jg  BoundaryHit

    cmp curr_X, 0
    jl  BoundaryHit
    mov cl, MAX_WIDTH
    cmp curr_X, cl
    jg  BoundaryHit

    mov dh, curr_Y
    mov dl, curr_X
    call GotoXY
    mov al, 65
    call WriteChar
    jmp MoveReturn

BoundaryHit:
    mov BoundaryFlag, 1

MoveReturn:
    ret
MoveCharacter@0 ENDP

END
