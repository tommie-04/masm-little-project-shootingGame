; ============================================================
; File     : MoveEnemy.asm
; ============================================================
INCLUDE Irvine32.inc
INCLUDE globals.inc

PUBLIC _MoveEnemy

.code

_MoveEnemy PROC
    push ebx
    push ecx
    push eax
    push esi
    push edi

    mov dh, byte ptr [EDI]
    mov dl, byte ptr [ESI]
    call GotoXY
    mov al, 32
    call WriteChar

TryDirection:
    call Randomize
    mov eax, 4
    call RandomRange

    cmp eax, 0
    je  upDir
    cmp eax, 1
    je  downDir
    cmp eax, 2
    je  leftDir
    cmp eax, 3
    je  rightDir
    jmp TryDirection

rightDir:
    mov dl,  1
    mov dh,  0
    jmp calculateMove

upDir:
    mov dl,  0
    mov dh, -1
    jmp calculateMove

downDir:
    mov dl,  0
    mov dh,  1
    jmp calculateMove

leftDir:
    mov dl, -1
    mov dh,  0

calculateMove:
    mov byte ptr [EBX], dl
    mov byte ptr [ECX], dh

    mov al, byte ptr [ESI]
    mov ah, byte ptr [EDI]

    add al, dl
    add ah, dh

    cmp ah, 0
    jl  InvalidMove
    mov cl, MAX_HEIGHT
    cmp ah, cl
    jg  InvalidMove

    cmp al, 0
    jl  InvalidMove
    mov cl, MAX_WIDTH
    cmp al, cl
    jg  InvalidMove

    mov byte ptr [ESI], al
    mov byte ptr [EDI], ah

    mov dh, byte ptr [EDI]
    mov dl, byte ptr [ESI]
    call GotoXY
    mov al, 69
    call WriteChar
    jmp EnemyDone

InvalidMove:
    jmp TryDirection

EnemyDone:
    pop edi
    pop esi
    pop eax
    pop ecx
    pop ebx
    ret
_MoveEnemy ENDP

END
