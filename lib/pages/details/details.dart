import 'dart:async';
import 'dart:ui';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_shake_animated/flutter_shake_animated.dart';
import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:turtle_ninja/helpers/dialogHelper.dart';
import 'package:turtle_ninja/models/clicked_button.dart';
import 'package:turtle_ninja/models/mission.dart';
import 'package:turtle_ninja/models/payload.dart';
import 'package:turtle_ninja/pages/details/upperPage.dart';
import 'package:turtle_ninja/sprites/turtleGame.dart';
import 'package:turtle_ninja/stream/stream.dart';
import '../../models/CharacterData.dart';
import '../../services/boxes.dart';
import '../../services/database.dart';
import '../../services/localNotificationService.dart';
import '../map/map.dart';

class Details extends StatefulWidget {
  late String docID;

  Details({required this.docID});

  @override
  State<Details> createState() => _DetailsState();
}

class _DetailsState extends State<Details> {
  late bool autoplay = false;
  late bool cancelled=false;
  Map data = {};
  ValueNotifier<bool> showAnimation = ValueNotifier(false);
  ValueNotifier<int> difference = ValueNotifier(0);
  late dynamic foundMission;
  late Timer timer=Timer(Duration(seconds: 5), () { });
  late bool notFinished = false;
  late bool canBePressed = true;
  late CharacterData chData;
  late String Id;
  bool slide = true;
  late bool clickedOnButton=false;

  void toggleCancelled(){
    setState((){
      cancelled=!cancelled;
    });
  }
  void toggleAutoPlay() {
    setState(() {
      autoplay = !autoplay;
    });
  }

  void _startTimer() {
    timer = Timer.periodic(Duration(seconds: 1), (Timer t) async {
      DateTime currentTime = DateTime.now();
      if (currentTime.isBefore(foundMission.first.endDate)) {
        difference.value = daysBetween(currentTime, foundMission.first.endDate);
        showAnimation.value=true;
        print(difference);
        notFinished = true;
        if(this.mounted) {
          setState(() {

          });
        }
      } else {

        if(cancelled==false && foundMission.first.city_id != "DefaultLocation") {

            await GetIt.I.get<DataBaseService>().missionEnd(
                foundMission.first, chData);

        }
        if(cancelled == true){
          cancelled=false;
          if(this.mounted) {
            setState(() {});
          }
        }
        notFinished = false;
        difference.value = 0;
        showAnimation.value=false;
        if(this.mounted) {
          setState(() {

          });
        }
        timer.cancel();
      }
    });
  }

  late StreamSubscription _connectionChangeStream;

  late bool hasInternet = true;
  List<Widget> _animatedWidgets = [];
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();

  void initialConnection() async {
    hasInternet = await InternetConnectionChecker().hasConnection;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    initialConnection();
    InternetConnectionChecker().onStatusChange.listen((status) {
      final hasInternet = status == InternetConnectionStatus.connected;
      setState(() {
        this.hasInternet = hasInternet;
      });
    });
    Id = widget.docID;
    chData = Boxes.getCharacterData().get(Id)!;
    chData.selected=false;
    chData.save();
    dynamic missions = GetIt.I.get<DataBaseService>().getMissions();
    foundMission =
        missions.where((mission) => mission.character_id == chData.docID);
    timer.cancel();
    if(!timer.isActive) {
      _startTimer();
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _addWidgets();
    });
  }

  void _addWidgets() {
    List<Widget> _widgets = [
      Text(
        "Name:",
        style: TextStyle(
          fontWeight: FontWeight.bold,
          decoration: TextDecoration.underline,
          fontSize: 80.sp,
          color: Colors.green[800],
        ),
      ),
      SizedBox(
        height: 20.h,
      ),
      Text(
        chData.name,
        style: TextStyle(
          fontSize: 60.sp,
        ),
      ),
      SizedBox(
        height: 80.h,
      ),

      Text(
        "Weapon:",
        style: TextStyle(
          fontWeight: FontWeight.bold,
          decoration: TextDecoration.underline,
          fontSize: 80.sp,
          color: Colors.green[800],
        ),
      ),
      SizedBox(
        height: 20.h,
      ),

      Text(
        chData.details['weapon'],
        style: TextStyle(
          fontSize: 60.sp,
        ),
      ),

      SizedBox(
        height: 80.h,
      ),

      // Markdown(
      //     styleSheet: MarkdownStyleSheet(
      //       textAlign: WrapAlignment.center,
      //       h1Align: WrapAlignment.center,
      //     ),
      //     data: chData.details['description'],
      // ),

      Text(
        "Description:",
        style: TextStyle(
          fontWeight: FontWeight.bold,
          decoration: TextDecoration.underline,
          fontSize: 80.sp,
          color: Colors.green[800],
        ),
      ),

      SizedBox(
        height: 20.h,
      ),
      Text(
        chData.details['description'],
        style: TextStyle(
          fontSize: 60.sp,
        ),
        textAlign: TextAlign.justify,
      ),
      SizedBox(
        height: 200.h,
      ),
      Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "Currently In: ",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    decoration: TextDecoration.underline,
                    fontSize: 70.sp,
                    color: Colors.green[800],
                  ),
                ),
                SizedBox(
                  height: 20.h,
                ),
                ValueListenableBuilder(
                  valueListenable: difference,
                  builder: (BuildContext context, value, Widget? child) {
                    return Text(
                      Boxes.getCities()
                          .get(foundMission.first.city_id)!
                          .cityName,
                      style: TextStyle(
                        fontSize: 60.sp,
                      ),
                    );
                  },
                ),
              ],
            ),
            TextButton(
                onPressed: () async {
                  dynamic result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => MapScreen(
                            Boxes.getMissions().values.toList().cast<Mission>(),
                            chData)),
                  );
                },
                // style: TextButton.styleFrom(
                //   backgroundColor: Colors.green[800],
                // ),
                child: Icon(
                  Icons.map_sharp,
                  color: Colors.green[800],
                  size: 100.h,
                )),
          ]),
      SizedBox(
        height: 100.h,
      ),

      // Text(Boxes.getCities().get("5C8kqdZOdPUrUHaNSsCU")!.cityName),
      ValueListenableBuilder(
        valueListenable: difference,
        builder: (BuildContext context, int value, Widget? child) {
          return Column(
            children: [
              Row(
                children: [
                  Text(
                    "Successful Missions: ",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.underline,
                      fontSize: 50.sp,
                      color: Colors.green[800],
                    ),
                  ),
                  Text(foundMission.first.successfulMissions.toString(),style: TextStyle(color: Colors.green[800])),

                ],
              ),
              SizedBox(
                height: 50.h,
              ),
              Row(
                children: [
                  Text(
                    "Cancelled Missions: ",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.underline,
                      fontSize: 50.sp,
                      color: Colors.green[800],
                    ),
                  ),
                  Text(foundMission.first.cancelledMissions.toString(),style: TextStyle(color: Colors.green[800]),),

                ],
              ),
              SizedBox(
                height: 50.h,
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    child: testWidget(notFinished),
                  ),
                ],
              ),
            ],
          );
        },
      ),
      ValueListenableBuilder(
       valueListenable: showAnimation,
    builder: (BuildContext context, value, Widget? child) {
      var size = MediaQuery.of(context).size;
         return showAnimation.value? Row(
           children: [
             SizedBox(
              height: 200.h,
              child:GameWidget(game: TurtleGame(width:size.width)),
        ),
           ],
         ) : Container();
    },
    )
    ];
    if (slide) {
      Future ft = Future(() {});

      _widgets.forEach((Widget widget) {
        ft = ft.then((_) {
          return Future.delayed(const Duration(milliseconds: 100), () {
            _animatedWidgets.add(widget);
            _listKey.currentState?.insertItem(_animatedWidgets.length - 1);
          });
        });
      });
    } else {
      _widgets.forEach((Widget widget) {
        _animatedWidgets.add(widget);
        _listKey.currentState?.insertItem(_animatedWidgets.length - 1);
      });
    }
  }

  @override
  void dispose() {
   // timer.cancel();
    super.dispose();
  }

  Tween<Offset> _offset = Tween(begin: Offset(1, 0), end: Offset(0, 0));

  @override
  Widget build(BuildContext context) {


    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green[800],
        title: Text("Character Details"),
        centerTitle: true,
        actions: [
          Text(hasInternet.toString()),
        ],
      ),
      body: ShakeWidget(
        shakeConstant: ShakeHardConstant1(),
        duration: const Duration(seconds: 2),
        autoPlay: autoplay,
        child: Container(
          constraints: BoxConstraints.expand(),
          decoration: BoxDecoration(
            //color:Color(0xff7c94b6),
            image: DecorationImage(
              colorFilter: new ColorFilter.mode(
                  Colors.black.withOpacity(0.3), BlendMode.dstATop),
              fit: BoxFit.fill,
              image: NetworkImage(
                chData.bodyImage,
              ),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(30.0, 40.0, 30.0, 30.0),
            child: Column(
              children: [
                UpperPage(chData, toggleAutoPlay),
                Expanded(
                  child: AnimatedList(
                      key: _listKey,
                      shrinkWrap: true,
                      initialItemCount: _animatedWidgets.length,
                      itemBuilder: (context, index, animation) {
                        //  if(slide) {
                        return SlideTransition(
                          child: _animatedWidgets[index],
                          position: animation.drive(_offset),
                        );
                        //  }
                        // }else{
                        //   return _animatedWidgets[index];
                        // }
                      }),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  int daysBetween(DateTime from, DateTime to) {
    from = DateTime(
        from.year, from.month, from.day, from.hour, from.minute, from.second);
    to = DateTime(to.year, to.month, to.day, to.hour, to.minute, to.second);
    return to.difference(from).inSeconds;
  }

  Widget testWidget(bool notFinished) {
    if (notFinished) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,

        children: [
          Text(
            "on a mission: " + difference.value.toString() + " seconds left",
            style: TextStyle(
              fontSize: 50.sp,
            ),
          ),
          SizedBox(
            width: 30.w,
          ),
          TextButton(
              onPressed: () async {
                // CustomDialogBox(title: 'Alert', descriptions: 'Are you sure you want to cancel'+chData.name+"'s misson", text: 'hi', chData: chData);
                // showAlertDialog(context, foundMission.first);
               await DialogHelper.cancel(
                    context,
                    chData,
                    foundMission.first,
                    'Alert!!',
                    'Are you sure you want to cancel ' +
                        chData.name +
                        "'s mission",
                  toggleCancelled,
                );

              },
              style: TextButton.styleFrom(
                // padding: EdgeInsets.all(),
                backgroundColor: Colors.green[800],
              ),
              child: Text(
                "Cancel",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 50.sp,
                ),
              ))
        ],
      );
    } else {
      return TextButton(
          onPressed: buttonFunction(canBePressed),
          style: TextButton.styleFrom(
              padding: EdgeInsets.all(40.w),
              backgroundColor: Colors.green[800]),
          child: Text(
            "Send To Mission",
            style: TextStyle(color: Colors.white, fontSize: 50.sp),
          ));
    }
  }

  VoidCallback? buttonFunction(bool canBePressed) {
    if (canBePressed) {
      return () async {
        if (!hasInternet) {
          DialogHelper.noInternet(context);
        } else {
          Future.delayed(Duration(seconds: 20), (){
            print("potato");
          });
          setState(() {
            notFinished = true;
            slide = false;
            clickedOnButton=true;
            // no such method
          });
          await GetIt.I
              .get<DataBaseService>()
              .setNewMissions(foundMission.first);

          if (!timer.isActive) {
            _startTimer();
            PayLoad payLoad = PayLoad(
                action: "OpenScreen", value: "/details", data:chData.docID);
            String encodedPayload = PayLoad.encode(payLoad);
            LocalNotificationService.showNotification(
                "ninja turtle",
                "" + chData.name + " has completed his mission",
                encodedPayload,
                DateTime.now().add(Duration(seconds: 61)));

          }
        }
      };
    } else {
      return null;
    }
  }
}
