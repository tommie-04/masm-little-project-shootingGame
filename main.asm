; ============================================================
; File     : main.asm
; ============================================================
INCLUDE Irvine32.inc

.MODEL flat, stdcall
SetConsoleOutputCP PROTO :DWORD

EXTERN _DisplayScore:PROC
EXTERN _MoveCharacter:PROC
EXTERN _MoveEnemy:PROC
EXTERN _Shoot:PROC

.data

curr_X      SBYTE   60
curr_Y      SBYTE   14
X_dir       SBYTE   0
Y_dir       SBYTE   0

MAX_WIDTH   BYTE    ?
MAX_HEIGHT  BYTE    ?
BoundaryFlag BYTE   0
UPPER_LIMIT BYTE    ?
score       DWORD   0
shoot_Y     SBYTE   ?
D_MSG       BYTE    "SCORE: ", 0

E1_X        SBYTE   30
E1_Y        SBYTE   2
E1_X_dir    SBYTE   0
E1_Y_dir    SBYTE   0

E2_X        SBYTE   60
E2_Y        SBYTE   3
E2_X_dir    SBYTE   0
E2_Y_dir    SBYTE   0

E3_X        SBYTE   90
E3_Y        SBYTE   3
E3_X_dir    SBYTE   0
E3_Y_dir    SBYTE   0

.code

main PROC
    INVOKE SetConsoleOutputCP, 437
    call GetMaxXY
    mov MAX_HEIGHT, al
    mov MAX_WIDTH, dl

    mov al, MAX_HEIGHT
    mov bl, 3
    div bl
    mov UPPER_LIMIT, al

    call _DisplayScore

    mov dh, curr_Y
    mov dl, curr_X
    call GotoXY
    mov al, 65
    call WriteChar

waitForKey:
    cmp BoundaryFlag, 1
    je  endProgram

    mov al, E1_X
    cmp al, 127
    je  NextEnemy2
    xor ebx, ebx
    xor ecx, ecx
    mov esi, OFFSET E1_X
    mov edi, OFFSET E1_Y
    mov ebx, OFFSET E1_X_dir
    mov ecx, OFFSET E1_Y_dir
    call _MoveEnemy

NextEnemy2:
    mov al, E2_X
    cmp al, 127
    je  NextEnemy3
    xor ebx, ebx
    xor ecx, ecx
    mov esi, OFFSET E2_X
    mov edi, OFFSET E2_Y
    mov ebx, OFFSET E2_X_dir
    mov ecx, OFFSET E2_Y_dir
    call _MoveEnemy

NextEnemy3:
    mov al, E3_X
    cmp al, 127
    je  EndEnemyLoop
    xor ebx, ebx
    xor ecx, ecx
    mov esi, OFFSET E3_X
    mov edi, OFFSET E3_Y
    mov ebx, OFFSET E3_X_dir
    mov ecx, OFFSET E3_Y_dir
    call _MoveEnemy

EndEnemyLoop:
    mov eax, 100
    call Delay
    call _MoveCharacter

    call ReadKey
    jnz  keyPressed
    jmp  waitForKey

keyPressed:
    cmp ax, 4800h
    je  upArrow
    cmp ax, 5000h
    je  downArrow
    cmp ax, 4D00h
    je  rightArrow
    cmp ax, 4B00h
    je  leftArrow
    cmp al, 20h
    je  ShootAction
    cmp al, 0Dh
    je  endProgram
    jmp waitForKey

ShootAction:
    call _Shoot
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
