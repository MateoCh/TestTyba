import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:test_tyba/widgets/map.dart';
import "package:latlong/latlong.dart";
import 'package:test_tyba/providers/authProvider.dart';
import 'package:test_tyba/providers/bottomNavigationProvider.dart';
import 'package:test_tyba/providers/restaurantsProvider.dart';
import 'package:provider/provider.dart';

/**
 * Widget that contains the summary of each of the users' previous searches
 */
class PreviousSearchCard extends StatelessWidget {
  LatLng position;
  PreviousSearchCard({Key? key, required this.position}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      child: Card(
        child: Column(
          children: [
            Expanded(
                flex: 5,
                child: MyMap(
                  currentPos: position,
                  fn: (_) {},
                  markerPos: position,
                  zoom: 14.0,
                  iconSize: 45,
                )),
            Expanded(
                child: CupertinoButton(
                    child: Text('Buscar nuevamente'),
                    onPressed: () async {
                      try {
                        await Provider.of<RestaurantsProvider>(context,
                                listen: false)
                            .setPosition(position);
                        await Provider.of<AuthProvider>(context, listen: false)
                            .logPosition(position);
                        Provider.of<BottomNavigationProvider>(context,
                                listen: false)
                            .currentIndex = 1;
                      } catch (error) {
                        _showError('Intenta nuevamente más tarde', context);
                      }
                    })),
          ],
        ),
      ),
    );
  }

  void _showError(String message, BuildContext context) {
    showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
              title: Text('Ocurrió un error'),
              content: Text(message),
              actions: <Widget>[
                ElevatedButton(
                    onPressed: () => Navigator.of(ctx).pop(), child: Text('Ok'))
              ],
            ));
  }
}
