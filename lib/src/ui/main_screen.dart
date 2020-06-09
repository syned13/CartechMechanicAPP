import 'package:cartech_mechanic_app/src/resources/push_notification.dart';
import 'package:cartech_mechanic_app/src/resources/utils.dart';
import 'package:cartech_mechanic_app/src/ui/mechanic_dashboard_screen.dart';
import 'package:cartech_mechanic_app/src/ui/profile_screen.dart';
import 'package:cartech_mechanic_app/src/ui/theme_resources.dart';
import 'package:flutter/material.dart';


class MainScreen extends StatefulWidget{


  @override
  State<StatefulWidget> createState() {
    return MainScreenState();
  }
}

class MainScreenState extends State<MainScreen>{

  int _currentIndex = 0;
//  List<String> _appbarTitles = ["Areas", "Reservas", "Perfil"];
  List<Widget> _children = [MechanicDashboardScreen(), ProfileScreen()];
  PushNotificationsManager pushNotificationsManager = PushNotificationsManager();

  @override
  Widget build(BuildContext context) {
    pushNotificationsManager.init(onMessageHandler);

    return Scaffold(
      resizeToAvoidBottomPadding: false,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: onTabTapped,
        backgroundColor: Resources.MainColor,
        items: [
          BottomNavigationBarItem(
            title: Text("Sevicios"),
            icon: Icon(Icons.build),
          ),
          BottomNavigationBarItem(
            title: Text("Perfil"),
            icon: Icon(Icons.account_box),
          )
        ],
      ),

      body: _children[_currentIndex],
    );
  }
  
   void onMessageHandler(Map<String, dynamic> message){
    _showDialog(message['notification']['title'], message['notification']['body']);
  }

  void _showDialog(String message, String body) {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text(message),
          content: new Text(body),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Cerrar"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
  
  void onTabTapped(int index){
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
  }
  
}