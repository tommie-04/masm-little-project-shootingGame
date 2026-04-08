; ============================================================
; File     : main.asm
; Purpose  : Entry point. Owns all global .data variables and
;            contains the main game loop.
; Depends  : Irvine32, globals.inc
;            DisplayScore.asm, MoveCharacter.asm,
;            MoveEnemy.asm,   Shoot.asm
; Build    : ml /c /coff main.asm
; Link     : link /SUBSYSTEM:CONSOLE main.obj DisplayScore.obj
;                  CheckHit.obj Shoot.obj MoveCharacter.obj
;                  MoveEnemy.obj Irvine32.lib kernel32.lib
;                  user32.lib /OUT:ShootingGame.exe
; ============================================================

INCLUDE Irvine32.inc

.MODEL flat, stdcall
SetConsoleOutputCP PROTO :DWORD

; --- External procedures from other modules ---
EXTERN DisplayScore:PROC
EXTERN MoveCharacter:PROC
EXTERN MoveEnemy:PROC
EXTERN Shoot:PROC

; ============================================================
; Global data — defined HERE, declared EXTERN in globals.inc
; ============================================================
.data

; --- Player Data ---
curr_X      SBYTE   60
curr_Y      SBYTE   14
X_dir       SBYTE   0
Y_dir       SBYTE   0

; --- Game State Data ---
MAX_WIDTH   BYTE    ?
MAX_HEIGHT  BYTE    ?
BoundaryFlag BYTE   0
UPPER_LIMIT BYTE    ?
score       DWORD   0
shoot_Y     SBYTE   ?
D_MSG       BYTE    "SCORE: ", 0

; --- Enemy 1 Data ---
E1_X        SBYTE   30
E1_Y        SBYTE   2
E1_X_dir    SBYTE   0
E1_Y_dir    SBYTE   0

; --- Enemy 2 Data ---
E2_X        SBYTE   60
E2_Y        SBYTE   3
E2_X_dir    SBYTE   0
E2_Y_dir    SBYTE   0

; --- Enemy 3 Data ---
E3_X        SBYTE   90
E3_Y        SBYTE   3
E3_X_dir    SBYTE   0
E3_Y_dir    SBYTE   0

; ============================================================
.code
; ============================================================

main PROC
    ; --- Console setup ---
    INVOKE SetConsoleOutputCP, 437
    call GetMaxXY               ; AL = max rows, DL = max cols
    mov MAX_HEIGHT, al
    mov MAX_WIDTH, dl

    ; --- Compute upper limit (1/3 of screen height) ---
    mov al, MAX_HEIGHT
    mov bl, 3
    div bl
    mov UPPER_LIMIT, al

    call DisplayScore

    ; --- Draw player at starting position ---
    mov dh, curr_Y
    mov dl, curr_X
    call GotoXY
    mov al, 65                  ; 'A' — player sprite
    call WriteChar

; ============================================================
; Main Game Loop
; ============================================================
waitForKey:
    cmp BoundaryFlag, 1
    je  endProgram

    ; --- Enemy 1: skip if dead (X == 127) ---
    mov al, E1_X
    cmp al, 127
    je  NextEnemy2
    xor ebx, ebx
    xor ecx, ecx
    mov esi, OFFSET E1_X
    mov edi, OFFSET E1_Y
    mov ebx, OFFSET E1_X_dir
    mov ecx, OFFSET E1_Y_dir
    call MoveEnemy

NextEnemy2:
    ; --- Enemy 2: skip if dead ---
    mov al, E2_X
    cmp al, 127
    je  NextEnemy3
    xor ebx, ebx
    xor ecx, ecx
    mov esi, OFFSET E2_X
    mov edi, OFFSET E2_Y
    mov ebx, OFFSET E2_X_dir
    mov ecx, OFFSET E2_Y_dir
    call MoveEnemy

NextEnemy3:
    ; --- Enemy 3: skip if dead ---
    mov al, E3_X
    cmp al, 127
    je  EndEnemyLoop
    xor ebx, ebx
    xor ecx, ecx
    mov esi, OFFSET E3_X
    mov edi, OFFSET E3_Y
    mov ebx, OFFSET E3_X_dir
    mov ecx, OFFSET E3_Y_dir
    call MoveEnemy

EndEnemyLoop:
    ; --- Frame delay + player movement ---
    mov eax, 100
    call Delay
    call MoveCharacter

    ; --- Input handling ---
    call ReadKey
    jnz  keyPressed
    jmp  waitForKey

keyPressed:
    cmp ax, 4800h               ; Up arrow
    je  upArrow
    cmp ax, 5000h               ; Down arrow
    je  downArrow
    cmp ax, 4D00h               ; Right arrow
    je  rightArrow
    cmp ax, 4B00h               ; Left arrow
    je  leftArrow
    cmp al, 20h                 ; Spacebar — shoot
    je  ShootAction
    cmp al, 0Dh                 ; Enter — quit
    je  endProgram
    jmp waitForKey

ShootAction:
    call Shoot
    jmp  waitForKey

upArrow:
    mov Y_dir, -1
    mov X_dir,  0
    jmp waitForKey

downArrow:
    mov Y_dir,  1
    mov X_dir,  0
    jmp waitForKey

rightArrow:
    mov X_dir,  1
    mov Y_dir,  0
    jmp waitForKey

leftArrow:
    mov X_dir, -1
    mov Y_dir,  0
    jmp waitForKey

endProgram:
    nop
    exit
main ENDP
END main
