import 'dart:convert';

import 'package:cartech_mechanic_app/src/models/mechanic.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'dart:developer' as developer;

class Utils{


  static void saveLoginInfo(Map<String, dynamic> userInfo) async{
//    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
//    sharedPreferences.setString("TOKEN", userInfo["token"]);
//
//    User user = User.fromJson(userInfo);
//    sharedPreferences.setString("NAME", user.name);
//    sharedPreferences.setString("LAST_NAME", user.name);
//    sharedPreferences.setString("EMAIL", user.email);
//    sharedPreferences.setString("PHONE_NUMBER", user.phoneNumber);

  }

  static String decodeResponse(String responseBody){
    var encoded = utf8.encode(responseBody);
    var decoded = utf8.decode(encoded);

    return decoded;
  }

  static Future<bool>  isLogged() async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    final token = sharedPreferences.getString("TOKEN");

    if (token == null)
      return false;

    return true;
  }

  static Future<Mechanic> getMechanicLoggedIn() async{
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

  static Future<bool> saveMechanicInfo(Mechanic mechanic) async{
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

  static Future<bool> saveToken(String token) async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.setString("TOKEN", token);
  }

  static void logOut() async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.remove("TOKEN");
    sharedPreferences.remove("FULL_NAME");
    sharedPreferences.remove("PROGRAM");
  }

  static Future<String> getToken() async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String returnedToken =  sharedPreferences.getString("TOKEN");

    return returnedToken;

  }

}