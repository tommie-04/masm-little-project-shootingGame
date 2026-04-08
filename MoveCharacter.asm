; ============================================================
; File     : MoveCharacter.asm
; Purpose  : Erases the player sprite at the old position,
;            applies the current direction vector, enforces
;            screen boundaries, then redraws the player ('A').
;
; Interface: MoveCharacter PROC  — no arguments, no return value
;   Sets BoundaryFlag = 1 if the new position is out of bounds
;   (caller should treat this as a game-over condition).
;
; Preserves: all registers (uses only AL, AH, CL, DH, DL)
; Depends  : Irvine32 (GotoXY, WriteChar)
;            globals.inc (curr_X, curr_Y, X_dir, Y_dir,
;                         MAX_WIDTH, MAX_HEIGHT, BoundaryFlag)
; Build    : ml /c /coff MoveCharacter.asm
; ============================================================

INCLUDE Irvine32.inc
INCLUDE globals.inc

PUBLIC MoveCharacter

.code

; ------------------------------------------------------------
; MoveCharacter
;   1. Erase player at (curr_X, curr_Y) with a space
;   2. Add X_dir / Y_dir to curr_X / curr_Y
;   3. Clamp-check against 0..MAX_WIDTH and 0..MAX_HEIGHT
;      — if out of range, set BoundaryFlag = 1 and return
;   4. Draw 'A' at the new position
; ------------------------------------------------------------
MoveCharacter PROC
    ; --- Erase old position ---
    mov dh, curr_Y
    mov dl, curr_X
    call GotoXY
    mov al, 32              ; ASCII space
    call WriteChar

    ; --- Apply direction vector ---
    mov al, X_dir
    mov ah, Y_dir
    add curr_X, al
    add curr_Y, ah

    ; --- Boundary checks ---
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

    ; --- Draw player at new position ---
    mov dh, curr_Y
    mov dl, curr_X
    call GotoXY
    mov al, 65              ; 'A' — player sprite
    call WriteChar
    jmp MoveReturn

BoundaryHit:
    mov BoundaryFlag, 1     ; Signal game-over to main loop

MoveReturn:
    ret
MoveCharacter ENDP

END
