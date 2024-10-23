import 'package:flutter/material.dart';
import 'dart:math';
import 'dart:core';
import 'SettingsScreen.dart';

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

  bool isCellEmpty(cell) {
    List<int> coordinates = translateCellNumberToCoordinates(cell);
    if (board[coordinates[0]][coordinates[1]].isEmpty) {
      return true;
    } else {
      return false;
    }
  }

  String getCellToken(cell) {
    List<int> coordinates = translateCellNumberToCoordinates(cell);
    return board[coordinates[0]][coordinates[1]];
  }

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
      return [2, 1];
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

  void computerTurnEasy() {
    print("Easy computer move...");
    // Generate random number
    // Check that cell with that number is not filled
    // If not, fill that cell

    var random = Random();
    while (true) {
      int randomCell = random.nextInt(8) + 1; // from 1 up to 9
      if (isCellEmpty(randomCell)) {
        fillCell(randomCell);
        break;
      }
    }
  }

  // Iterates through list of potential three-in-a-row connections. If first two
  // cells are filled with the same token and third cell is empty, returns third cell number
  int identifyTwoInARow() {
    for (var line in threeInARowConnections) {
      if (board[line[0]] == board[line[1]] && board[line[3]].isEmpty) {
        return line[2];
      }
    }
    return 0;
  }

  // Iterates through list of corner cell pairs. If one corner is filled and the other
  // opposite corner cell is empty, returns that empty corner cell number
  int identifyOppositeCornerCell() {
    for (var line in cornerCellPairs) {
      if (board[line[0]].isNotEmpty && board[line[1]].isEmpty) {
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
      fillCell(identifyTwoInARow());
    }
    // Else if you can create two lines of two, play that move
    // TODO
    // Else if centre is free (i.e. cell 5), play there
    else if (getCellToken(5).isEmpty) {
      fillCell(5);
    }
    // Else if player 1 has played in a corner, play opposite corner
    else if (identifyOppositeCornerCell() != 0) {
      fillCell(identifyOppositeCornerCell());
    }
    // Else if there is a free corner, play there
    else if (identifyFreeCornerCell() != 0) {
      fillCell(identifyFreeCornerCell());
    }
    // Else play any empty square
    else {
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
        showEndOfGameDialog(winner);
      }
    }

    if (computerOpponent) {
      computerTurnEasy();
    }
  }

  String identifyWinOrDraw() {
    // Loop through all three rows
    for (int i = 0; i < 3; i++) {
      // Looking for horizontal three-in-a-row connections
      if (board[i][0] == board[i][1] && board[i][1] == board[i][2] && board[i][0].isNotEmpty) {
        gameOver = true;
        return board[i][0]; // Return token of three-in-a-row
      }
      // Looking for vertical three-in-a-row connections
      if (board[0][i] == board[1][i] && board[1][i] == board[2][i] && board[0][i].isNotEmpty) {
        gameOver = true;
        return board[0][i];
      }
    }
    // Diagonal top left to bottom right
    if (board[0][0] == board[1][1] && board[1][1] == board[2][2] && board[0][0].isNotEmpty) {
      gameOver = true;
      return board[0][0];
    }
    // Diagonal top right to bottom left
    if (board[0][2] == board[1][1] && board[1][1] == board[2][0] && board[0][2].isNotEmpty) {
      gameOver = true;
      return board[0][2];
    }

    // Reach here if no three-in-a-row connection is found
    gameOver = true;
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
              newGame();
              Navigator.pop(context);
            },
            child: Text('NEW GAME (COMPUTER)'),
          ),
          TextButton(
            onPressed: () {
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