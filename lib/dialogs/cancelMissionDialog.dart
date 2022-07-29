import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import 'package:turtle_ninja/models/CharacterData.dart';
import '../connection/connectionStatusSingleton.dart';
import '../models/mission.dart';
import '../services/database.dart';
import 'loaderDialog.dart';

class CancelMissionDialog extends StatefulWidget {
  late CharacterData chData;
  late Mission mission;
  late String title;
  late String description;
  late Function toggleCancelled;

  CancelMissionDialog(
      {required this.chData,
      required this.mission,
      required this.title,
      required this.description,
      required this.toggleCancelled,
      });

  @override
  State<CancelMissionDialog> createState() => _CancelMissionDialogState();
}

class _CancelMissionDialogState extends State<CancelMissionDialog> {
  late StreamSubscription _connectionChangeStream;


  bool isTimeout = false;

  void toggleisTimeout(){
    setState((){
      isTimeout=!isTimeout;
    });
  }
  @override
  void initState(){
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
                  child: Image.network(
                    widget.chData.imageUrl,
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
                  Navigator.of(context).pop();
                },
                child: Text(
                  "No",
                  style: TextStyle(color: Colors.white),
                ),
              ),
              TextButton(
                onPressed: () async {
                    widget.toggleCancelled();
                    await GetIt.I.get<DataBaseService>().missionCancel(widget.mission, context,toggleisTimeout,widget.chData);
                    if(!isTimeout) {
                     // showLoaderDialog(context);
                      await Future.delayed(const Duration(seconds: 2));

                      Navigator.pop(context);
                      Navigator.pop(context);
                    }
                    isTimeout=false;

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
