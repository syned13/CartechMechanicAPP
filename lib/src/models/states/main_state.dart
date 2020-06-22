import 'package:cartech_mechanic_app/src/models/service_order.dart';

class MainState {}

class MainStateLoadingOrders extends MainState {}

class MainStateError extends MainState {
  String errorMessage;

  MainStateError(this.errorMessage);
}

class MainStateDoneLoadingOrders extends MainState {
  List<ServiceOrder> orders;

  MainStateDoneLoadingOrders(this.orders);
}

class MainStateLoadingAssignOrder extends MainState{}

class MainStateAssignOrderDone extends MainState{}

class MainStateAssignOrderError extends MainState{
  String errorMessage;

  MainStateAssignOrderError(errorMessage);
}
