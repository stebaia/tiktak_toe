import 'package:flutter/material.dart';

void main() {
  runApp(TicTacToe());
}

class TicTacToe extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tic Tac Toe',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: GameScreen(),
    );
  }
}

class GameScreen extends StatefulWidget {
  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late List<String> board;
  late String currentPlayer;
  late String winner;
  late bool gameOver;

  @override
  void initState() {
    super.initState();
    startGame();
  }

  void startGame() {
    board = List.filled(9, '');
    currentPlayer = 'X';
    winner = '';
    gameOver = false;
  }

  void playMove(int index) {
    if (!gameOver && board[index] == '') {
      setState(() {
        board[index] = currentPlayer;
        if (_checkWinner()) {
          winner = currentPlayer;
          gameOver = true;
        } else if (!_checkEmptyCells()) {
          gameOver = true;
        } else {
          currentPlayer = (currentPlayer == 'X') ? 'O' : 'X';
        }
      });
    }
  }

  bool _checkWinner() {
    // Check rows, columns, and diagonals for a winner
    for (var i = 0; i < 3; i++) {
      if (board[i * 3] != '' &&
          board[i * 3] == board[i * 3 + 1] &&
          board[i * 3] == board[i * 3 + 2]) {
        return true; // Check rows
      }
      if (board[i] != '' &&
          board[i] == board[i + 3] &&
          board[i] == board[i + 6]) {
        return true; // Check columns
      }
    }
    if (board[0] != '' && board[0] == board[4] && board[0] == board[8]) {
      return true; // Check diagonal (top-left to bottom-right)
    }
    if (board[2] != '' && board[2] == board[4] && board[2] == board[6]) {
      return true; // Check diagonal (top-right to bottom-left)
    }
    return false;
  }

  bool _checkEmptyCells() {
    return board.contains('');
  }

  Widget buildGrid() {
    return GridView.builder(
      itemCount: 9,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
      ),
      itemBuilder: (BuildContext context, int index) {
        return GestureDetector(
          onTap: () {
            playMove(index);
          },
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            elevation: 4.0,
            child: Center(
              child: Text(
                board[index],
                style: TextStyle(
                  fontSize: 48.0,
                  fontWeight: FontWeight.bold,
                  color: (board[index] == 'X')
                      ? Colors.blue
                      : (board[index] == 'O')
                          ? Colors.red
                          : Colors.black,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tic Tac Toe'),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.lightBlueAccent, Colors.blue],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                gameOver
                    ? (winner.isNotEmpty ? 'Winner: $winner' : 'It\'s a draw!')
                    : 'Current Player: $currentPlayer',
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20.0),
              SizedBox(
                width: 300.0,
                height: 300.0,
                child: buildGrid(),
              ),
              SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    startGame();
                  });
                },
                child: Text('Restart Game'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
