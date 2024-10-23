import 'package:flutter/material.dart';
import 'dart:math';
import 'dart:core';

//
class NoughtsAndCrossesGame extends StatefulWidget {
  @override
  _NoughtsAndCrossesGameState createState() => _NoughtsAndCrossesGameState();
}

// Class representing N&C game, creates board and handles cell taps by player
class _NoughtsAndCrossesGameState extends State<NoughtsAndCrossesGame> {
  // Variable tracking game difficulty, true = Computer Hard mode, false = Player vs. Player
  bool computerOpponent = false;
  bool gameOver = false;

  // List of Lists representing the game board, 3x3 empty strings
  List<List<String>> board = [];
  String playerToken = 'X';
  String computerToken = 'O';
  String currentPlayer = '';

  List<List<int>> threeInARowConnections = [
    // Horizontals
    [1, 2, 3],
    [1, 3, 2],
    [2, 3, 1],
    [4, 5, 6],
    [4, 6, 5],
    [5, 6, 4],
    [7, 8, 9],
    [7, 9, 8],
    [8, 9, 7],
    // Verticals
    [1, 4, 7],
    [1, 7, 4],
    [4, 7, 1],
    [2, 5, 8],
    [2, 8, 5],
    [5, 8, 2],
    [3, 6, 9],
    [3, 9, 6],
    [6, 9, 3],
    // Diagonals:
    [1, 5, 9],
    [1, 9, 5],
    [5, 9, 1],
    [3, 5, 7],
    [3, 7, 5],
    [5, 7, 3],
  ];

  List<List<int>> twoRowsOfTwoConnections = [
    // 1, 2, 4, 5 permutations
    [1, 2, 4, 5],
    [2, 4, 5, 1],
    [4, 5, 1, 2],
    [5, 1, 2, 4],
    // 2, 3, 5, 6 permutations
    [2, 3, 5, 6],
    [3, 5, 6, 2],
    [5, 6, 2, 3],
    [6, 2, 3, 5],
    // 4, 5, 7, 8 permutations
    [4, 5, 7, 8],
    [5, 7, 8, 4],
    [7, 8, 4, 5],
    [8, 4, 5, 7],
    // 5, 6, 8, 9 permutations
    [5, 6, 8, 9],
    [6, 8, 9, 5],
    [8, 9, 5, 6],
    [9, 5, 6, 8]
  ];

  List<List<int>> cornerCellPairs = [
    [1, 9],
    [3, 7],
    [7, 3],
    [9, 1]
  ];

  List<int> cornerCells = [1, 3, 7, 9];

  @override
  void initState() {
    super.initState();
    initialiseGame();
  }

  // Reset game board to initial state, Clear the game board
  void initialiseGame() {
    gameOver = false;
    board = List.generate(3, (_) => List.filled(3, ''));
    currentPlayer = playerToken;
    setState(() {

    });
  }

  // Returns true if cell parameter has empty string value, false if not empty
  bool isCellEmpty(cell) {
    if (getCellToken(cell).isEmpty) {
      return true;
    } else {
      return false;
    }
  }

  // Returns cell token when given cell number as parameter
  String getCellToken(cell) {
    List<int> coordinates = translateCellNumberToCoordinates(cell);
    return board[coordinates[0]][coordinates[1]];
  }

  // Takes x and y coordinates as parameters and returns corresponding cell number 1-9
  int translateCoordinatesToCellNumber(x, y) {
    if (x == 0 && y == 0) {
      return 1;
    } else if (x == 0 && y == 1) {
      return 2;
    } else if (x == 0 && y == 2) {
      return 3;
    } else if (x == 1 && y == 0) {
      return 4;
    } else if (x == 1 && y == 1) {
      return 5;
    } else if (x == 1 && y == 2) {
      return 6;
    } else if (x == 2 && y == 0) {
      return 7;
    } else if (x == 2 && y == 1) {
      return 8;
    } else if (x == 2 && y == 2) {
      return 9;
    } else {
      return 0;
    }
  }

  // Takes cell number and returns corresponding x and y coordinates as List<int>
  List<int> translateCellNumberToCoordinates(cell) {
    if (cell == 1) {
      return [0, 0];
    } else if (cell == 2) {
      return [0, 1];
    } else if (cell == 3) {
      return [0, 2];
    } else if (cell == 4) {
      return [1, 0];
    } else if (cell == 5) {
      return [1, 1];
    } else if (cell == 6) {
      return [1, 2];
    } else if (cell == 7) {
      return [2, 0];
    } else if (cell == 8) {
      return [2, 1];
    } else if (cell == 9) {
      return [2, 2];
    } else {
      return [0, 0];
    }
  }

  // Starts a new player vs. player game
  void newGame() {
    setState(() {
      initialiseGame();
    });
  }

  // Fills cell provided as parameter with current player's token
  void fillCell(cell) {
    if (isCellEmpty(cell)) {
      List<int> coordinates = translateCellNumberToCoordinates(cell);
      board[coordinates[0]][coordinates[1]] = currentPlayer;
      currentPlayer = (currentPlayer == 'X') ? 'O' : 'X';

      String winner = identifyWinOrDraw();
      if (winner.isNotEmpty) {
        showEndOfGameDialog(winner);
      }
    } else {
      print("Couldn't fill cell");
    }
  }

  // Generates a random number and, if the corresponding cell is empty, fills it
  // with the current player's token
  void computerTurnEasy() {
    var random = Random();
    while (true) {
      int randomCell = random.nextInt(9) + 1; // from 1 up to 9 (0 to 8 + 1)
      if (isCellEmpty(randomCell)) {
        fillCell(randomCell);
        return;
      }
    }
  }

  // Iterates through list of potential three-in-a-row connections. If first two
  // cells are filled with the same token and third cell is empty, returns third cell number
  int identifyTwoInARow() {
    for (var line in threeInARowConnections) {
      if (getCellToken(line[0]).isNotEmpty) {
        if (getCellToken(line[0]) == getCellToken(line[1]) && getCellToken(line[2]).isEmpty) {
          return line[2];
        }
      }
    }
    return 0;
  }

  // Iterates through list of potential three-in-a-row connections. If a complete row
  // all filled with the same token are found, returns that token (used to determine winner)
  String identifyCompleteThreeInARow() {
    for (var line in threeInARowConnections) {
      if (getCellToken(line[0]) == getCellToken(line[1]) && getCellToken(line[0]) == getCellToken(line[2])) {
        return getCellToken(line[0]);
      }
    }
    return '';
  }

  // Iterates through list of potential two-rows-of-two connections. If first three
  // cells are filled and fourth is empty, return fourth cell number
  int identifyTwoRowsOfTwo() {
    for (var block in twoRowsOfTwoConnections) {
      if (getCellToken(block[0]).isNotEmpty && getCellToken(block[1]).isNotEmpty && getCellToken(block[2]).isNotEmpty && getCellToken(block[3]).isEmpty) {
        return block[3];
      }
    }
    return 0;
  }

  // Iterates through list of corner cell pairs. If one corner is filled and the other
  // opposite corner cell is empty, returns that empty corner cell number
  int identifyOppositeCornerCell() {
    for (var line in cornerCellPairs) {
      if (getCellToken(line[0]).isNotEmpty && getCellToken(line[1]).isEmpty) {
        return line[1];
      }
    }
    return 0;
  }

  // Iterates through list of corner cells. If one is free, returns that cell number
  int identifyFreeCornerCell() {
    for (var cell in cornerCells) {
      if (getCellToken(cell).isEmpty) {
        return cell;
      }
    }
    return 0;
  }

  void computerTurnHard() {
    // HARD MODE LOGIC TAKEN FROM ASSIGNMENT DOCUMENT:
    // If any player has two in a row, play the remaining square
    if (identifyTwoInARow() != 0) {
      print("Hard Logic: Identified potential three in a row");
      fillCell(identifyTwoInARow());
    }
    // Else if you can create two lines of two, play that move
    else if (identifyTwoRowsOfTwo() != 0) {
      print("Hard Logic: Identified potential two rows of two");
      fillCell(identifyTwoRowsOfTwo());
    }
    // Else if centre is free (i.e. cell 5), play there
    else if (getCellToken(5).isEmpty) {
      print("Hard Logic: Identified empty centre cell");
      fillCell(5);
    }
    // Else if player 1 has played in a corner, play opposite corner
    else if (identifyOppositeCornerCell() != 0) {
      print("Hard Logic: Identified played corner cell, playing opposite");
      fillCell(identifyOppositeCornerCell());
    }
    // Else if there is a free corner, play there
    else if (identifyFreeCornerCell() != 0) {
      print("Hard Logic: Identified free corner cell");
      fillCell(identifyFreeCornerCell());
    }
    // Else play any empty square
    else {
      print("Hard Logic: Playing random empty square");
      computerTurnEasy();
    }
  }

  // Event handler for a board cell being tapped
  void onCellTapped(int row, int col) {
    if (board[row][col].isEmpty) {
      setState(() {
        board[row][col] = currentPlayer;
        currentPlayer = (currentPlayer == 'X') ? 'O' : 'X';
      });

      String winner = identifyWinOrDraw();
      if (winner.isNotEmpty) {
        gameOver = true;
        showEndOfGameDialog(winner);
      }
    }

    // Computer move is called here, if computerOpponent flag is true and game is not over
    if (computerOpponent && !gameOver) {
      computerTurnHard();
    }
  }

  String identifyWinOrDraw() {
    if (identifyCompleteThreeInARow().isNotEmpty) {
      return identifyCompleteThreeInARow();
    }

    // Reach here if no three-in-a-row connection is found
    bool isDraw = true;

    // Loop through board to ensure that all cells are filled
    for (int i = 0; i < 3; i++) {
      for (int j = 0; j < 3; j++) {
        if (board[i][j].isEmpty) {
          // Can't be draw if any cells are unfilled
          isDraw = false;
          break;
        }
      }
    }
    // Return draw if all cells are filled and no three-in-a-row connection is made
    if (isDraw) {
      return 'Draw';
    }

    // Shouldn't reach here
    return '';
  }

  void showEndOfGameDialog(String winner) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('GAME OVER'),
        content: Text(winner == 'Draw' ? 'DRAW' : '$winner WINS!'),
        actions: [
          TextButton(
            onPressed: () {
              computerOpponent = true;
              newGame();
              Navigator.pop(context);
            },
            child: Text('NEW GAME (COMPUTER)'),
          ),
          TextButton(
            onPressed: () {
              computerOpponent = false;
              newGame();
              Navigator.pop(context);
            },
            child: Text('NEW GAME (PvP)'),
          ),
        ],
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('NOUGHTS & CROSSES'),
      ),

      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[

          // Text showing Current Player at top of screen in PvP mode
          Padding(
            padding: const EdgeInsets.all(28.0),
            child: Text(
              'Current Player: $currentPlayer',
              style: TextStyle(fontSize: 24),
            ),
          ),

          // Gridview to represent 3x3 game board
          Expanded(
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
              ),
              itemCount: 9,
              itemBuilder: (context, index) {
                final row = index ~/ 3;
                final col = index % 3;
                // Use GestureDetector widget to listen for screen tap events
                return GestureDetector(
                  onTap: () => onCellTapped(row, col),
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(),
                    ),
                    child: Center(
                      child: Text(
                        board[row][col],
                        style: TextStyle(fontSize: 48),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          // Button to start a new game against the computer
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: ElevatedButton(
              onPressed: () {
                computerOpponent = true;
                newGame();
              },
                child: Text('NEW GAME (COMPUTER)'),
            ),
          ),

          // Button to start a new game, player vs. player
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: ElevatedButton(
              onPressed: () {
                computerOpponent = false;
                newGame();
              },
              child: Text('NEW GAME (PvP'),
            ),
          ),

        ],
      ),
    );
  }

}