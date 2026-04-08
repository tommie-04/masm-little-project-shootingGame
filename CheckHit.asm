; ============================================================
; File     : CheckHit.asm
; ============================================================

INCLUDE Irvine32.inc
INCLUDE globals.inc

PUBLIC CheckHit@0

.code

CheckHit@0 PROC
    push ebx
    push ecx
    push edx

    movzx ebx, byte ptr [EDI]
    cmp al, bl
    jne NoHit

    movzx ebx, byte ptr [ESI]
    cmp ah, bl
    jne NoHit

    mov eax, 100
    add score, eax

    mov cl, 127
    mov byte ptr [ESI], cl
    mov byte ptr [EDI], cl

    jmp HitReturn

NoHit:
    cmp al, 0

HitReturn:
    pop edx
    pop ecx
    pop ebx
    ret
CheckHit@0 ENDP

END
