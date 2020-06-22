import 'dart:convert';

import 'package:cartech_mechanic_app/src/models/service_order.dart';
import 'package:cartech_mechanic_app/src/models/states/orders_list_state.dart';
import 'package:cartech_mechanic_app/src/resources/api_client.dart';
import 'package:cartech_mechanic_app/src/resources/utils.dart';
import 'package:rxdart/rxdart.dart';

import 'bloc.dart';


class OrderListScreenBloc implements Bloc {
  BehaviorSubject<OrdersListState> _currentOrdersController = BehaviorSubject();
  BehaviorSubject<OrdersListState> _pasOrdersController = BehaviorSubject();

  Stream<OrdersListState> get currentOrdersStream =>
      _currentOrdersController.stream.asBroadcastStream();

  Stream<OrdersListState> get pastOrdersStream =>
      _pasOrdersController.stream.asBroadcastStream();

  void initCurrentOrders() async {
    _currentOrdersController.sink.add(OrdersListStateLoading());
    List<ServiceOrder> orders;
    try{
      orders = await getOrderList("/order?status=in_progress");
    }
    catch(Exception){
      // TODO: parse error
     _currentOrdersController.sink.add(OrdersListStateError(Exception.toString()));
     return;
    }

    _currentOrdersController.sink.add(OrderListStateDone(orders));
  }

  void initPastOrders() async {
    _pasOrdersController.sink.add(OrdersListStateLoading());
    List<ServiceOrder> orders;
    try{
      orders = await getOrderList("/order?status=finished");
    }
    catch(Exception){
      // TODO: parse error
      _pasOrdersController.sink.add(OrdersListStateError(Exception.toString()));
      return;
    }

    _pasOrdersController.sink.add(OrderListStateDone(orders));
  }

  Future<List<ServiceOrder>> getOrderList(String path) async {
    String token = await Utils.getToken();
    String response = await ApiClient.get(token, path);

    List<dynamic> ordersMaps = json.decode(response);
    List<ServiceOrder> orders = ordersMaps.map( (order) => ServiceOrder.fromJson(order)).toList();

    return orders;
  }

  @override
  void dispose() {
    _currentOrdersController.close();
    _pasOrdersController.close();
  }
}