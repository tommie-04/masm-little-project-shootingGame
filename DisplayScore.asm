; ============================================================
; File     : DisplayScore.asm
; ============================================================

INCLUDE Irvine32.inc
INCLUDE globals.inc

PUBLIC DisplayScore@0

.code

DisplayScore@0 PROC
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
DisplayScore@0 ENDP

END
