; ============================================================
; File     : DisplayScore.asm
; Purpose  : Displays the current score at position (col=1, row=0)
;            of the console window.
; Interface: DisplayScore PROC  — no arguments, no return value
; Preserves: EAX, EBX, ECX, EDX
; Depends  : Irvine32 (GotoXY, WriteString, WriteDec)
;            globals.inc (score, D_MSG)
; Build    : ml /c /coff DisplayScore.asm
; ============================================================

INCLUDE Irvine32.inc
INCLUDE globals.inc

PUBLIC DisplayScore

.code

; ------------------------------------------------------------
; DisplayScore
;   Moves cursor to (col=1, row=0), prints the "SCORE: " label
;   then prints the numeric value of the global `score` DWORD.
; ------------------------------------------------------------
DisplayScore PROC
    push eax
    push ebx
    push ecx
    push edx

    mov dh, 0               ; Row 0
    mov dl, 1               ; Col 1
    call GotoXY

    mov edx, OFFSET D_MSG   ; "SCORE: "
    call WriteString

    mov eax, score          ; Current score value
    call WriteDec

    pop edx
    pop ecx
    pop ebx
    pop eax
    ret
DisplayScore ENDP

END
