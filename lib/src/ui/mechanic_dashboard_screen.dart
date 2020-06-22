import 'package:cartech_mechanic_app/src/blocs/main_screen_bloc.dart';
import 'package:cartech_mechanic_app/src/models/service_order.dart';
import 'package:cartech_mechanic_app/src/models/states/main_state.dart';
import 'package:cartech_mechanic_app/src/resources/utils.dart';
import 'package:cartech_mechanic_app/src/ui/shared.dart';
import 'package:cartech_mechanic_app/src/ui/theme_resources.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';

class MechanicDashboardScreen extends StatelessWidget {
  final MainScreenBloc _bloc = MainScreenBloc();

  @override
  Widget build(BuildContext context) {
    _bloc.init();
    return Container(
      child: StreamBuilder<MainState>(
          stream: _bloc.stream,
          builder: (context, snapshot) {
            if (snapshot.data is MainStateLoadingOrders) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }

            if (snapshot.data is MainStateError) {
              MainStateError mainStateError = snapshot.data;

              // This is due to the fact that an alert dialog cannot be shown during widget building
              Future.delayed(
                  Duration.zero,
                  () => _showDialog(
                      "Error", mainStateError.errorMessage, context));
            }

            if(snapshot.data is MainStateDoneLoadingOrders){
              MainStateDoneLoadingOrders state = snapshot.data;
              return Container(
                padding: EdgeInsets.all(20),
                child: SafeArea(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text("Ordenes activas", style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),),
                        SizedBox(height: 10,),
                        ListView(
                          shrinkWrap: true,
                          children: _activeOrderList(state.orders),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }
            return Container();
          }),
    );
  }

  List<Widget> _activeOrderList(List<ServiceOrder> orders){
    List<Widget> cards = List();

    for(int i = 0; i < orders.length; i++){
      cards.add(StreamBuilder<MainState>(
        stream: _bloc.assignOrderStream,
        builder: (context, snapshot) {
          if(snapshot.data is MainStateLoadingAssignOrder){
            return CircularProgressIndicator();
          }

          if(snapshot.data is MainStateAssignOrderError){
            MainStateAssignOrderError mainStateAssignOrderError = snapshot.data;
            Future.delayed(
                Duration.zero,
                    () => _showDialog(
                    "Error", "gbrfhe", context));
          }

          if(snapshot.data is MainStateAssignOrderDone){
            MainStateAssignOrderDone mainStateAssignOrderError = snapshot.data;
            Flushbar flushbar =
            Flushbar(
              flushbarPosition: FlushbarPosition.BOTTOM,
              message: "Orden #${orders[i].serviceOrderId} tomada con extio",
              icon: Icon(
                Icons.check_circle,
                size: 28.0,
                color: Resources.MainColor,
              ),
              backgroundColor: Colors.lightBlue,
              duration: Duration(seconds: 1),
              leftBarIndicatorColor: Resources.MainColor,
            );
            
            Future.delayed(
                Duration.zero,
                    () => flushbar.show(context));
          }

          return Card(
            child: ExpansionTile(
              children: <Widget>[
                Container(
                  alignment: Alignment.topLeft,
                  padding: EdgeInsets.all(5),
                  child: Column(
                    children: <Widget>[
                      RichText(text: TextSpan(
                          text: 'Numero de orden: ',
                          style: TextStyle(color: Colors.black, fontWeight: FontWeight.normal),
                          children: <TextSpan>[
                            TextSpan(text: orders[i].serviceOrderId.toString(), style: TextStyle(fontWeight: FontWeight.w300)),
                          ]
                      ),),
                      SizedBox(height: 5,),
                      RaisedButton(
                        onPressed: (){
                              _bloc.assignOrder(orders[i]);
                        },
                        child: Text("Tomar orden"),
                      )
                    ],
                  ),
                )
              ],
              title: Container(
                padding: EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(orders[i].serviceName, style: TextStyle(fontWeight: FontWeight.normal, fontSize: 18),),
                    SizedBox(height: 5,),
                    RichText(text: TextSpan(
                      text: 'Fecha de creacion: ',
                      style: TextStyle(color: Colors.black, fontWeight: FontWeight.normal),
                      children: <TextSpan>[
                        TextSpan(text: Shared.getDayFromDate(orders[i].createdAt), style: TextStyle(fontWeight: FontWeight.w300))
                      ]
                    ),),
                    SizedBox(height: 5,),
                    Text("Distancia: " + orders[i].distanceTo.toString() + " km")
                  ],
                ),
              ),
            ),
          );
        }
      ))    ;
    }

    return cards;
  }

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
