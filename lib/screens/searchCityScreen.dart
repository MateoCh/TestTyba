import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:test_tyba/widgets/searchMap.dart';
import 'package:test_tyba/widgets/map.dart';

/**
 * Screen containing a map which allows the user to search by coordinates
 */
class SearchCityScreen extends StatelessWidget {
  static const String routeName = '/searchCity';
  const SearchCityScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [const Text('Buscar'), const Icon(Icons.restaurant)],
        ),
      ),
      backgroundColor: Theme.of(context).colorScheme.secondary,
      body: SafeArea(
          child: Center(
        child: Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          margin: EdgeInsets.all(15),
          elevation: 10,
          color: Theme.of(context).colorScheme.background,
          child: SearchMap(),
        ),
      )),
    );
  }
}
