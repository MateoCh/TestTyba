import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test_tyba/providers/restaurantsProvider.dart';
import 'package:test_tyba/widgets/restaurantOverview.dart';

/**
 * Screen that shows the search results
 */
class SearchResultsScreen extends StatelessWidget {
  static const String routeName = '/searchResults';
  const SearchResultsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [const Text('Resultados'), const Icon(Icons.restaurant)],
        ),
      ),
      backgroundColor: Theme.of(context).colorScheme.secondary,
      body: Center(
        child: SafeArea(
            child: Column(
          children: [
            Expanded(
              flex: 15,
              child: Consumer<RestaurantsProvider>(
                  builder: (context, restaurantsProvider, _) =>
                      restaurantsProvider.restaurants.length == 0
                          ? Center(
                              child: Text(
                                  'No hay restaurantes para mostrar, intenta buscar nuevamente'),
                            )
                          : ListView.builder(
                              itemCount: restaurantsProvider.restaurants.length,
                              itemBuilder: (context, index) =>
                                  RestaurantOverview(
                                      restaurant: restaurantsProvider
                                          .restaurants[index]),
                            )),
            ),
            Expanded(
                flex: 1,
                child: Container(
                  width: double.infinity,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        flex: 1,
                        child: Consumer<RestaurantsProvider>(
                          builder: (context, restaurantsProvider, _) =>
                              CupertinoButton(
                                  color: Theme.of(context).colorScheme.primary,
                                  // borderRadius: BorderRadius.circular(30),
                                  child:
                                      Icon(Icons.keyboard_arrow_left_outlined),
                                  onPressed: restaurantsProvider.page == 1
                                      ? null
                                      : restaurantsProvider.decreasePage),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Consumer<RestaurantsProvider>(
                          builder: (context, restaurantsProvider, _) =>
                              CupertinoButton(
                                  color: Theme.of(context).colorScheme.primary,
                                  // borderRadius: BorderRadius.circular(30),
                                  child: Icon(Icons.chevron_right_outlined),
                                  onPressed: restaurantsProvider
                                              .restaurantsNext.length ==
                                          0
                                      ? null
                                      : restaurantsProvider.increasePage),
                        ),
                      ),
                    ],
                  ),
                )),
          ],
        )),
      ),
    );
  }
}
