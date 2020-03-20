
import 'dart:convert';

import 'package:cartech_mechanic_app/src/blocs/bloc.dart';
import 'package:cartech_mechanic_app/src/models/login_state.dart';
import 'package:cartech_mechanic_app/src/models/mechanic.dart';
import 'package:cartech_mechanic_app/src/resources/api_client.dart';
import 'package:cartech_mechanic_app/src/resources/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:rxdart/rxdart.dart';

import 'dart:developer' as developer;

class LoginBloc extends Bloc{

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  BehaviorSubject<LoginState> _loginStateController = BehaviorSubject();

  Stream<LoginState> get loginStateStream => _loginStateController.stream.asBroadcastStream();


  void submit() async{
    _loginStateController.sink.add(LoginStateLoading());

    Mechanic mechanic = Mechanic();
    mechanic.email = emailController.text;
    mechanic.password = passwordController.text;

    String responseBody = await ApiClient.postMechanic(mechanic, "/mechanic/login").catchError( (error){
      developer.log("error_while_posting_user: " + error.toString());
      String errorMessage = error.toString();
      if(errorMessage == "missing email" || errorMessage == "missing password"){
        errorMessage = "Datos faltantes";
      }
      else if(errorMessage == "incorrect email or password"){
        errorMessage = "Correo o contraseña incorrecta";
      }
      else{
        errorMessage = "Error inesperado";
      }

      _loginStateController.sink.add( LoginStateError(errorMessage));
      return;
    });

    Map<String, dynamic> responseMap = json.decode(responseBody);

    developer.log(responseMap["mechanic"].toString());
    bool result = await Utils.saveMechanicInfo(Mechanic.fromJson((responseMap["mechanic"])));
    if (!result) {
      _loginStateController.sink.add(LoginStateError("Error inesperado"));
      return;
    }

    result = await Utils.saveToken(responseMap["token"].toString());

    if(!result){
      _loginStateController.sink.add(LoginStateError("Error inesperado"));
      return;
    }

    _loginStateController.sink.add(LoginStateReady());
  }

  @override
  void dispose() {
    _loginStateController.close();
  }
}