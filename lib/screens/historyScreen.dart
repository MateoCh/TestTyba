import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test_tyba/models/restaurant.dart';
import 'package:test_tyba/providers/authProvider.dart';
import 'package:test_tyba/widgets/previousSearchCard.dart';
import "package:latlong/latlong.dart";

/**
 * Screen that shows the user's search history
 */
class HistoryScreen extends StatelessWidget {
  static const String routeName = '/history';
  const HistoryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Row(
            children: [
              const Text('Historial de busquedas'),
              const Icon(Icons.restaurant)
            ],
          ),
        ),
        backgroundColor: Theme.of(context).colorScheme.secondary,
        body: SafeArea(
            child: Consumer<AuthProvider>(
                builder: (context, authProvider, _) => FutureBuilder(
                    future: authProvider.getSearchHistory(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        List<LatLng> info = snapshot.data! as List<LatLng>;
                        return info.length < 1
                            ? Center(
                                child:
                                    Text('No se encontraron busquedas previas'),
                              )
                            : ListView.builder(
                                itemCount: info.length,
                                itemBuilder: (context, index) =>
                                    PreviousSearchCard(position: info[index]),
                              );
                      } else {
                        return Center(child: CircularProgressIndicator());
                      }
                    }))));
  }
}
