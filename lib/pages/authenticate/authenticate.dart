import 'package:flutter/material.dart';
import 'package:turtle_ninja/pages/authenticate/register.dart';
import 'package:turtle_ninja/pages/authenticate/sign_in.dart';


class Authenticate extends StatefulWidget {
  final Function togglenotAuth;
  final Function toggleRegistered;
  late Function toggleBiometric;
  Authenticate({required this.togglenotAuth,required this.toggleRegistered,required this.toggleBiometric});

  @override
  State<Authenticate> createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {

  bool showSignIn = true;
  void toggleView(){
    setState((){
      showSignIn= !showSignIn;
    });
  }
  @override
  Widget build(BuildContext context) {

    if(showSignIn) {
      return SignIn(toggleView: toggleView, togglenotAuth: widget.togglenotAuth, toggleBiometric: widget.toggleBiometric);
    }
    else{
      return Register(toggleView: toggleView, toggleRegistered: widget.toggleRegistered);
    }
  }
}
