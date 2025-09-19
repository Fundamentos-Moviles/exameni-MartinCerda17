import 'package:buscaminas_app/cell.dart';
import 'package:buscaminas_app/constants.dart' as consts;
import 'package:flutter/material.dart';
import 'dart:math';

class ScreenBuscaminas extends StatefulWidget {
  const ScreenBuscaminas({super.key});

  @override
  State<ScreenBuscaminas> createState() => _ScreenBuscaminasState();
}

class _ScreenBuscaminasState extends State<ScreenBuscaminas> {
  final int gridSize = consts.gridSize;
  final int numberOfMines = consts.numberOfMines;

  late List<Cell> board;
  bool gameOver = false;
  int cellsRevealed = 0;
  String statusMessage = '';

  @override
  void initState() {
    super.initState();
    _initializeGame();
  }

  void _initializeGame() {
    setState(() {
      gameOver = false;
      cellsRevealed = 0;
      statusMessage = '';
      board = List.generate(gridSize * gridSize, (index) => Cell());

      int minesPlaced = 0;
      final random = Random();
      while (minesPlaced < numberOfMines) {
        int minePosition = random.nextInt(gridSize * gridSize);
        if (!board[minePosition].isMine) {
          board[minePosition].isMine = true;
          minesPlaced++;
        }
      }
    });
  }

  void _handleTap(int index) {
    if (gameOver || board[index].isRevealed) {
      return;
    }

    setState(() {
      board[index].isRevealed = true;

      if (board[index].isMine) {
        _endGame(false);
      } else {
        cellsRevealed++;
        if (cellsRevealed == (gridSize * gridSize - numberOfMines)) {
          _endGame(true);
        }
      }
    });
  }

  void _endGame(bool won) {
    gameOver = true;
    if (won) {
      statusMessage = '¡Felicidades, ganaste!';
    } else {
      statusMessage = 'Perdiste.';

      for (var cell in board) {
        if (cell.isMine) {
          cell.isRevealed = true;
        }
      }
    }
  }

  Color _getCellColor(Cell cell) {
    if (!cell.isRevealed) {
      return consts.inactivo;
    }
    if (cell.isMine) {
      return consts.mina;
    }
    return consts.correcto;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Buscaminas'), centerTitle: true),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'José Martín Cerda Estrada',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              AspectRatio(
                aspectRatio: 1.0,
                child: GridView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: gridSize,
                    crossAxisSpacing: 4.0,
                    mainAxisSpacing: 4.0,
                  ),
                  itemCount: gridSize * gridSize,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () => _handleTap(index),
                      child: Container(
                        decoration: BoxDecoration(
                          color: _getCellColor(board[index]),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 20),

              // Mensaje de estado del juego.
              SizedBox(
                height: 30,
                child: Text(
                  statusMessage,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: statusMessage.contains('ganaste')
                        ? Colors.green
                        : Colors.red,
                  ),
                ),
              ),
              const SizedBox(height: 10),

              // Botón para reiniciar.
              ElevatedButton(
                onPressed: _initializeGame,
                style: ElevatedButton.styleFrom(
                  backgroundColor: consts.buttonColor,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 40,
                    vertical: 15,
                  ),
                  textStyle: const TextStyle(fontSize: 18),
                ),
                child: const Text(
                  'Reiniciar Juego',
                  style: TextStyle(color: consts.buttonTextColor),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
