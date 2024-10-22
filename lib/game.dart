import 'package:flutter/material.dart';
import 'SettingsScreen.dart';

//
class NoughtsAndCrossesGame extends StatefulWidget {
  @override
  _NoughtsAndCrossesGameState createState() => _NoughtsAndCrossesGameState();
}

// Class representing N&C game, creates board and handles cell taps by player
class _NoughtsAndCrossesGameState extends State<NoughtsAndCrossesGame> {
  bool computerOpponent = false;

  List<List<String>> board = [];
  String playerToken = 'X';
  String computerToken = 'O';
  String currentPlayer = '';

  @override
  void initState() {
    super.initState();
    initialiseGame();
  }

  void initialiseGame() {
    board = List.generate(3, (_) => List.filled(3, ''));
    currentPlayer = playerToken;
    setState(() {

    });
  }

  // Starts a new player vs. player game
  void newGame() {
    setState(() {
      initialiseGame();
    });
  }

  void onCellTapped(int row, int col) {
    if (board[row][col].isEmpty) {
      setState(() {
        board[row][col] = currentPlayer;
        currentPlayer = (currentPlayer == 'X') ? 'O' : 'X';
      });

      String winner = checkForWinner();
      if (winner.isNotEmpty) {
        showWinnerDialog(winner);
      }
    }
  }

  String checkForWinner() {
    for (int i = 0; i < 3; i++) {
      if (board[i][0] == board[i][1] && board[i][1] == board[i][2] && board[i][0].isNotEmpty) {
        return board[i][0];
      }
      if (board[0][i] == board[1][i] && board[1][i] == board[2][i] && board[0][i].isNotEmpty) {
        return board[0][i];
      }
    }
    if (board[0][0] == board[1][1] && board[1][1] == board[2][2] && board[0][0].isNotEmpty) {
      return board[0][0];
    }
    if (board[0][2] == board[1][1] && board[1][1] == board[2][0] && board[0][2].isNotEmpty) {
      return board[0][2];
    }

    bool isDraw = true;
    for (int i = 0; i < 3; i++) {
      for (int j = 0; j < 3; j++) {
        if (board[i][j].isEmpty) {
          isDraw = false;
          break;
        }
      }
    }
    if (isDraw) {
      return 'Draw';
    }

    return '';
  }

  void showWinnerDialog(String winner) {
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

          // Text child of Column, shows Current Player at top of screen in PvP mode
          Padding(
            padding: const EdgeInsets.all(28.0),
            child: Text(
              'Current Player: $currentPlayer',
              style: TextStyle(fontSize: 24),
            ),
          ),

          // Expanded child of Column, show game board
          Expanded(
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
              ),
              itemCount: 9,
              itemBuilder: (context, index) {
                final row = index ~/ 3;
                final col = index % 3;
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

          // Padding child of Column, Settings button at bottom
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

          // Padding child of Column, New Game button at bottom
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