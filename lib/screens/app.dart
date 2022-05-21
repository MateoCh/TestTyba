import 'package:flutter/material.dart';

/**
 * Main screen of the app after user has logged in
 */
class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('Entré a la app'),
      ),
    );
  }
}
