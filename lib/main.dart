import 'package:flutter/material.dart';

void main() {
  runApp(CalculatorApp());
}

class CalculatorApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Enhanced Calculator',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
        scaffoldBackgroundColor: Colors.grey[100],
      ),
      home: CalculatorScreen(),
    );
  }
}

class CalculatorScreen extends StatefulWidget {
  @override
  _CalculatorScreenState createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  String _expression = '';
  String _result = '';

  final List<String> _operators = ['+', '-', '*', '/', '×', '÷'];

  void _onPressed(String value) {
    setState(() {
      if (value == 'C') {
        _expression = '';
        _result = '';
      } else if (value == '⌫') {
        if (_expression.isNotEmpty) {
          _expression = _expression.substring(0, _expression.length - 1);
        }
      } else if (value == '=') {
        _calculateResult();
      } else {
        // Prevent multiple operators in a row
        if (_operators.contains(value) &&
            _expression.isNotEmpty &&
            _operators.contains(_expression[_expression.length - 1])) {
          _expression =
              _expression.substring(0, _expression.length - 1) + value;
        } else {
          _expression += value;
        }
      }
    });
  }

  void _calculateResult() {
    try {
      String finalExp =
      _expression.replaceAll('×', '*').replaceAll('÷', '/');
      if (finalExp.contains(RegExp(r'[^\d\.\+\-\*/]'))) throw Exception();
      double eval = _evaluateExpression(finalExp);
      _result = eval.toStringAsFixed(6).replaceAll(RegExp(r'\.?0+$'), '');
    } catch (e) {
      _result = 'Invalid Expression';
    }
  }

  double _evaluateExpression(String expr) {
    // NOTE: This is a simplified parser; for more complex logic, use a math parser
    final tokens = expr.split(RegExp(r'([\+\-\*/])')).map((e) => e.trim()).toList();
    final ops = RegExp(r'[\+\-\*/]');
    final matches = ops.allMatches(expr).map((e) => e.group(0)!).toList();

    double result = double.parse(tokens[0]);

    for (int i = 0; i < matches.length; i++) {
      String op = matches[i];
      double num = double.parse(tokens[i + 1]);

      if (op == '+') result += num;
      if (op == '-') result -= num;
      if (op == '*') result *= num;
      if (op == '/') result /= num;
    }

    return result;
  }

  Widget _buildButton(String value, {Color color = Colors.black}) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(6.0),
        child: ElevatedButton(
          onPressed: () => _onPressed(value),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 22),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 5,
          ),
          child: Text(
            value,
            style: TextStyle(fontSize: 26, color: color, fontWeight: FontWeight.w600),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          width: 420,
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              Expanded(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
                  alignment: Alignment.bottomRight,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 8)],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        _expression,
                        style: TextStyle(fontSize: 30, color: Colors.black45),
                      ),
                      SizedBox(height: 10),
                      Text(
                        _result,
                        style: TextStyle(fontSize: 42, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),
              Column(
                children: [
                  Row(children: [
                    _buildButton('7'),
                    _buildButton('8'),
                    _buildButton('9'),
                    _buildButton('÷', color: Colors.blue),
                  ]),
                  Row(children: [
                    _buildButton('4'),
                    _buildButton('5'),
                    _buildButton('6'),
                    _buildButton('×', color: Colors.blue),
                  ]),
                  Row(children: [
                    _buildButton('1'),
                    _buildButton('2'),
                    _buildButton('3'),
                    _buildButton('-', color: Colors.blue),
                  ]),
                  Row(children: [
                    _buildButton('0'),
                    _buildButton('.', color: Colors.black),
                    _buildButton('⌫', color: Colors.orange),
                    _buildButton('+', color: Colors.blue),
                  ]),
                  Row(children: [
                    _buildButton('C', color: Colors.red),
                    _buildButton('=', color: Colors.green),
                  ]),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
