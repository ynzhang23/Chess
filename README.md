# Chess
Try it out: [https://replit.com/@ynzhang23/Chess?v=1]

## Features
1. **Constraints with checks on illegal moves and check/mate/stalemate declarations**
2. **Special case moves:**
  - <em>En-passant</em>
  - "check"
  - "mate"
  - "stalemate"
  - castling
  - promote
3. **SAVE/LOAD game using YAML**
  - Both single player and multiplayer game is saveable
  - You can continue your saved multiplayer games
  - You can also load your multiplayer game file into single player mode and let the computer be your opponent 🤠
4. **Single player mode against <em>"drunk_maCPUrthy"</em> who generates random legal moves**

## Challenge Faced
### King's possible moves
1. When updating each piece's possible moves, King must be updated at the end as their possible moves are dependant on the other piece's next possible moves:
  - "Castling": King must not move over a square that is attacked by other pieces
  - "Check": King must not move to a square that is attacked by other pieces
  - "Mate": King is in check and no longer has any possible moves
2. When updating each King's next possible move, the sequence it is ran is dependant on whoever is moving next turn.
3. In case of two kings separated by one square, I needed to take into account of the adjacent squares of the opposite king on top of squares being attacked by other pieces when calculating next_moves.

### Check + Checkmate
1. Through heavy testing, I was able to detect a loophole where the game missed out on pawn's diagonal takes as squares that are checked
2. Apart from that, the checkmate/check process is smoother than I expected thanks to detailed instance variables.

### Save/Load Game
1. Resuming the game with the player who saved the game proved to be less intuitive than I imagined. Managed to solve this by adding a instance variable to Player class that logs if one is the one who saved.
2. Allow player to type 'save_game' at any moment to save and exit the program.
3. The recent Ruby 3.X updates to Psych has prevented YAML from loading class: Symbol as well as unspecified classes. Aliases has to be set to true as well. (This is not reflected in my replit codebase as replit uses ruby 2.7)
```
YAML.load_file(
      "saves/#{filename}",
      aliases: true,
      permitted_classes: [
        WhiteRook,
        BlackRook,
        WhiteKnight,
        BlackKnight,
        WhiteBishop,
        BlackBishop,
        WhiteQueen,
        BlackQueen,
        WhiteKing,
        BlackKing,
        WhitePawn,
        BlackPawn,
        Symbol
      ]
    )
```
## Future Improvements
1. There are a few redundant method calls which updates the pieces' next_moves
2. Visual improvement of the chess board with checkered background
