@echo off
REM ============================================================
REM  build.bat  —  Assemble and link ShootingGame (MASM 32-bit)
REM
REM  Requirements:
REM    - MASM (ml.exe) in PATH  (comes with Visual Studio or MASM32 SDK)
REM    - Irvine32.lib + Irvine32.inc accessible (set IRVINE below)
REM    - Link against kernel32.lib and user32.lib
REM
REM  Usage:  build.bat
REM ============================================================

SET IRVINE=C:\Irvine

echo [1/6] Assembling main.asm ...
ml /c /coff /I"%IRVINE%" main.asm
if errorlevel 1 goto error

echo [2/6] Assembling DisplayScore.asm ...
ml /c /coff /I"%IRVINE%" DisplayScore.asm
if errorlevel 1 goto error

echo [3/6] Assembling CheckHit.asm ...
ml /c /coff /I"%IRVINE%" CheckHit.asm
if errorlevel 1 goto error

echo [4/6] Assembling Shoot.asm ...
ml /c /coff /I"%IRVINE%" Shoot.asm
if errorlevel 1 goto error

echo [5/6] Assembling MoveCharacter.asm ...
ml /c /coff /I"%IRVINE%" MoveCharacter.asm
if errorlevel 1 goto error

echo [6/6] Assembling MoveEnemy.asm ...
ml /c /coff /I"%IRVINE%" MoveEnemy.asm
if errorlevel 1 goto error

echo [Link] Linking all object files ...
link /SUBSYSTEM:CONSOLE /LIBPATH:"%IRVINE%" ^
    main.obj DisplayScore.obj CheckHit.obj ^
    Shoot.obj MoveCharacter.obj MoveEnemy.obj ^
    Irvine32.lib kernel32.lib user32.lib ^
    /OUT:ShootingGame.exe
if errorlevel 1 goto error

echo.
echo  Build successful!  ->  ShootingGame.exe
goto end

:error
echo.
echo  BUILD FAILED. See errors above.
exit /b 1

:end
