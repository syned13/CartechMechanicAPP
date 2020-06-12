import 'package:cartech_mechanic_app/src/blocs/main_screen_bloc.dart';
import 'package:cartech_mechanic_app/src/models/states/main_state.dart';
import 'package:cartech_mechanic_app/src/ui/components/alert_dialog.dart';
import 'package:flutter/material.dart';


class MechanicDashboardScreen extends StatelessWidget{
  MainScreenBloc _bloc = MainScreenBloc();

  @override
  Widget build(BuildContext context) {
    _bloc.init();
    // TODO: implement build
    return Container(
      child: StreamBuilder<MainState>(
        stream: _bloc.stream,
        builder: (context, snapshot) {
          if(snapshot.data is MainStateLoadingOrders){
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          if(snapshot.data is MainStateError){
            MainStateError mainStateError = snapshot.data;
//            WidgetsBinding.instance.addPostFrameCallback( (_) => widget._showDialog(context));
            Future.delayed(Duration.zero, () => _showDialog("Error", mainStateError.errorMessage, context));
            print(mainStateError.errorMessage);
//            _showDialog("Ha ocurrido un error", mainStateError.errorMessage, context);
          }

          return Center(
            child: Text("Hello"),
          );
        }
      ),
    );
  }

//  void _showDialog(String title, String message, BuildContext context) {
//    BlurryDialog blurryDialog = BlurryDialog(title, message);
//
//    showDialog(context: context, builder: (BuildContext context){
//      return blurryDialog;
//    });
//  }

  void _showDialog(String message, String body, context) {
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
}