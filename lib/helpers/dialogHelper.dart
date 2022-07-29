import 'package:flutter/material.dart';
import 'package:turtle_ninja/models/CharacterData.dart';
import 'package:turtle_ninja/models/mission.dart';
import 'package:turtle_ninja/pages/loading.dart';
import '../dialogs/cancelMissionDialog.dart';
import '../dialogs/fingerPrintDialog.dart';
import '../dialogs/listOfAccountsDialog.dart';
import '../dialogs/noConnectionDialog.dart';
class DialogHelper{
  static cancel(context,CharacterData chData,Mission mission, String title, String description,Function toggleCancelled){
    return showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return WillPopScope( onWillPop:() async => false ,child: CancelMissionDialog(chData: chData, mission: mission, title: title, description: description,toggleCancelled:toggleCancelled));
    });
  }

  static fingerPrint(context,String title, String description, bool notAuth, bool registered){
    return showDialog(
      barrierDismissible:false,
        context: context,
        builder: (BuildContext context) {
          return WillPopScope( onWillPop:() async => false ,child: FingerPrintDialog(title: title, description: description,));
        });

  }

  static listOfAccounts(context,String title,Function toggleBiometric){
    return showDialog(
        //barrierDismissible:false,
        context: context,
        builder: (BuildContext context) {
          return ListOfAccountDialog(title: title,toggleBiometric: toggleBiometric,);
        });
  }

  
  static noInternet(context){
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return NoConnectionDialog();
        });//.then((value) => Navigator.pop(context));
  }
}