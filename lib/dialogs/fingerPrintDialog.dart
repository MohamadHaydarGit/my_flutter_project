import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import 'package:turtle_ninja/models/credentials.dart';
import 'package:turtle_ninja/models/userCredentials.dart';
import '../models/secureStorage.dart';
import '../services/database.dart';
import 'loaderDialog.dart';

class FingerPrintDialog extends StatefulWidget {
  late String title;
  late String description;

  FingerPrintDialog({required this.title, required this.description});

  @override
  State<FingerPrintDialog> createState() => _FingerPrintDialogState();
}

class _FingerPrintDialogState extends State<FingerPrintDialog> {
  @override
  void initState() {
    super.initState();
  }

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
    return Container(
      height: 1300.h,
      decoration: BoxDecoration(
        color: Colors.green[300],
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.all(Radius.circular(24.r)),
      ),
      child: Column(
        children: <Widget>[
          Container(
            width: double.infinity,
            padding: EdgeInsets.only(top: 30.h, bottom: 30.h),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24.r),
                  topRight: Radius.circular(24.r)),
              color: Colors.white,
            ),
            child: Column(
              children: [
                ClipOval(
                  child: Image.asset(
                    'assets/fingerprint.jpg',
                    fit: BoxFit.cover,
                    height: 600.w,
                    width: 600.w,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 50.h,
          ),
          Text(
            widget.title,
            style: TextStyle(
                fontSize: 70.sp,
                color: Colors.white,
                fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 16.h,
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              widget.description,
              style: TextStyle(color: Colors.white),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(
            height: 50.h,
          ),
          Row(
            // mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              TextButton(
                onPressed: () {
                  /// What to do if user pressed no
                  //  Navigator.of(context).pop();
                  Navigator.pop(context);
                },
                child: Text(
                  "No",
                  style: TextStyle(color: Colors.white),
                ),
              ),
              TextButton(
                onPressed: () async {
                  /// What to if user pressed yes
                  late List<UserCredentials> listofUsersCredentials=[];
                  final SecureStorage secureStorage = SecureStorage();
                  String? stringofUsersCredentials = await secureStorage.readSecureData('credentials');
                  if (stringofUsersCredentials != null) {
                     listofUsersCredentials = UserCredentials.decode(stringofUsersCredentials);
                  }
                    listofUsersCredentials.add(UserCredentials(
                        email: Credentials.email,
                        password: Credentials.password));

                    await secureStorage.writeSecureData('credentials', UserCredentials.encode(listofUsersCredentials));

                  Navigator.pop(context);
                },
                child: Text(
                  "Yes",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
