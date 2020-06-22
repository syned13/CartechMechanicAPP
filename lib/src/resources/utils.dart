import 'dart:convert';
import 'dart:math';
import 'dart:developer' as developer;

import 'package:cartech_mechanic_app/src/models/mechanic.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Utils {
  static String decodeResponse(String responseBody) {
    var encoded = utf8.encode(responseBody);
    var decoded = utf8.decode(encoded);

    return decoded;
  }

  static Future<bool> isLogged() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    final token = sharedPreferences.getString("TOKEN");

    if (token == null) return false;

    return true;
  }

  static Future<Mechanic> getMechanicLoggedIn() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    Mechanic mechanic = Mechanic();
    mechanic.mechanicId = sharedPreferences.getInt("MECHANIC_ID");
    mechanic.name = sharedPreferences.getString("NAME");
    mechanic.lastName = sharedPreferences.getString("LAST_NAME");
    mechanic.email = sharedPreferences.getString("EMAIL");
    mechanic.nationalId = sharedPreferences.getString("NATIONAL_ID");
    mechanic.bio = sharedPreferences.getString("BIO");
    mechanic.phoneNumber = sharedPreferences.getString("PHONE_NUMBER");

    return mechanic;
  }

  static Future<bool> saveMechanicInfo(Mechanic mechanic) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    sharedPreferences.setInt("MECHANIC_ID", mechanic.mechanicId);
    sharedPreferences.setString("NAME", mechanic.name);
    sharedPreferences.setString("LAST_NAME", mechanic.lastName);
    sharedPreferences.setString("EMAIL", mechanic.email);
    sharedPreferences.setString("NATIONAL_ID", mechanic.nationalId);
    sharedPreferences.setInt("SCORE", mechanic.score);
    sharedPreferences.setString("BIO", mechanic.bio);
    sharedPreferences.setString("PHONE_NUMBER", mechanic.phoneNumber);

    return true;
  }

  static Future<bool> saveToken(String token) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.setString("TOKEN", token);
  }

  static void logOut() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.remove("TOKEN");
    sharedPreferences.remove("FULL_NAME");
    sharedPreferences.remove("PROGRAM");
  }

  static Future<String> getToken() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String returnedToken = sharedPreferences.getString("TOKEN");

    return returnedToken;
  }

  static Future<LatLng> getLocation() async {
    developer.log("hello");
    Position position = await Geolocator()
        .getLastKnownPosition(desiredAccuracy: LocationAccuracy.medium);

    final LatLng loc = LatLng(position.latitude, position.longitude);

    return loc;
  }

  // In kilometers
  static Future<double> getDistanceBetween(double lat1,  lng1, lat2, lng2) async {
    double distance = await Geolocator()
        .distanceBetween(lat1, lng1, lat2, lng2);
//    Distance()
    return distance;
  }

  static double calculateDistance(lat1, lon1, lat2, lon2){
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 - c((lat2 - lat1) * p)/2 +
        c(lat1 * p) * c(lat2 * p) *
            (1 - c((lon2 - lon1) * p))/2;
    return 12742 * asin(sqrt(a));
  }
}
