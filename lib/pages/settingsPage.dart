import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import '../models/enums.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../models/Character.dart';
import 'package:just_audio/just_audio.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/myuser.dart';
import '../services/database.dart';

class Settings extends StatefulWidget {
  late Map data;
  late AudioPlayer player;
  Settings({required this.data,required this.player});
  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  List<Option> options = Option.values; // Option 2
  late Option selectedOption=widget.data['selectedOption']; // Option 2


  List<Shape> shapes = Shape.values;
  late Shape selectedShape= widget.data['selectedShape'];

  List<Sort> sorts = Sort.values;
  late Sort selectedSort=widget.data['sort'];

  Map settings = {};

  late final prefs;

  @override
  void initState(){
    settings['selectedOption'] = widget.data['selectedOption'];
    settings['selectedShape'] = widget.data['selectedShape'];
    settings['selectedVolume'] = widget.data['selectedVolume'];
    settings['sort'] = widget.data['sort'];
    widget.player.setVolume(widget.data['selectedVolume']);
  }



  @override
  Widget build(BuildContext context) {

    return Scaffold(
        appBar: AppBar(
          title: Text("Settings"),
          centerTitle: true,
          backgroundColor: Colors.green[800],
          elevation: 0.0.h,
        ),
        body: WillPopScope(
          onWillPop: () async {
            Navigator.pop(context, {
              'selectedOption': widget.data['selectedOption'],
              'selectedShape': widget.data['selectedShape'],
              'selectedVolume': widget.data['selectedVolume'],
              'sort':widget.data['sort'],
            });
            return false;
          },
          child: Column(
            children: [
              Padding(
                padding:
                    EdgeInsets.symmetric(vertical: 1.0.h, horizontal: 4.0.h),
                child: Card(
                  child: ListTile(
                    onTap: () {
                      //updateTime(index);
                    },
                    trailing: SizedBox(
                      width: 450.w,
                      child: DropdownButton(
                        isExpanded: true,
                        hint: Text('Shape'), // Not necessary for Option 1
                        value: selectedShape,
                        onChanged: (newValue) {
                          setState(() {
                            selectedShape = (newValue) as Shape;
                            settings['selectedShape'] = selectedShape;
                            //   data['selectedShape'] = selectedShape;
                          });
                        },
                        items: shapes.map((option) {
                          return DropdownMenuItem(
                            child: Text(option.value),
                            value: option,
                          );
                        }).toList(),
                      ),
                    ),
                    leading: Text(
                      'Edit Shape :',
                      style: TextStyle(
                        fontSize: 45.sp,
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding:
                    EdgeInsets.symmetric(vertical: 1.0.h, horizontal: 4.0.h),
                child: Card(
                  child: ListTile(
                    onTap: () {
                      //updateTime(index);
                    },
                    trailing: SizedBox(
                      width: 450.w,
                      child: DropdownButton(
                        isExpanded: true,
                        hint: Text('characters/page :'),
                        // Not necessary for Option 1
                        value: selectedOption,
                        onChanged: (newValue) {
                          setState(() {
                            selectedOption = (newValue) as Option;
                            settings['selectedOption'] = selectedOption;
                            //    data['selectedOption'] = selectedOption;
                          });

                          //
                        },
                        items: options.map((option) {
                          return DropdownMenuItem(

                            child: Text(option.value),
                            value: option,
                          );
                        }).toList(),
                      ),
                    ),
                    leading: Text(
                      'Characters/pages :',
                      style: TextStyle(
                        fontSize: 45.sp,
                      ),
                    ),
                  ),
                ),
              ),


              Padding(
                padding:
                EdgeInsets.symmetric(vertical: 1.0.h, horizontal: 4.0.h),
                child: Card(
                  child: ListTile(
                    onTap: () {
                      //updateTime(index);
                    },
                    trailing: SizedBox(
                      width: 450.w,
                      child: DropdownButton(
                        isExpanded: true,
                        hint: Text('Sorting order :'),
                        // Not necessary for Option 1
                        value: selectedSort,
                        onChanged: (newValue) {
                          setState(() {
                            selectedSort = (newValue) as Sort;
                            settings['sort'] = selectedSort;
                            //    data['selectedOption'] = selectedOption;
                          });

                          //
                        },
                        items: sorts.map((sort) {
                          return DropdownMenuItem(

                            child: Text(sort.value),
                            value: sort,
                          );
                        }).toList(),
                      ),
                    ),
                    leading: Text(
                      'Sorting Option :',
                      style: TextStyle(
                        fontSize: 45.sp,
                      ),
                    ),
                  ),
                ),
              ),




              Padding(
                padding:
                    EdgeInsets.symmetric(vertical: 1.0.h, horizontal: 4.0.h),
                child: Card(
                  child: ListTile(
                    onTap: () {
                      //updateTime(index);
                    },
                   // title:
                    trailing: SizedBox(
                      width: 500.w,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,

                        children: [
                          Text((settings['selectedVolume']*100).toStringAsFixed(0)+"%"),
                          SizedBox(
                            width: 385.w,
                            child: CupertinoSlider(


                              min: 0.0,
                              max: 1.0,
                              value: settings['selectedVolume'],
                              // divisions: 10,

                              onChanged: (value) {
                                setState(() {
                                  settings['selectedVolume'] = value;

                                  widget.player.setVolume(value);
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    leading: Icon(Icons.volume_up),
                  ),
                ),
              ),


              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                      onPressed: () async{
                        final prefs = await SharedPreferences.getInstance();
                        late int opt;
                        late String shape;
                        late String sort;
                        late double volume;
                        volume = settings['selectedVolume'];
                        shape =
                        settings['selectedShape'] == Shape.SQUARE ? "square" : "circle";
                        if (settings['selectedOption'] == Option.ONE) {
                          opt = 1;
                        } else if (settings['selectedOption'] == Option.FOUR) {
                          opt = 4;
                        } else {
                          opt = 6;
                        }
                        if(settings['sort'] == Sort.ORDER){
                          sort='order';
                        }
                        else if(settings['sort'] == Sort.FAVORITES){
                          sort='favorites';
                        }
                        else if (settings['sort'] == Sort.CITIES){
                          sort='cities';
                        }
                        else if (settings['sort'] == Sort.ALPHABETICAL){
                          sort='alphabetical';
                        }
                        UserSettings userSettings =UserSettings(
                          volume: volume,
                          option: opt,
                          shape: shape,
                          sort: sort,
                        );

                        // encode user settings
                        String encodedUserSettings=UserSettings.encode(userSettings);
                        await prefs.setString('user_settings_key', encodedUserSettings);

                        await GetIt.I.get<DataBaseService>().updateUserSettingsData(
                            volume,
                            opt,
                            shape,
                            sort,
                        );

                        Navigator.pop(context,settings);

                      },
                      style: ElevatedButton.styleFrom(
                        textStyle: TextStyle(fontSize: 45.sp),
                        primary: Colors.green[800], // Background color

                      ),
                      child: Text(
                        'Save & Exit'
                      ))
                ],
              )
            ],
          ),
        ));
  }
}
