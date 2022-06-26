import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String millisecondsText = '';
  GameState gameState = GameState.readyToStart;
  Timer? waitingTimer;
  Timer? stoppableTimer;
  Color colorOfPushButton = Color(0xFF40CA88);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF282E3D),
      body: Stack(
        children: [
          const Align(
              alignment: Alignment(0, -0.9),
              child: Text(
                "Test your\nreaction speed",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 38,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              )),
          Align(
              alignment: Alignment.center,
              child: ColoredBox(
                color: const Color(0xFF6D6D6D) ,
                child: SizedBox(
                  height: 80,
                  width: 300,
                  child: Center(
                    child: Text(
                      millisecondsText,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.normal,
                          color: Colors.white),
                    ),
                  ),
                ),
              )),
          Align(
            alignment: const Alignment(0, 0.9),
            child: GestureDetector(
              onTap: () => setState(() {
                // debugPrint('Curent gameState = $gameState');
                switch (gameState) {
                  case GameState.readyToStart:
                    gameState = GameState.waiting;
                    millisecondsText = '';
                    _startWaitingTimer();
                    break;
                  case GameState.waiting:
                    // gameState = GameState.canBeStopped;
                    break;
                  case GameState.canBeStopped:
                    gameState = GameState.readyToStart;
                    colorOfPushButton = Color(0xFF40CA88);
                    stoppableTimer?.cancel();
                    break;
                }
              }),
              child: ColoredBox(
                color: colorOfPushButton,
                child: SizedBox(
                  height: 130,
                  width: 130,
                  child: Center(
                    child: Text(
                      _getButtonText(),
                      style: const TextStyle(
                          fontSize: 38,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getButtonText() {
    String res = '';
    switch (gameState) {
      case GameState.readyToStart:
        res = 'START';
        break;
      case GameState.waiting:
        res = 'WAIT';
        break;
      case GameState.canBeStopped:
        res = 'STOP';
        break;
    }
    return res;
  }

  void _startWaitingTimer() {
    final int randomMilliseconds = Random().nextInt(4000) + 1000;
    // debugPrint('!!! $randomMilliseconds');
    colorOfPushButton = Color(0xFFE0982D);
    waitingTimer = Timer(Duration(milliseconds: randomMilliseconds), () {
    // waitingTimer = Timer(Duration(seconds: 5), () {
      setState(() {
        gameState = GameState.canBeStopped;
        colorOfPushButton = Color(0xFFE02D47);
      });
      _startStoppableTimer();
    });
  }

  void _startStoppableTimer() {
    stoppableTimer = Timer.periodic(Duration(milliseconds: 16), (timer) {
      setState(() {
        millisecondsText = "${timer.tick * 16} ms";
      });
    });
  }

  @override
  void dispose() {
    waitingTimer?.cancel();
    stoppableTimer?.cancel();
    super.dispose();
  }
}

enum GameState { readyToStart, waiting, canBeStopped }
