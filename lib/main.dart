import 'package:flutter/material.dart';
import 'game.dart';
import 'GameScreen.dart';
import 'SettingsScreen.dart';

void main() {
  runApp(MaterialApp(
    title: 'NOUGHTS & CROSSES',
    home: GameScreen(),
    ));
}

// class NoughtsAndCrossesApp extends StatefulWidget {
//   @override
//   State<NoughtsAndCrossesApp> createState() => _NoughtsAndCrossesAppState();
// }
//
// class _NoughtsAndCrossesAppState extends State<NoughtsAndCrossesApp> {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: NoughtsAndCrossesGame(),  // see file 'gameLogic.dart'
//     );
//   }
// }