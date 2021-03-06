import 'package:cartech_mechanic_app/src/ui/login_screen.dart';
import 'package:cartech_mechanic_app/src/ui/main_screen.dart';
import 'package:cartech_mechanic_app/src/ui/splash_screen.dart';
import 'package:flutter/material.dart';

class CartechMechanicApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cartech',
      theme: ThemeData(
          primarySwatch: Colors.blue, secondaryHeaderColor: Colors.redAccent),
      home: SplashScreen(),
      routes: <String, WidgetBuilder>{
        '/main_screen': (BuildContext context) => new MainScreen(),
        '/login_screen': (BuildContext context) => new LoginScreen(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
