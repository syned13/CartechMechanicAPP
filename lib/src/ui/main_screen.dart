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


  @override
  Widget build(BuildContext context) {
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