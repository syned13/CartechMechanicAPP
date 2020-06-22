import 'dart:convert';
import 'dart:developer' as developer;

import 'package:cartech_mechanic_app/src/models/mechanic.dart';
import 'package:cartech_mechanic_app/src/models/service_order.dart';
import 'package:cartech_mechanic_app/src/models/states/main_state.dart';
import 'package:cartech_mechanic_app/src/resources/api_client.dart';
import 'package:cartech_mechanic_app/src/resources/utils.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:rxdart/rxdart.dart';

import 'bloc.dart';

class MainScreenBloc extends Bloc {
  BehaviorSubject<MainState> _controller = BehaviorSubject<MainState>();
  BehaviorSubject<MainState> _assignOrderController = BehaviorSubject<MainState>();


  Stream<MainState> get stream => _controller.stream.asBroadcastStream();

  Stream<MainState> get assignOrderStream =>
      _assignOrderController.stream.asBroadcastStream();

  void init() async {
    _controller.sink.add(MainStateLoadingOrders());

    String token = await Utils.getToken();

    String response;
    List<ServiceOrder> orders;
    try {
      response = await ApiClient.get(token, "/order?status=pending");
      orders = await parseServiceOrders(response);
    } catch (Exception) {
      _controller.sink.add(MainStateError(Exception.toString()));
      return;
    }

    _controller.sink.add(MainStateDoneLoadingOrders(orders));
  }

  void setDistances(List<ServiceOrder> orders) async {}

  Future<List<ServiceOrder>> parseServiceOrders(String response) async {
    List<dynamic> responseMaps = jsonDecode(response);
    List<ServiceOrder> orders = List();

    for (int i = 0; i < responseMaps.length; i++) {
      orders.add(ServiceOrder.fromJson(responseMaps[i]));
    }

    LatLng position = await Utils.getLocation();

    for (int i = 0; i < orders.length; i++) {
      print(orders[i].distanceTo.toString());
      orders[i].distanceTo = await Utils.getDistanceBetween(
          position.latitude, position.longitude, orders[i].lat, orders[i].lng);
    }

    return orders;
  }


  void assignOrder(ServiceOrder order) async {
    _assignOrderController.sink.add(MainStateLoadingAssignOrder());

    String token = await Utils.getToken();
    Mechanic mechanic = await Utils.getMechanicLoggedIn();

    String path = "/order/${order.serviceOrderId}/mechanic?mechanic_id=${mechanic
        .mechanicId}";

    String response;
    try {
      response = await ApiClient.put(token, path);

    } catch (Exception) {
        developer.log(Exception);
        _assignOrderController.sink.add(MainStateAssignOrderError(Exception.toString()));

        return;
    }

    _assignOrderController.sink.add(MainStateAssignOrderDone());
  }

  @override
  void dispose() {
    _controller.close();
    _assignOrderController.close();
  }
}
