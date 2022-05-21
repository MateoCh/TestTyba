import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test_tyba/providers/authProvider.dart';
import 'package:test_tyba/providers/bottomNavigationProvider.dart';
import 'package:test_tyba/providers/restaurantsProvider.dart';
import 'package:test_tyba/screens/authScreen.dart';
import 'package:test_tyba/screens/loadingScreen.dart';
import 'screens/app.dart';
import 'themes/mainColorScheme.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (ctx) => AuthProvider()),
        ChangeNotifierProvider(create: (ctx) => RestaurantsProvider()),
        ChangeNotifierProvider(create: (ctx) => BottomNavigationProvider()),
      ],
      child: Consumer<AuthProvider>(
        builder: (context, authProvider, _) => MaterialApp(
          title: 'Test Tyba',
          theme: ThemeData(
              fontFamily: 'Roboto',
              colorScheme: mainColorScheme,
              appBarTheme: mainAppBarTheme),
          home: authProvider.token == null
              ? FutureBuilder(
                  future: authProvider.tryAutoLogin(),
                  builder: (context, snapshot) =>
                      snapshot.connectionState == ConnectionState.waiting
                          ? LoadingScreen()
                          : AuthScreen(),
                )
              : App(),
          routes: {
            AuthScreen.routeName: (context) => AuthScreen(),
          },
        ),
      ),
    );
  }
}
