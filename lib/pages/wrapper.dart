
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:turtle_ninja/models/credentials.dart';
import 'package:turtle_ninja/pages/loading.dart';
import 'package:turtle_ninja/services/email.dart';

import '../helpers/dialogHelper.dart';
import '../models/myuser.dart';
import '../models/secureStorage.dart';
import '../models/userCredentials.dart';
import '../shared/loader.dart';
import 'authenticate/authenticate.dart';

class Wrapper extends StatefulWidget {

  @override
  State<Wrapper> createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  bool notAuth=false;
  bool registered=false;
  bool biometric=false;
  void togglenotAuth(){
    setState((){
      notAuth= !notAuth;
    });
  }
  void toggleRegistered(){
    setState((){
      registered= !registered;
    });
  }
  void toggleBiometric(){
    setState((){
      biometric=!biometric;
    });
  }

  @override
  Widget build(BuildContext context) {
    final myuser = Provider.of<MyUser?>(context);


    //return either Home() or Authenticate Widget
    if(myuser==null){
      return Authenticate(togglenotAuth: togglenotAuth, toggleRegistered: toggleRegistered,toggleBiometric: toggleBiometric);
    }
    else{

          /// show dialogue for user
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        final SecureStorage secureStorage = SecureStorage();
        late bool notfound=true;
        // String? email = await secureStorage.readSecureData('email');
        // String? password = await secureStorage.readSecureData('password');

        late List<UserCredentials> listofUsersCredentials=[];
        String? stringofUsersCredentials = await secureStorage.readSecureData('credentials');

        if(stringofUsersCredentials != null){
          listofUsersCredentials = UserCredentials.decode(stringofUsersCredentials);
          listofUsersCredentials.forEach((user) {
            if(user.email == Credentials.email && user.password == Credentials.password){
              notfound=false;
            }
          });
        }

        if(registered==true){
          Email.sendEmail(name: "TMNT app", email: "turtleninjaapp@gmail.com", toEmail: Credentials.email, subject: "Welcoming Email", message: "Welcome "+Credentials.email);
        }

        if (notAuth == true && (listofUsersCredentials == [] || notfound )) {
          DialogHelper.fingerPrint(context,"Biometric Authorization","Do you want to login in the future with biometric scan?",notAuth,registered).then((value) {
            Navigator.pop(context);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Loading(notAuth: notAuth, registered: registered,biometric: biometric),
              ),
            );
          }// async work
          );
        }else{
          Navigator.pop(context);
          Navigator.push(
              context,
              MaterialPageRoute(
              builder: (context) => Loading(notAuth: notAuth, registered: registered,biometric:biometric),
        ),
          );
        }
        // Add Your Code here.
      });
      return Loader();
    //  return Text('l');


   //   return Loading(notAuth: notAuth, registered: registered);


    }

  }
}
