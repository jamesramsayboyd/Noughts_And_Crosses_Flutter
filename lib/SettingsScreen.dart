import 'package:flutter/material.dart';
import 'GameScreen.dart';

class ReturnToGameRoute extends StatelessWidget {
  const ReturnToGameRoute({super.key});

  void toggleDifficulty() {
    if (difficulty == "PvP") {
        difficulty = "Computer";
    } else {
        difficulty = "PvP";
    }

    print("Difficulty = " + difficulty);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SETTINGS'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[

          Padding(
            padding: const EdgeInsets.all(20.0),
            child: ElevatedButton(
              onPressed: toggleDifficulty,
              child: Text('DIFFICULTY'),
            ),
          ),

          // Button to save settings and return to start new game, bottom of Column
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('SAVE AND RETURN'),
            ),
          ),


        ]

      ),
    );
  }
}