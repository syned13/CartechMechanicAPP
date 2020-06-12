import 'dart:convert';

import 'package:cartech_mechanic_app/src/models/service_order.dart';
import 'package:cartech_mechanic_app/src/models/states/main_state.dart';
import 'package:cartech_mechanic_app/src/resources/api_client.dart';
import 'package:cartech_mechanic_app/src/resources/utils.dart';
import 'package:rxdart/rxdart.dart';

import 'bloc.dart';

class MainScreenBloc extends Bloc {
  BehaviorSubject<MainState> _controller = BehaviorSubject<MainState>();

  Stream<MainState> get stream => _controller.stream.asBroadcastStream();

  void init() async {
    _controller.sink.add(MainStateLoadingOrders());

    String token = await Utils.getToken();

    String response;
    List<ServiceOrder> orders;
    try {
      response = await ApiClient.get(token, "/order?status=pending");
      orders = parseServiceOrders(response);
    } catch (Exception) {
      _controller.sink.add(MainStateError(Exception.toString()));
      return;
    }

    _controller.sink.add(MainStateDoneLoadingOrders(orders));
  }

  List<ServiceOrder> parseServiceOrders(String response) {
    List<dynamic> responseMaps = jsonDecode(response);
    List<ServiceOrder> serviceOrders = List();

    for (int i = 0; i < responseMaps.length; i++) {
      print(responseMaps[i]);

      serviceOrders.add(ServiceOrder.fromJson(responseMaps[i]));
    }

    return serviceOrders;
  }

  @override
  void dispose() {
    _controller.close();
  }
}
