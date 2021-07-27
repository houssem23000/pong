import 'package:flutter/material.dart';

class MyBrick extends StatelessWidget {
  final x;
  final width;
  final bool isThisTopBrick;
  final bool gameHasStarted;

  MyBrick(
      {this.x,
      this.width,
      required this.isThisTopBrick,
      required this.gameHasStarted});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment(x, isThisTopBrick ? -0.99 : 0.99),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Container(
          width: width,
          height: 15,
          color: gameHasStarted
              ? (isThisTopBrick ? Colors.deepPurple[300] : Colors.pink[300])
              : Colors.grey[800],
        ),
      ),
    );
  }
}
