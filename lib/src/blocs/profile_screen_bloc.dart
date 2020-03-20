
import 'package:cartech_mechanic_app/src/models/mechanic.dart';
import 'package:cartech_mechanic_app/src/resources/utils.dart';
import 'package:rxdart/rxdart.dart';

import 'bloc.dart';
import 'dart:developer' as developer;

class ProfileScreenBloc extends Bloc{

  BehaviorSubject<Mechanic> _userController = BehaviorSubject();

  Stream<Mechanic> get userStream => _userController.stream.asBroadcastStream();

  void getMechanic() async {
    Mechanic mechanic = await Utils.getMechanicLoggedIn();
    developer.log(mechanic.toString());
    _userController.sink.add(mechanic);

  }
  @override
  void dispose() {

  }

}