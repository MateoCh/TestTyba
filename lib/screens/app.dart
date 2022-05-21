import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test_tyba/providers/authProvider.dart';
import 'package:test_tyba/providers/bottomNavigationProvider.dart';
import 'package:test_tyba/screens/authScreen.dart';
import 'package:test_tyba/screens/historyScreen.dart';
import 'package:test_tyba/screens/searchCityScreen.dart';
import 'package:test_tyba/screens/searchResultsScreen.dart';

/**
 * Screen shown aget user succesfully logs in
 */
class App extends StatelessWidget {
  static const String routeName = '/';
  const App({Key? key}) : super(key: key);
  static const List<Widget> _screens = [
    SearchCityScreen(),
    SearchResultsScreen(),
    HistoryScreen()
  ];
  @override
  Widget build(BuildContext context) {
    return Consumer<BottomNavigationProvider>(
      builder: (context, bottomNavigationProvider, _) => Scaffold(
          body: IndexedStack(
            index: bottomNavigationProvider.currentIndex,
            children: _screens,
          ),
          bottomNavigationBar: BottomNavigationBar(
            onTap: (index) {
              if (index < _screens.length) {
                bottomNavigationProvider.currentIndex = index;
              } else {
                Provider.of<AuthProvider>(context, listen: false).logOut();
              }
            },
            currentIndex: bottomNavigationProvider.currentIndex,
            backgroundColor: Theme.of(context).colorScheme.primary,
            type: BottomNavigationBarType.fixed,
            selectedItemColor: Theme.of(context).colorScheme.background,
            unselectedItemColor: Colors.black,
            showUnselectedLabels: true,
            items: [
              BottomNavigationBarItem(
                  icon: Icon(Icons.search), label: 'Buscar'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.restaurant), label: 'Resultados'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.history), label: 'Historial'),
              BottomNavigationBarItem(
                  icon: Icon(
                    Icons.power_settings_new,
                    color: Theme.of(context).colorScheme.error,
                  ),
                  label: 'Cerrar sesión'),
            ],
          )),
    );
  }
}
