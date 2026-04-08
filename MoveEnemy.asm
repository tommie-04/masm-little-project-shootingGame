; ============================================================
; File     : MoveEnemy.asm
; Purpose  : Moves a single enemy one step in a randomly chosen
;            direction while respecting screen boundaries.
;            Retries with a new random direction on boundary hit.
;
; Interface:
;   IN  ESI = Address of enemy X coordinate (SBYTE)
;   IN  EDI = Address of enemy Y coordinate (SBYTE)
;   IN  EBX = Address of enemy X_dir        (SBYTE)
;   IN  ECX = Address of enemy Y_dir        (SBYTE)
;   (All four pointer arguments must be set by the caller.)
;
; Preserves: EAX, EBX, ECX, ESI, EDI
; Depends  : Irvine32 (GotoXY, WriteChar, Randomize, RandomRange)
;            globals.inc (MAX_WIDTH, MAX_HEIGHT)
; Build    : ml /c /coff MoveEnemy.asm
; ============================================================

INCLUDE Irvine32.inc
INCLUDE globals.inc

PUBLIC MoveEnemy

.code

; ------------------------------------------------------------
; MoveEnemy
;   1. Erase enemy at its current position
;   2. Pick a random direction: 0=up, 1=down, 2=left, 3=right
;   3. Compute proposed new coords
;   4. If out of bounds → retry step 2
;   5. Save new coords and draw 'E' at the new position
; ------------------------------------------------------------
MoveEnemy PROC
    push ebx
    push ecx
    push eax
    push esi
    push edi

    ; --- Erase current enemy position ---
    mov dh, byte ptr [EDI]  ; current Y
    mov dl, byte ptr [ESI]  ; current X
    call GotoXY
    mov al, 32              ; ASCII space
    call WriteChar

TryDirection:
    call Randomize
    mov eax, 4
    call RandomRange        ; EAX = 0..3

    cmp eax, 0
    je  upDir
    cmp eax, 1
    je  downDir
    cmp eax, 2
    je  leftDir
    cmp eax, 3
    je  rightDir
    jmp TryDirection        ; Safety net (should not reach here)

rightDir:
    mov dl,  1              ; X_dir = +1
    mov dh,  0              ; Y_dir =  0
    jmp calculateMove

upDir:
    mov dl,  0              ; X_dir =  0
    mov dh, -1              ; Y_dir = -1
    jmp calculateMove

downDir:
    mov dl,  0              ; X_dir =  0
    mov dh,  1              ; Y_dir = +1
    jmp calculateMove

leftDir:
    mov dl, -1              ; X_dir = -1
    mov dh,  0              ; Y_dir =  0

calculateMove:
    ; --- Persist chosen direction ---
    mov byte ptr [EBX], dl  ; store X_dir
    mov byte ptr [ECX], dh  ; store Y_dir

    ; --- Compute proposed new coords ---
    mov al, byte ptr [ESI]  ; AL = current X
    mov ah, byte ptr [EDI]  ; AH = current Y

    add al, dl              ; new X = X + X_dir
    add ah, dh              ; new Y = Y + Y_dir

    ; --- Boundary check ---
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

    ; --- Valid move: commit and draw ---
    mov byte ptr [ESI], al  ; save new X
    mov byte ptr [EDI], ah  ; save new Y

    mov dh, byte ptr [EDI]  ; Y for GotoXY
    mov dl, byte ptr [ESI]  ; X for GotoXY
    call GotoXY
    mov al, 69              ; 'E' — enemy sprite
    call WriteChar
    jmp EnemyDone

InvalidMove:
    jmp TryDirection        ; Bad move, pick a new direction

EnemyDone:
    pop edi
    pop esi
    pop eax
    pop ecx
    pop ebx
    ret
MoveEnemy ENDP

END
