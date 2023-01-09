# Chess
Command line chess game which two players can play against each other.

## Features
1. Constraints with checks on illegal moves and check/mate/stalemate declarations
2. Special case moves:
  - <em>En-passant</em>
  - "check"
  - "mate"
  - "stalemate"
  - castling
  - promote
3. Loadable gameplay with saves made in Portable Game Notation (PGN)
4. Single player mode against <em>"drunk_maCPUrthy"</em> who generates random legal moves

## Challenge Faced
### King's possible moves
1. When updating each piece's possible moves, King must be updated at the end as their possible moves are dependant on the other piece's next possible moves:
  - "Castling": King must not move over a square that is attacked by other pieces
  - "Check": King must not move to a square that is attacked by other pieces
  - "Mate": King is in check and no longer has any possible moves
2. When updating each King's next possible move, the sequence it is ran is dependant on whoever is moving next turn.
3. In case of two kings separated by one square, I needed to take into account of the adjacent squares of the opposite king on top of squares being attacked by other pieces when calculating next_moves.