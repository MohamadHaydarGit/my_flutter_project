import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import 'package:turtle_ninja/models/CharacterData.dart';
import '../connection/connectionStatusSingleton.dart';
import '../models/mission.dart';
import '../services/database.dart';

class NoConnectionDialog extends StatefulWidget {
  @override
  State<NoConnectionDialog> createState() => _NoConnectionDialogState();
}

class _NoConnectionDialogState extends State<NoConnectionDialog> {

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      child: _buildChild(context),
    );
  }

  _buildChild(BuildContext context) {
    Widget continueButton = TextButton(
      child: Text("OK"),
      onPressed:  () {
        Navigator.of(context).pop();

      },
    );
    return AlertDialog(
      title: Text("Alert!!"),
      content: Text("No internet connection, Reconnect and try again"),
      actions: [
        continueButton,
      ],
    );
  }
}
