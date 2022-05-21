import 'dart:convert';
import 'dart:io';
import "package:latlong/latlong.dart";

import 'package:flutter/cupertino.dart';

import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:test_tyba/models/authInfo.dart';
import 'package:test_tyba/models/restaurant.dart';

/**
 * Provider in charge of getting and storing the restaurants near the user.
 */
class RestaurantsProvider with ChangeNotifier {
  static const String baseURL = 'api.tomtom.com';
  static const num versionNumber = 2;
  static const String ext = '.json';
  static const String apiKey = "ZwVNqisTHH8Aw7lcgVgNmWkJNCOD4ahd";
  static const String query = "restaurants";
  int restaurantsPerPage = 10;
  int _page = 1;
  LatLng? _position;
  List<Restaurant> _restaurants = [];
  List<Restaurant> _restaurantsNext = [];

  Future<void> setPosition(LatLng position) async {
    _position = position;
    _page = 1;
    _restaurants = [];
    _restaurantsNext = [];
    notifyListeners();
    await updateRestaurants();
  }

  Future<void> updateRestaurants() async {
    await _searchRestaurants();
    await _searchRestaurantsNext();
    notifyListeners();
  }

  Future<void> _searchRestaurants() async {
    int ofs = (_page - 1) * restaurantsPerPage;
    String url =
        '''https://$baseURL/search/$versionNumber/categorySearch/$query.$ext?key=$apiKey&limit=$restaurantsPerPage&ofs=$ofs&lat=${_position!.latitude}&lon=${_position!.longitude}''';
    final respRef = await http.get(url);
    final resp = json.decode(respRef.body);
    _restaurants = [];
    resp['results']
        .forEach((act) => _restaurants.add(Restaurant.fromJson(act)));
  }

  Future<void> _searchRestaurantsNext() async {
    int ofs = (_page) * restaurantsPerPage;
    String url =
        '''https://$baseURL/search/$versionNumber/categorySearch/$query.$ext?key=$apiKey&limit=$restaurantsPerPage&ofs=$ofs&lat=${_position!.latitude}&lon=${_position!.longitude}''';
    final respRef = await http.get(url);
    final resp = json.decode(respRef.body);
    _restaurantsNext = [];
    resp['results']
        .forEach((act) => _restaurantsNext.add(Restaurant.fromJson(act)));
  }

  /**
   * GETTERS
   */
  List<Restaurant> get restaurants => [..._restaurants];
  List<Restaurant> get restaurantsNext => [..._restaurantsNext];
  int get page => _page;

  /**
   * SETTERS
   */
  void set restaurants(List<Restaurant> restaurants) =>
      _restaurants = restaurants;
  void decreasePage() {
    _page--;
    updateRestaurants();
  }

  void increasePage() {
    _page++;
    updateRestaurants();
  }
}
