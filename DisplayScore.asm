; ============================================================
; File     : DisplayScore.asm
; ============================================================
INCLUDE Irvine32.inc
INCLUDE globals.inc

PUBLIC _DisplayScore

.code

_DisplayScore PROC
    push eax
    push ebx
    push ecx
    push edx

    mov dh, 0
    mov dl, 1
    call GotoXY

    mov edx, OFFSET D_MSG
    call WriteString

    mov eax, score
    call WriteDec

    pop edx
    pop ecx
    pop ebx
    pop eax
    ret
_DisplayScore ENDP

END
