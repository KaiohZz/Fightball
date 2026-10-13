# ⚽ Fightball

Two-player local game developed in **Godot 4** with **GDScript** during a vacation break, as a personal project to practice game development.

<!-- TODO: add a screenshot or GIF of a match, e.g. ![Fightball gameplay](docs/gameplay.gif) -->

<!-- TODO: if you publish a playable build, link it here, e.g. "▶️ Play it on [itch.io](https://...)" -->

---

## 📌 About the Project

Fightball is a personal game project built from scratch in Godot. It was developed over a vacation period to practice the full cycle of making a small game: designing scenes, scripting gameplay in GDScript, handling player input and organizing the project's assets.

<!-- TODO: add 2-3 sentences about the game itself: what the goal of a match is, how a round is won, and what makes it fun. -->

---

## 🎮 Controls

The game is played by two people on the same keyboard.

| Action     | Player 1 | Player 2           |
|------------|----------|--------------------|
| Move left  | `A`      | `←` (Left arrow)   |
| Move right | `D`      | `→` (Right arrow)  |
| Up         | `W`      | `↑` (Up arrow)     |
| Down       | `S`      | `↓` (Down arrow)   |
| Jump       | `Space`  | `5` (Numpad)       |
| Kick       | `J`      | `6` (Numpad)       |

<!-- TODO: confirm what Esc does (pause menu, quit, etc.) and add it to the table. -->

---

## 🛠️ Technologies Used

| Technology         | Usage                                              |
|--------------------|----------------------------------------------------|
| **Godot 4.4**      | Game engine                                        |
| **GDScript**       | Gameplay scripting                                 |
| **Mobile renderer**| Godot rendering method used by the project         |

Project settings worth noting: a **1280 × 720** viewport and a physics tick rate of **240 per second**, for smoother physics-based movement and collisions.

---

## 📂 Project Structure

```
Fightball/
├── assets/                # Sprites, audio and other game resources
├── scenes/                # Godot scenes (.tscn)
├── scripts/               # GDScript source files
├── default_bus_layout.tres # Audio bus layout
├── icon.svg               # Project icon
├── project.godot          # Godot project configuration
└── README.md              # This file
```

---

## 🚀 How to Run the Game

### Prerequisites

- **Godot 4.4** (standard version) → [Download here](https://godotengine.org/download)

---

### Step 1 — Clone the repository

```bash
git clone https://github.com/KaiohZz/Fightball.git
```

---

### Step 2 — Open the project in Godot

1. Open Godot and click **Import**
2. Select the `project.godot` file inside the `Fightball` folder
3. Click **Import & Edit**

---

### Step 3 — Run the game

Press **F5** (or click the ▶️ **Run Project** button at the top right of the editor) and grab a friend to play on the same keyboard.

---

## 📝 Notes

This is a learning project, so the focus is on practicing the fundamentals of game development in Godot rather than on a polished commercial release.
