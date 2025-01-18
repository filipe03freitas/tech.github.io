import 'package:flutter/material.dart';

void main() {
  runApp(JogoDaVelhaApp());
}

class JogoDaVelhaApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Jogo da Velha',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: JogoDaVelhaPage(),
    );
  }
}

class JogoDaVelhaPage extends StatefulWidget {
  @override
  _JogoDaVelhaPageState createState() => _JogoDaVelhaPageState();
}

class _JogoDaVelhaPageState extends State<JogoDaVelhaPage> {
  List<String> _board = List.filled(9, "");
  bool _isXTurn = true;
  int _xScore = 0;
  int _oScore = 0;

  void _resetBoard() {
    setState(() {
      _board = List.filled(9, "");
      _isXTurn = true;
    });
  }

  void _resetGame() {
    setState(() {
      _resetBoard();
      _xScore = 0;
      _oScore = 0;
    });
  }

  void _handleTap(int index) {
    if (_board[index].isNotEmpty) return;

    setState(() {
      _board[index] = _isXTurn ? "X" : "O";
      _isXTurn = !_isXTurn;

      String? winner = _checkWinner();
      if (winner != null) {
        if (winner == "X") {
          _xScore++;
        } else if (winner == "O") {
          _oScore++;
        }
        _showWinnerDialog(winner);
      } else if (!_board.contains("")) {
        _showWinnerDialog("Empate");
      }
    });
  }

  String? _checkWinner() {
    const winPatterns = [
      [0, 1, 2],
      [3, 4, 5],
      [6, 7, 8],
      [0, 3, 6],
      [1, 4, 7],
      [2, 5, 8],
      [0, 4, 8],
      [2, 4, 6],
    ];

    for (var pattern in winPatterns) {
      String a = _board[pattern[0]];
      String b = _board[pattern[1]];
      String c = _board[pattern[2]];

      if (a.isNotEmpty && a == b && b == c) {
        return a;
      }
    }

    return null;
  }

  void _showWinnerDialog(String winner) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(winner == "Empate" ? "Empate!" : "Vitória!"),
        content: Text(
          winner == "Empate" ? "DEU VELHA!" : "Jogador $winner venceu!",
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _resetBoard();
            },
            child: const Text("Jogar Novamente"),
          ),
        ],
      ),
    );
  }

  Widget _buildCell(int index, double cellSize) {
    return GestureDetector(
      onTap: () => _handleTap(index),
      child: Container(
        width: cellSize,
        height: cellSize,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black, width: 1),
        ),
        child: Center(
          child: Text(
            _board[index],
            style: TextStyle(
              fontSize: cellSize * 0.5,
              color: _board[index] == "X" ? Colors.green : Colors.red,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;

    // Define o tamanho máximo do tabuleiro para evitar overflow
    final double boardSize = (screenWidth < screenHeight ? screenWidth : screenHeight) * 0.6;
    final double cellSize = boardSize / 3;

    return Scaffold(
      appBar: AppBar(title: const Text("Jogo da Velha")),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Placar",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    "X: $_xScore",
                    style: TextStyle(fontSize: 18, color: Colors.green),
                  ),
                  Text(
                    "O: $_oScore",
                    style: TextStyle(fontSize: 18, color: Colors.red),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Container(
                width: boardSize,
                height: boardSize,
                child: GridView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                  ),
                  itemBuilder: (context, index) => _buildCell(index, cellSize),
                  itemCount: 9,
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _resetGame,
                child: const Text("Reiniciar Jogo"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
