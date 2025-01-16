import 'package:flutter/material.dart';

void main() {
  runApp(CalculadoraApp());
}

class CalculadoraApp extends StatelessWidget {
  const CalculadoraApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calculadora Web',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: CalculadoraPage(),
    );
  }
}

class CalculadoraPage extends StatefulWidget {
  const CalculadoraPage({super.key});

  @override
  _CalculadoraPageState createState() => _CalculadoraPageState();
}

class _CalculadoraPageState extends State<CalculadoraPage> {
  String _output = "0";
  String _expression = "";
  String _operation = "";
  double _num1 = 0;
  double _num2 = 0;

  void _buttonPressed(String buttonText) {
    setState(() {
      if (buttonText == "C") {
        _output = "0";
        _expression = "";
        _operation = "";
        _num1 = 0;
        _num2 = 0;
      } else if (buttonText == "+" || buttonText == "-" || buttonText == "*" || buttonText == "/") {
        _num1 = double.parse(_output);
        _operation = buttonText;
        _expression = "$_output $buttonText";
        _output = "0";
      } else if (buttonText == "=") {
        _num2 = double.parse(_output);
        if (_operation == "+") {
          _output = (_num1 + _num2).toString();
        } else if (_operation == "-") {
          _output = (_num1 - _num2).toString();
        } else if (_operation == "*") {
          _output = (_num1 * _num2).toString();
        } else if (_operation == "/") {
          _output = _num2 != 0 ? (_num1 / _num2).toString() : "Erro";
        }
        _expression = "";
        _operation = "";
      } else {
        _output = _output == "0" ? buttonText : _output + buttonText;

        if (_operation.isNotEmpty) {
          _expression = "$_num1 $_operation $_output";
        } else {
          _expression = _output;
        }
      }
    });
  }

  Widget _buildButton(String buttonText, Color color) {
    return Container(
      margin: const EdgeInsets.all(8), // Espaço maior entre os botões
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          padding: const EdgeInsets.all(16), // Aumenta o tamanho interno dos botões
          minimumSize: const Size(80, 80), // Define um tamanho maior para os botões
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(0),
            side: const BorderSide(color: Colors.black, width: 2),
          ),
        ),
        onPressed: () => _buttonPressed(buttonText),
        child: Text(
          buttonText,
          style: const TextStyle(fontSize: 24, color: Colors.white), // Texto maior
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calculadora Web'),
      ),
      body: Column(
        children: [
          Container(
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Text(
              _expression,
              style: const TextStyle(fontSize: 24, color: Colors.grey),
            ),
          ),
          Expanded(
            child: Container(
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.all(24),
              child: Text(
                _output,
                style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          const Divider(),
          // Centraliza os botões
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildButton("7", Colors.blue),
                    _buildButton("8", Colors.blue),
                    _buildButton("9", Colors.blue),
                    _buildButton("/", Colors.orange),
                  ],
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildButton("4", Colors.blue),
                    _buildButton("5", Colors.blue),
                    _buildButton("6", Colors.blue),
                    _buildButton("*", Colors.orange),
                  ],
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildButton("1", Colors.blue),
                    _buildButton("2", Colors.blue),
                    _buildButton("3", Colors.blue),
                    _buildButton("-", Colors.orange),
                  ],
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildButton("C", Colors.red),
                    _buildButton("0", Colors.blue),
                    _buildButton("=", Colors.green),
                    _buildButton("+", Colors.orange),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
