; ============================================================
; File     : Shoot.asm
; ============================================================

INCLUDE Irvine32.inc
INCLUDE globals.inc

EXTERN CheckHit@0:PROC
EXTERN DisplayScore@0:PROC

PUBLIC Shoot@0

.code

Shoot@0 PROC
    push eax
    push ebx
    push ecx
    push edx

    mov al, curr_Y
    sub al, 1
    mov shoot_Y, al
    mov dl, curr_X

ShootMoveLoop:
    movzx eax, shoot_Y
    cmp al, 0
    jle FinalErase

    mov dh, shoot_Y
    add dh, 1
    call GotoXY
    mov al, 32
    call WriteChar

    mov dh, shoot_Y
    call GotoXY
    mov al, '.'
    call WriteChar

    mov al, shoot_Y
    mov ah, curr_X

    push esi
    push edi
    mov esi, OFFSET E1_X
    mov edi, OFFSET E1_Y
    call CheckHit@0
    jz HitFound
    pop edi
    pop esi

    push esi
    push edi
    mov esi, OFFSET E2_X
    mov edi, OFFSET E2_Y
    call CheckHit@0
    jz HitFound
    pop edi
    pop esi

    push esi
    push edi
    mov esi, OFFSET E3_X
    mov edi, OFFSET E3_Y
    call CheckHit@0
    jz HitFound
    pop edi
    pop esi

    dec shoot_Y
    mov eax, 10
    call Delay

    jmp ShootMoveLoop

HitFound:
    pop edi
    pop esi

FinalErase:
    mov dh, shoot_Y
    mov dl, curr_X
    call GotoXY
    mov al, 32
    call WriteChar

    call DisplayScore@0

    pop edx
    pop ecx
    pop ebx
    pop eax
    ret
Shoot@0 ENDP

END
