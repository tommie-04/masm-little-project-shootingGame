; ============================================================
; File     : Shoot.asm
; Purpose  : Animates a single bullet fired upward from the
;            player's current position and checks for enemy hits.
;
; Interface: Shoot PROC  — no arguments, no return value
; Preserves: EAX, EBX, ECX, EDX
; Depends  : Irvine32 (GotoXY, WriteChar, Delay)
;            globals.inc (curr_X, curr_Y, shoot_Y,
;                         E1_X/Y, E2_X/Y, E3_X/Y)
;            CheckHit.asm
;            DisplayScore.asm
; Build    : ml /c /coff Shoot.asm
; ============================================================

INCLUDE Irvine32.inc
INCLUDE globals.inc

; External procedures from other modules
EXTERN CheckHit:PROC
EXTERN DisplayScore:PROC

PUBLIC Shoot

.code

; ------------------------------------------------------------
; Shoot
;   Fires a bullet from one row above the player (curr_Y - 1)
;   straight upward. Each frame:
;     1. Erases the bullet's previous position
;     2. Draws the bullet at the new position ('.')
;     3. Calls CheckHit for each living enemy (X != 127)
;     4. Delays 10 ms, then moves bullet up one row
;   Loop ends when bullet reaches row 0 or a hit is detected.
;   Calls DisplayScore to refresh the score after each shot.
; ------------------------------------------------------------
Shoot PROC
    push eax
    push ebx
    push ecx
    push edx

    ; Place bullet just above the player
    mov al, curr_Y
    sub al, 1
    mov shoot_Y, al
    mov dl, curr_X

ShootMoveLoop:
    ; --- Top boundary check: stop if bullet reached row 0 ---
    movzx eax, shoot_Y
    cmp al, 0
    jle FinalErase

    ; --- Erase bullet at previous row (shoot_Y + 1) ---
    mov dh, shoot_Y
    add dh, 1
    call GotoXY
    mov al, 32              ; ASCII space
    call WriteChar

    ; --- Draw bullet dot at current row ---
    mov dh, shoot_Y
    call GotoXY
    mov al, '.'
    call WriteChar

    ; --- Load bullet coords for hit checks ---
    mov al, shoot_Y         ; AL = bullet Y
    mov ah, curr_X          ; AH = bullet X

    ; Check Enemy 1
    push esi
    push edi
    mov esi, OFFSET E1_X
    mov edi, OFFSET E1_Y
    call CheckHit
    jz HitFound
    pop edi
    pop esi

    ; Check Enemy 2
    push esi
    push edi
    mov esi, OFFSET E2_X
    mov edi, OFFSET E2_Y
    call CheckHit
    jz HitFound
    pop edi
    pop esi

    ; Check Enemy 3
    push esi
    push edi
    mov esi, OFFSET E3_X
    mov edi, OFFSET E3_Y
    call CheckHit
    jz HitFound
    pop edi
    pop esi

    ; --- Advance bullet upward and delay ---
    dec shoot_Y
    mov eax, 10             ; 10 ms delay
    call Delay

    jmp ShootMoveLoop

HitFound:
    ; Clean up ESI/EDI that were pushed before the winning CheckHit call
    pop edi
    pop esi

FinalErase:
    ; Erase the bullet's last drawn position
    mov dh, shoot_Y
    mov dl, curr_X
    call GotoXY
    mov al, 32              ; ASCII space
    call WriteChar

    call DisplayScore

    pop edx
    pop ecx
    pop ebx
    pop eax
    ret
Shoot ENDP

END
