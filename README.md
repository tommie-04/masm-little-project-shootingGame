# 🎮 Shooting Game — MASM 32-bit

A console-based shooting game written in x86 Assembly using MASM and the **Irvine32** library.  
Move your ship, dodge enemies, and shoot them down for points!

---

## 📁 Project Structure

```
shooting_game/
│
├── globals.inc          # Shared EXTERN declarations (included by all modules)
│
├── main.asm             # Entry point — owns all .data, runs the game loop
├── DisplayScore.asm     # Renders the score at the top of the screen
├── CheckHit.asm         # Bullet vs. enemy collision detection
├── Shoot.asm            # Bullet animation and hit-check orchestration
├── MoveCharacter.asm    # Player movement and boundary enforcement
├── MoveEnemy.asm        # Random enemy movement with boundary retry
│
├── build.bat            # One-click build script (Windows)
└── README.md
```

---

## 🕹️ Controls

| Key        | Action          |
|------------|-----------------|
| ↑ Arrow    | Move up         |
| ↓ Arrow    | Move down       |
| ← Arrow    | Move left       |
| → Arrow    | Move right      |
| `Space`    | Shoot           |
| `Enter`    | Quit            |

---

## ⚙️ How to Build

### Requirements
- **MASM** (`ml.exe`) — included with Visual Studio or the [MASM32 SDK](http://www.masm32.com/)
- **Irvine32 library** — from *Assembly Language for x86 Processors* by Kip Irvine  
  Default install path: `C:\Irvine`

### Steps

1. Open a **Developer Command Prompt** (or any shell with `ml.exe` in PATH).
2. `cd` into this project folder.
3. Edit `build.bat` if your Irvine32 path differs from `C:\Irvine`.
4. Run:
   ```
   build.bat
   ```
5. Launch the game:
   ```
   ShootingGame.exe
   ```

### Manual build (one-liner)
```bat
ml /c /coff /I"C:\Irvine" main.asm DisplayScore.asm CheckHit.asm Shoot.asm MoveCharacter.asm MoveEnemy.asm
link /SUBSYSTEM:CONSOLE /LIBPATH:"C:\Irvine" main.obj DisplayScore.obj CheckHit.obj Shoot.obj MoveCharacter.obj MoveEnemy.obj Irvine32.lib kernel32.lib user32.lib /OUT:ShootingGame.exe
```

---

## 🧩 Module Overview

| File | Responsibility |
|------|----------------|
| `main.asm` | Defines all global variables, initialises the console, draws the player, and drives the game loop (input → move → render) |
| `globals.inc` | Central `EXTERN` declarations so every module can reference the shared data without duplicating definitions |
| `DisplayScore.asm` | Moves the cursor to `(1, 0)` and writes `"SCORE: "` followed by the current score value |
| `CheckHit.asm` | Given bullet coords in `AL`/`AH` and enemy address pointers in `ESI`/`EDI`, sets `ZF=1` on a hit and marks the enemy dead (`X=127`) |
| `Shoot.asm` | Animates a bullet upward from the player, calls `CheckHit` for each enemy each frame, erases the bullet on miss or hit |
| `MoveCharacter.asm` | Erases the player, applies `X_dir`/`Y_dir`, checks bounds, redraws; sets `BoundaryFlag=1` on out-of-bounds |
| `MoveEnemy.asm` | Erases an enemy, picks a random direction (0–3), validates the move against screen bounds, retries on invalid, then redraws |

---

## 📝 Notes

- Built as **32-bit COFF** targeting the flat memory model (`/coff`).
- Enemy death is signalled by setting both X and Y coordinates to the sentinel value **127**.
- `BoundaryFlag = 1` triggers game-over when the player walks off-screen.
- Bullet speed is controlled by the `Delay 10` call inside `Shoot.asm`.
