import 'package:flutter/material.dart';
import 'gameLogic.dart';

void main() {
  runApp(NoughtsAndCrossesApp());
}

class NoughtsAndCrossesApp extends StatefulWidget {
  @override
  State<NoughtsAndCrossesApp> createState() => _NoughtsAndCrossesAppState();
}

class _NoughtsAndCrossesAppState extends State<NoughtsAndCrossesApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: NoughtsAndCrossesGame(),  // see file 'gameLogic.dart'
    );
  }
}