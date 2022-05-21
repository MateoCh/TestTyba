import 'dart:convert';
import 'dart:io';
import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:test_tyba/models/authInfo.dart';
import 'package:test_tyba/models/user.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import "package:latlong/latlong.dart";

/**
 * Provider in charge of all authentication features
 */
class AuthProvider with ChangeNotifier {
  User _user = new User();
  Timer? _logOutTimer;

  String? get token => _user.token;

  Future<bool> tryAutoLogin() async {
    final FlutterSecureStorage storage = new FlutterSecureStorage();
    final String? storedUser = await storage.read(key: 'userInfo');
    if (storedUser == null) {
      return false;
    }
    final Map<String, dynamic> userInfo = json.decode(storedUser);
    _user = User.fromJson(userInfo);
    if (_user.expiryDate!.isBefore(DateTime.now())) {
      return false;
    }
    _autoLogOut();
    notifyListeners();
    return true;
  }

  Future<void> authenticate(AuthInfo authInfo, String urlSection) async {
    final String url =
        'https://identitytoolkit.googleapis.com/v1/accounts:$urlSection?key=AIzaSyDWsP2DArXoKXtOOqc1sQnayeFmerqVyR4';
    try {
      final response =
          await http.post(url, body: json.encode(authInfo.toJson()));
      final Map<String, dynamic> responseData = json.decode(response.body);
      if (responseData['error'] != null) {
        throw HttpException(responseData['error']['message']);
      }
      final FlutterSecureStorage storage = new FlutterSecureStorage();
      _user = User.fromJson(responseData);
      final String userInfo = json.encode(_user.toJson());
      await storage.write(key: 'userInfo', value: userInfo);
      _autoLogOut();
      notifyListeners();
    } catch (err) {
      throw err;
    }
  }

  Future<void> singUp(AuthInfo authInfo) async {
    return authenticate(authInfo, 'signUp');
  }

  Future<void> login(AuthInfo authInfo) async {
    return authenticate(authInfo, 'signInWithPassword');
  }

  Future<void> forgotPassword(AuthInfo authInfo) async {
    final String url =
        'https://identitytoolkit.googleapis.com/v1/accounts:sendOobCode?key=AIzaSyDWsP2DArXoKXtOOqc1sQnayeFmerqVyR4';
    try {
      final response = await http.post(url,
          body: json.encode(
              {'requestType': 'PASSWORD_RESET', 'email': authInfo.email}));
      final Map<String, dynamic> responseData = json.decode(response.body);
      if (responseData['error'] != null) {
        throw HttpException(responseData['error']['message']);
      }
    } catch (err) {
      throw err;
    }
  }

  Future<void> logOut() async {
    _user = new User();
    if (_logOutTimer != null) {
      _logOutTimer!.cancel();
      _logOutTimer = null;
    }
    final FlutterSecureStorage storage = new FlutterSecureStorage();
    await storage.delete(key: 'userInfo');
    notifyListeners();
  }

  void _autoLogOut() {
    if (_logOutTimer != null) {
      _logOutTimer!.cancel();
    }
    _logOutTimer = Timer(
        Duration(
            seconds: _user.expiryDate!.difference(DateTime.now()).inSeconds),
        () => logOut());
  }

  Future<bool> logPosition(LatLng pos) async {
    try {
      await FirebaseDatabase.instance
          .reference()
          .child('${_user.userId}/historial/latlngs')
          .push()
          .set({
        'lat': pos.latitude,
        'lng': pos.longitude,
        'searchDate': DateTime.now().millisecondsSinceEpoch
      });
      notifyListeners();
      return true;
    } catch (err) {
      return false;
    }
  }

  Future<List<LatLng>> getSearchHistory() async {
    List<LatLng> resp = [];
    try {
      DataSnapshot snapshot = await FirebaseDatabase.instance
          .reference()
          .child('${_user.userId}/historial/latlngs')
          .orderByChild('searchDate')
          .once();
      snapshot.value.forEach((key, act) {
        resp.add(LatLng(act['lat'], act['lng']));
      });
      return new List.from(resp.reversed);
    } catch (err) {
      return resp;
    }
  }
}
