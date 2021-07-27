import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pong/brick.dart';
import 'package:pong/coverscreen.dart';
import 'package:pong/pong.dart';
import 'package:pong/score.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

enum direction { UP, DOWN, LEFT, RIGHT }

class _HomePageState extends State<HomePage> {
  // brick variables
  double brickWidth = 0.3; // out of 2, 2 being the entire width of the screen
  double bottomBrickX = -0.25;
  double topBrickX = 0;
  var topBrickDirection = direction.LEFT;

  // pong variables
  double pongX = 0;
  double pongY = 0;
  double pongXincrement = 0.005;
  double pongYincrement = 0.01;
  var pongDirectionX = direction.LEFT;
  var pongDirectionY = direction.UP;

  // game settings
  bool gameHasStarted = false;
  int player1score = 0;
  int player2score = 0;

  void startGame() {
    gameHasStarted = true;

    Timer.periodic(Duration(milliseconds: 1), (timer) {
      updateDirection();

      // move the enemy (top brick)
      moveEnemy();

      // move ball
      moveBall();

      // check if ball is out of bounds
      if (isPlayer1Dead()) {
        _showDialog();
        player2score++;
        timer.cancel();
      }
      if (isPlayer2Dead()) {
        _showDialog();
        player1score++;
        timer.cancel();
      }
    });
  }

  void updateDirection() {
    setState(() {
      // set vertical direction for ball
      if (pongY >= 0.99) {
        pongDirectionY = direction.UP;
        // if the ball hits the left side of the brick
        // direction of pong becomes left
        if (pongX <= bottomBrickX + brickWidth / 2) {
          pongDirectionX = direction.LEFT;
        }
        // if the ball hits the left side of the brick
        // direction of pong becomes left
        if (pongX >= bottomBrickX + brickWidth / 2) {
          pongDirectionX = direction.RIGHT;
        }
      }
      if (pongY <= -0.99) {
        pongDirectionY = direction.DOWN;
      }

      // set horizontal direction for ball
      if (pongX >= 1) {
        pongDirectionX = direction.LEFT;
      }
      if (pongX <= -1) {
        pongDirectionX = direction.RIGHT;
      }

      // set horizontal direction for top brick
      if (topBrickX >= 1) {
        topBrickDirection = direction.LEFT;
      } else if (topBrickX <= -1) {
        topBrickDirection = direction.RIGHT;
      }
    });
  }

  void moveBall() {
    // y movement for ball
    setState(() {
      if (pongDirectionY == direction.DOWN) {
        pongY += pongYincrement;
      } else if (pongDirectionY == direction.UP) {
        pongY -= pongYincrement;
      }
    });

    // x movement for ball
    setState(() {
      if (pongDirectionX == direction.LEFT) {
        pongX -= pongXincrement;
      } else if (pongDirectionX == direction.RIGHT) {
        pongX += pongXincrement;
      }
    });
  }

  void moveEnemy() {
    // horizontal movement for top brick
    setState(() {
      topBrickX = pongX;
    });
  }

  bool isPlayer1Dead() {
    if (pongY >= 0.99 && pongX + 0.01 < bottomBrickX) {
      return true;
    } else if (pongY >= 0.99 && pongX - 0.01 > bottomBrickX + brickWidth) {
      return true;
    }

    return false;
  }

  bool isPlayer2Dead() {
    if (pongY <= -0.99 && pongX + 0.01 < topBrickX) {
      return true;
    } else if (pongY <= -0.99 && pongX - 0.01 > topBrickX + brickWidth) {
      return true;
    }

    return false;
  }

  void _showDialog() {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Colors.deepPurple,
            title: Center(
              child: Text(
                "PURPLE WIN",
                style: TextStyle(color: Colors.white),
              ),
            ),
            actions: [
              GestureDetector(
                onTap: resetGame,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: Container(
                    padding: EdgeInsets.all(7),
                    color: Colors.deepPurple[100],
                    child: Text(
                      'PLAY AGAIN',
                      style: TextStyle(color: Colors.deepPurple[800]),
                    ),
                  ),
                ),
              )
            ],
          );
        });
  }

  void resetGame() {
    Navigator.pop(context); // dismisses the alert dialog
    setState(() {
      bottomBrickX = -0.25;
      topBrickX = 0;
      pongX = 0;
      pongY = 0;
      gameHasStarted = false;
      pongDirectionX = direction.LEFT;
      pongDirectionY = direction.UP;
    });
  }

  void moveLeft() {
    setState(() {
      // move left only if it doesn't go off the left edge
      if (!(bottomBrickX - 0.125 < -1)) {
        bottomBrickX -= 0.125;
      }
    });
  }

  void moveRight() {
    setState(() {
      // move right only if it doesn't go off the right edge
      if (!(bottomBrickX + brickWidth + 0.125 > 1)) {
        bottomBrickX += 0.125;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // screen dimensions
    double totalWidth = MediaQuery.of(context).size.width;
    double totalHeight = MediaQuery.of(context).size.height;

    return GestureDetector(
      onTap: gameHasStarted ? () {} : startGame,
      child: RawKeyboardListener(
        focusNode: FocusNode(),
        autofocus: true,
        onKey: (event) {
          if (event.isKeyPressed(LogicalKeyboardKey.arrowLeft)) {
            moveLeft();
          } else if (event.isKeyPressed(LogicalKeyboardKey.arrowRight)) {
            moveRight();
          }
        },
        child: Scaffold(
          backgroundColor: Colors.grey[900],
          body: Center(
            child: Stack(
              children: [
                // left controls for tapping
                GestureDetector(
                  onTap: moveLeft,
                  child: Container(
                    alignment: Alignment(-1, 1),
                    child: Container(
                      width: MediaQuery.of(context).size.width / 2,
                      height: double.infinity,
                      color: Colors.grey[900],
                    ),
                  ),
                ),

                // left controls for tapping
                GestureDetector(
                  onTap: moveRight,
                  child: Container(
                    alignment: Alignment(1, 1),
                    child: Container(
                      width: MediaQuery.of(context).size.width / 2,
                      height: double.infinity,
                      color: Colors.grey[900],
                    ),
                  ),
                ),

                // scoreboard
                ScoreBoard(
                  gameHasStarted: gameHasStarted,
                  player1score: player1score,
                  player2score: player2score,
                ),

                // top brick
                MyBrick(
                  x: topBrickX,
                  width: totalWidth * brickWidth / 2,
                  isThisTopBrick: true,
                  gameHasStarted: gameHasStarted,
                ),

                // bottom brick
                MyBrick(
                  x: (2 * bottomBrickX + brickWidth) / (2 - brickWidth),
                  width: totalWidth * brickWidth / 2,
                  isThisTopBrick: false,
                  gameHasStarted: gameHasStarted,
                ),

                // pong ball
                MyPongBall(
                  gameHasStarted: gameHasStarted,
                  x: pongX,
                  y: pongY,
                ),

                // tap to play
                CoverScreen(
                  gameHasStarted: gameHasStarted,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
