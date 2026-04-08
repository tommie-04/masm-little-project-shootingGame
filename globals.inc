; ============================================================
; File     : globals.inc
; Purpose  : Shared EXTERN declarations used across all modules.
;            Include this in every .asm module that needs access
;            to global game variables.
;
;            The actual storage (.data) lives only in main.asm.
; ============================================================

; --- Player Data ---
EXTERN curr_X:SBYTE
EXTERN curr_Y:SBYTE
EXTERN X_dir:SBYTE
EXTERN Y_dir:SBYTE

; --- Game State Data ---
EXTERN MAX_WIDTH:BYTE
EXTERN MAX_HEIGHT:BYTE
EXTERN BoundaryFlag:BYTE
EXTERN UPPER_LIMIT:BYTE
EXTERN score:DWORD
EXTERN shoot_Y:SBYTE
EXTERN D_MSG:BYTE

; --- Enemy 1 Data ---
EXTERN E1_X:SBYTE
EXTERN E1_Y:SBYTE
EXTERN E1_X_dir:SBYTE
EXTERN E1_Y_dir:SBYTE

; --- Enemy 2 Data ---
EXTERN E2_X:SBYTE
EXTERN E2_Y:SBYTE
EXTERN E2_X_dir:SBYTE
EXTERN E2_Y_dir:SBYTE

; --- Enemy 3 Data ---
EXTERN E3_X:SBYTE
EXTERN E3_Y:SBYTE
EXTERN E3_X_dir:SBYTE
EXTERN E3_Y_dir:SBYTE
