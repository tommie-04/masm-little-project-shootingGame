; ============================================================
; File     : CheckHit.asm
; Purpose  : Checks whether the bullet hits a given enemy.
;            On a confirmed hit, the enemy is marked dead and
;            100 points are added to the score.
;
; Interface:
;   IN  AL  = Bullet Y coordinate
;   IN  AH  = Bullet X coordinate
;   IN  ESI = Address of enemy X coordinate (SBYTE)
;   IN  EDI = Address of enemy Y coordinate (SBYTE)
;   OUT ZF  = 1 if hit detected, 0 if no hit
;
; Preserves: EBX, ECX, EDX
; Depends  : globals.inc (score)
; Build    : ml /c /coff CheckHit.asm
; ============================================================

INCLUDE Irvine32.inc
INCLUDE globals.inc

PUBLIC CheckHit

.code

; ------------------------------------------------------------
; CheckHit
;   Compares bullet coords (AL=Y, AH=X) against the enemy
;   coords at [EDI] and [ESI]. If both match:
;     - Adds 100 to score
;     - Writes sentinel value 127 to enemy X and Y (marks dead)
;     - Returns ZF = 1
;   Otherwise returns ZF = 0.
; ------------------------------------------------------------
CheckHit PROC
    push ebx
    push ecx
    push edx

    ; 1. Does Bullet_Y == Enemy_Y?
    movzx ebx, byte ptr [EDI]
    cmp al, bl
    jne NoHit

    ; 2. Does Bullet_X == Enemy_X?
    movzx ebx, byte ptr [ESI]
    cmp ah, bl
    jne NoHit

    ; --- HIT DETECTED ---
    mov eax, 100
    add score, eax

    ; Mark enemy as dead using off-screen sentinel value 127
    mov cl, 127
    mov byte ptr [ESI], cl     ; Enemy X = 127
    mov byte ptr [EDI], cl     ; Enemy Y = 127

    ; Force ZF = 1 to signal hit to caller
    jmp HitReturn

NoHit:
    cmp al, 0                  ; ZF = 0  (no hit)

HitReturn:
    pop edx
    pop ecx
    pop ebx
    ret
CheckHit ENDP

END
