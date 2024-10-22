import 'package:flutter/material.dart';
import 'SettingsScreen.dart';
import 'GameSettings.dart';

class GameScreen extends StatelessWidget {
  const GameScreen({super.key});

  void newGame() {
    print("New Game button pressed");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
        title: const Text('NOUGHTS & CROSSES'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,

        children: <Widget>[

          // Child of Column, Settings button containing route to SettingsScreen
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: ElevatedButton(
              child: Text('SETTINGS'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ReturnToGameRoute()),
                );
              },
            ),
          ),

          // Child of Column, New Game button reinitialising game
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: ElevatedButton(
              onPressed: newGame,
              child: Text('NEW GAME (COMPUTER)'),
            ),
          ),

          // Child of Column, New Game button reinitialising game
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: ElevatedButton(
              onPressed: newGame,
              child: Text('NEW GAME (PvP)'),
            ),
          ),

        ],
      ),
    );
  }
}