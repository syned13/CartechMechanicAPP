import 'package:cartech_mechanic_app/src/models/mechanic.dart';
import 'package:cartech_mechanic_app/src/models/sign_up_state.dart';
import 'package:cartech_mechanic_app/src/resources/api_client.dart';
import 'package:flutter/cupertino.dart';
import 'package:rxdart/rxdart.dart';
import 'dart:io';

import 'bloc.dart';


class SignUpBloc extends Bloc {

  TextEditingController nameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  BehaviorSubject<SignUpState> _signUpStateController = BehaviorSubject();

  Stream<SignUpState> get signUpStateStream => _signUpStateController.stream.asBroadcastStream();

  String errorMessage = "";

  void signUp() async {
    if(nameController.text == "" || lastNameController.text == "" || emailController.text == "" || phoneNumberController.text == "" || passwordController.text == ""){
      _signUpStateController.sink.add(SignUpStateError("Datos faltantes"));
      return;
    }


    Mechanic mechanic = Mechanic();
    mechanic.name = nameController.text;
    mechanic.lastName = lastNameController.text;
    mechanic.email = emailController.text;
    mechanic.phoneNumber = phoneNumberController.text;
    mechanic.password = phoneNumberController.text;

    _signUpStateController.sink.add(new SignUpStateLoading());

    String response = await ApiClient.postMechanic(mechanic, "/mechanic/signup").catchError( (error) {
      String errorMessage = error.toString();

      if(errorMessage == "email must be unique") {
        errorMessage = "Correo electronico debe ser unico";
      }
      else{
        errorMessage = "Ha ocurrido un error";
      }

      _signUpStateController.sink.add(SignUpStateError(errorMessage));
      return;
    });

    _signUpStateController.sink.add(new SignUpStateDone());
  }


  @override
  void dispose() {
    _signUpStateController.close();
  }
}