import 'package:flutter/material.dart';

class ScoreBoard extends StatelessWidget {
  final bool gameHasStarted;
  final int player1score;
  final int player2score;

  ScoreBoard(
      {required this.gameHasStarted,
      required this.player1score,
      required this.player2score});

  @override
  Widget build(BuildContext context) {
    return gameHasStarted
        ? Stack(
            children: [
              Container(
                alignment: Alignment(0, -0.3),
                child: Text(
                  player2score.toString(),
                  style: TextStyle(color: Colors.grey[800], fontSize: 100),
                ),
              ),
              Container(
                alignment: Alignment(0, 0),
                child: Container(
                  width: MediaQuery.of(context).size.width / 4,
                  height: 1,
                  color: Colors.grey[800],
                ),
              ),
              Container(
                alignment: Alignment(0, 0.3),
                child: Text(
                  player1score.toString(),
                  style: TextStyle(color: Colors.grey[800], fontSize: 100),
                ),
              ),
            ],
          )
        : Container();
  }
}
