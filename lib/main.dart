import 'package:flutter/material.dart'; // Import Flutter Material Design
import 'package:math_expressions/math_expressions.dart'; // Import untuk perhitungan matematika

void main() => runApp(const AppBarApp());

class AppBarApp extends StatelessWidget {
  const AppBarApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(colorSchemeSeed: const Color(0xff6750a4), useMaterial3: true),
      home: const AppBarExample(),
    );
  }
}

class AppBarExample extends StatefulWidget {
  const AppBarExample({super.key});

  @override
  _AppCalculate createState() => _AppCalculate();
}

class _AppCalculate extends State<AppBarExample> {
  final List<String> titles = ['Calculator', 'History', 'Profile']; // Penamaan AppBar
  final List<String> history = []; // Untuk menampung riwayat perhitungan
  final TextEditingController displayController = TextEditingController();
  String expression = "";

  void onButtonPressed(String value) { // Fungsi yang akan dijalankan ketika suatu tombol ditekan
    setState(() {
      if (value == "C") {
        expression = ""; // Menghapus seluruh ekspresi
      } else if (value == "⌫") {
        if (expression.isNotEmpty) {
          expression = expression.substring(0, expression.length - 1); // Menghapus karakter terakhir
        }
      } else if (value == "=") {
        try {
          double result = _evaluateExpression(); // Evaluasi ekspresi matematika
          if (!result.isNaN) {
            history.add("$expression = $result"); // Simpan hasil ke history
            expression = result.toString();
          } else {
            expression = "Error";
          }
        } catch (e) {
          expression = "Error";
        }
      } else {
        // Hindari simbol duplikat
        if (expression.isNotEmpty) {
          String lastChar = expression[expression.length - 1];
          if ("+-*/.".contains(lastChar) && "+-*/.".contains(value)) {
            return; // Tidak menambahkan simbol berulang
          }
        }
        expression += value;
      }
      displayController.text = expression;
    });
  }

  double _evaluateExpression() { // Kompres hasil ketika hasil dari kalkulator itu desimal
    try {
      Parser p = Parser();
      Expression exp = p.parse(expression);
      ContextModel cm = ContextModel();
      return exp.evaluate(EvaluationType.REAL, cm);
    } catch (e) {
      return double.nan;
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('𓆲 Ice Calculator 𓆲'),
          centerTitle: true,
          bottom: TabBar(
            tabs: <Widget>[
              Tab(icon: const Icon(Icons.calculate), text: titles[0]),
              Tab(icon: const Icon(Icons.history), text: titles[1]),
              Tab(icon: const Icon(Icons.account_circle), text: titles[2]),
            ],
          ),
        ),
        body: TabBarView(
          children: <Widget>[
            // Tab Kalkulator
            Center(
              child: Container(
                width: 300,
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.grey.shade200,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: displayController,
                      textAlign: TextAlign.right,
                      style: const TextStyle(fontSize: 24),
                      readOnly: true,
                      decoration: const InputDecoration(border: OutlineInputBorder()),
                    ),
                    const SizedBox(height: 8),
                    GridView.builder(
                      shrinkWrap: true,
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 4,
                        childAspectRatio: 1.2,
                      ),
                      itemCount: 20,
                      itemBuilder: (context, index) {
                        List<String> buttons = [
                          '(', ')', 'C', '⌫',
                          '7', '8', '9', '/',
                          '4', '5', '6', '*',
                          '1', '2', '3', '-',
                          '0', '.', '=', '+'
                        ];
                        return ElevatedButton(
                          onPressed: () => onButtonPressed(buttons[index]),
                          child: Text(
                            buttons[index],
                            style: const TextStyle(fontSize: 20),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
            // History Tab
            ListView.builder(
              itemCount: history.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  title: Text(history[index]),
                );
              },
            ),
            // Tab Profil
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const CircleAvatar(
                    radius: 50,
                    backgroundImage: AssetImage('assets/img/icebearbelanja.jpg'),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Ice Bear',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  const Text('Favorite: Ice Cream', style: TextStyle(fontSize: 18), textAlign: TextAlign.center),
                  const SizedBox(height: 10),
                  const Text('About Me:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
                  const Text(
                    'I like *****, my fav film is *******, *****, and my fav book is *** :)',
                    style: TextStyle(fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  const Text('About App:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
                  const Text(
                    'Ice Bear Calculator adalah sebuah aplikasi kalkulator sederhana yang menghitung dengan operasi matematika dasar. aplikasi ini juga dilengkapi dengan hstory penjumlahan dari kalkulator tersebut, dan profil untuk identitas pengguna. ',
                    style: TextStyle(fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
