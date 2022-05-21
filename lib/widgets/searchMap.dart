import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import "package:latlong/latlong.dart";
import 'package:test_tyba/providers/authProvider.dart';
import 'package:test_tyba/providers/bottomNavigationProvider.dart';
import 'package:test_tyba/providers/restaurantsProvider.dart';
import 'package:test_tyba/widgets/map.dart';
import 'package:provider/provider.dart';
import 'package:geolocator/geolocator.dart';

/**
 * Map designed for the search screen
 */
class SearchMap extends StatefulWidget {
  SearchMap({Key? key}) : super(key: key);

  @override
  State<SearchMap> createState() => _SearchMapState();
}

class _SearchMapState extends State<SearchMap> {
  LatLng? currentPos;
  LatLng? markerPos;

  @override
  void initState() {
    super.initState();
    _getUserLocation();
  }

  _getUserLocation() async {
    LocationPermission geolocationStatus = await Geolocator.checkPermission();
    bool couldLocate = await _checkAndRetrieveLocation(geolocationStatus);
    if (!couldLocate) {
      geolocationStatus = await Geolocator.requestPermission();
      couldLocate = await _checkAndRetrieveLocation(geolocationStatus);
      if (!couldLocate) {
        setState(() {
          currentPos = new LatLng(4.60971, -74.08175);
        });
      }
    }
  }

  Future<bool> _checkAndRetrieveLocation(
      LocationPermission geolocationStatus) async {
    if (geolocationStatus == LocationPermission.always ||
        geolocationStatus == LocationPermission.whileInUse) {
      final Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.best);
      setState(() {
        currentPos = new LatLng(position.latitude, position.longitude);
      });
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          flex: 5,
          child: ConstrainedBox(
            constraints: BoxConstraints(maxHeight: 400),
            child: Card(
                clipBehavior: Clip.hardEdge,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30)),
                margin: EdgeInsets.all(10),
                color: Theme.of(context).colorScheme.background,
                child: currentPos == null
                    ? Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.width,
                        child: CircularProgressIndicator())
                    : MyMap(
                        currentPos: currentPos!,
                        markerPos: markerPos,
                        fn: (point) {
                          setState(() {
                            markerPos = point;
                          });
                        },
                      )),
          ),
        ),
        Expanded(
            flex: 2,
            child: CupertinoButton(
                child: Text('Buscar'),
                onPressed: markerPos == null
                    ? null
                    : () async {
                        try {
                          await Provider.of<RestaurantsProvider>(context,
                                  listen: false)
                              .setPosition(markerPos!);
                          Provider.of<BottomNavigationProvider>(context,
                                  listen: false)
                              .currentIndex = 1;
                        } catch (error) {
                          _showError('Intenta nuevamente más tarde');
                        }
                      })),
      ],
    );
  }

  void _showError(String message) {
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
