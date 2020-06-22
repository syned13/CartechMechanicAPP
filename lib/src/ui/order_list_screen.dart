import 'package:cartech_mechanic_app/src/blocs/order_list_screen_bloc.dart';
import 'package:cartech_mechanic_app/src/models/service_order.dart';
import 'package:cartech_mechanic_app/src/models/states/orders_list_state.dart';
import 'package:cartech_mechanic_app/src/ui/shared.dart';
import 'package:cartech_mechanic_app/src/ui/theme_resources.dart';
import 'package:flutter/material.dart';

class OrderListScreen extends StatelessWidget {
  OrderListScreenBloc _bloc = OrderListScreenBloc();

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text("Ordenes"),
          bottom: TabBar(
            tabs: <Widget>[
              Tab(
                text: "Actuales",
              ),
              Tab(
                text: "Pasadas",
              )
            ],
          ),
        ),
        body: TabBarView(
          children: <Widget>[
            OrderList(_bloc.currentOrdersStream, _bloc.initCurrentOrders),
            OrderList(_bloc.pastOrdersStream, _bloc.initPastOrders),
          ],
        ),
      ),
    );
  }
}

class OrderList extends StatelessWidget {
  final Stream stream;
  Function initFunction;

  OrderList(this.stream, this.initFunction);

  @override
  Widget build(BuildContext context) {
    initFunction();
    return Container(
      child: StreamBuilder<OrdersListState>(
          stream: stream,
          builder: (context, snapshot) {
            if (snapshot.data is OrdersListStateLoading) {
              return Center(child: CircularProgressIndicator());
            }

            if (snapshot.data is OrdersListStateError) {
              OrdersListStateError state = snapshot.data;
              Future.delayed(Duration.zero, () {
                _showDialog(context, "Error", state.errorMessage);
              });
            }

            if(snapshot.data is OrderListStateDone){
              OrderListStateDone state = snapshot.data;
              return _orderList(state.orders, context);
            }
            return Container();
          }),
    );
  }

  Widget _orderList(List<ServiceOrder> orders, BuildContext context) {
    List<Widget> cards = List();

    for (int i = 0; i < orders.length; i++) {
      cards.add(InkWell(
        onTap: () {},
        child: Card(
          color: Resources.MainColor,
          child: Container(
            padding: EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  Shared.getDayFromDate(orders[i].createdAt),
                  style: Resources.WhiteTextStyle,
                ),
                Text(Shared.getHourFromDate(orders[i].createdAt),
                    style: Resources.WhiteTextStyle),
                SizedBox(
                  height: 20,
                ),
                Text(
                  "Estado de la orden: " +
                      Shared.parseOrderStatus(orders[i].status),
                  style: Resources.WhiteTextStyle,
                ),
                Text(orders[i].serviceName, style: Resources.WhiteTextStyle),
                Text("RD\$ 600", style: Resources.WhiteTextStyle),
              ],
            ),
          ),
        ),
      ));
    }

    return ListView(
      children: cards,
    );
  }

  void _showDialog(BuildContext context, String title, String body) {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text(title),
          content: new Text(body),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Close"),
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
