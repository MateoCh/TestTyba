import 'package:flutter/material.dart';
import 'package:test_tyba/models/restaurant.dart';
import 'package:test_tyba/widgets/map.dart';

/**
 * Card wich shows the relevant information of a restaurant (summary)
 */
class RestaurantOverview extends StatelessWidget {
  RestaurantOverview({Key? key, required Restaurant restaurant})
      : _restaurant = restaurant,
        super(key: key);
  Restaurant _restaurant;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      child: Card(
        child: Column(
          children: [
            Expanded(
              flex: 1,
              child: Container(
                width: double.infinity,
                color: Theme.of(context).colorScheme.primary,
                child: Text(
                  _restaurant.name,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20.0,
                      color: Theme.of(context).colorScheme.background),
                ),
              ),
            ),
            Expanded(
                flex: 5,
                child: MyMap(
                  currentPos: _restaurant.position,
                  fn: (_) {},
                  markerPos: _restaurant.position,
                  zoom: 18.0,
                  iconSize: 45,
                )),
            Expanded(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            'Dirección: ',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text('${_restaurant.address.split(',')[0]}')
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            'Telefono: ',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text('${_restaurant.phone}')
                        ],
                      ),
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
