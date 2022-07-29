import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../models/mission.dart';
import '../services/database.dart';

void showAlertDialog(BuildContext context) {
  // set up the buttons
  Widget cancelButton = TextButton(
    child: Text("No"),
    onPressed:  () {
      Navigator.of(context).pop();
    },
  );
  Widget continueButton = TextButton(
    child: Text("Yes"),
    onPressed:  () {
      Navigator.of(context).pop();

    },
  );
  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text("Alert!!"),
    content: Text("Would you like to cancel the mission?"),
    actions: [
      cancelButton,
      continueButton,
    ],
  );
  // show the dialog
  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}