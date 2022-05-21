import "package:latlong/latlong.dart";
import 'package:flutter/material.dart';

/**
 * Class which represents a restaurant
 */
class Restaurant {
  String _name;
  String _address;
  LatLng _position;
  String? _phone;

  Restaurant(
      {required String name,
      required String address,
      required LatLng position,
      String? phone})
      : _name = name,
        _address = address,
        _position = position,
        _phone = phone;

  Restaurant.fromJson(Map<String, dynamic> json)
      : _name = json['poi']['name'],
        _address = json['address']['freeformAddress'],
        _position =
            new LatLng(json['position']['lat'], json['position']['lon']),
        _phone = json['poi']['phone'];

  /**
   * GETTERS
   */
  String get name => _name;

  String get address => _address;

  String get phone => _phone ?? 'N/A';

  LatLng get position => _position;

  /**
   * SETTERS
   */
  void set name(String name) => _name = name;

  void set address(String address) => _address = address;

  void set phone(String phone) => _phone = phone;

  void set position(LatLng position) => _position = position;

  @override
  String toString() {
    return 'name:$_name,address:$_address,phone:$_phone,position:$_position';
  }
}
