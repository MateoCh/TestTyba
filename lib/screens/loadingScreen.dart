import 'package:flutter/material.dart';

/**
 * Screen shown while the app checks the secure storage to see if the user is already logged in or not
 */
class LoadingScreen extends StatelessWidget {
  const LoadingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.secondary,
      body: Center(
        child: Text(
          'Cargando...',
          style: TextStyle(fontSize: 30),
        ),
      ),
    );
  }
}
