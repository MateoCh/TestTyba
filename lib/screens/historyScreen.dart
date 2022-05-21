import 'package:flutter/material.dart';

/**
 * Screen that shows the user's search history
 */
class HistoryScreen extends StatelessWidget {
  const HistoryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('Historial'),
      ),
    );
  }
}
