import '../../models/CharacterData.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import '../../models/Character.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../models/enums.dart';
import '../details/details.dart';
import '../../routes/routes.dart';

class FourCharacters extends StatefulWidget {
  late int pageCount;
  late List<CharacterData> characters;
  late List<CharacterData> full;
  late Shape shape;
  late Function refreshPageView;

  FourCharacters(int pageCount, List<CharacterData> charactersFull,Shape shape,Function refreshPageView) {
    this.pageCount = pageCount;
    this.full = charactersFull;
    this.characters = charactersFull.sublist(pageCount * 4, (pageCount * 4) + 4);
    this.shape=shape;
    this.refreshPageView=refreshPageView;
  }

  @override
  State<FourCharacters> createState() => _FourCharactersState();
}

class _FourCharactersState extends State<FourCharacters> {
  static bool flag = false;
  Selected_Character single = Selected_Character();

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    /*24 is for notification bar on Android*/
    final double itemHeight = (size.height - kToolbarHeight - 24) / 3;
    final double itemWidth = size.width / 2;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 8.0.w,
          mainAxisSpacing: 0.0.h,
          childAspectRatio: (itemWidth / itemHeight),
          shrinkWrap: true,
          children: List.generate(
            4,
            (index) {
              return InkWell(
                onTap: () {
                  //do what you want here
                  if (widget.characters[index].selected == true) {
                    setState(() {
                      widget.characters[index].selected = false;

                    });
                  } else {
                    setState(() {
                      single.selectedCh.selected = false;
                      single.selectedCh = widget.characters[index];
                      single.selectedCh.selected = true;
                    });
                  }
                },
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      // CircleAvatar(
                      //
                      //   radius: 85,
                      //   backgroundColor: widget.characters[index].selected == true ? Color(0xffFDCF09):Colors.white,
                      //   child: CircleAvatar(
                      //     backgroundImage: AssetImage('${widget.characters[index].url}'),
                      //     radius: 80.0,
                      //   ),
                      //),
                      getWidget(widget.shape, index),

                      SizedBox(height: 10.0.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("${widget.characters[index].name}",style: TextStyle(fontSize:widget.characters[index].selected? 30.sp:40.sp),),
                          AnimatedSwitcher(
                            duration: const Duration(milliseconds: 00),
                            child: widget.characters[index].selected? SizedBox(height: 100.h,child: TextButton.icon(onPressed:() async {
                            // FirebaseCrashlytics.instance.crash();// Force a crash
                             await Navigator.push(context,routes.createRoute2(Details(docID: widget.characters[index].docID)));
                             widget.refreshPageView();
                            },label:Text('View Details',style: TextStyle(color: Colors.green[800],fontSize: 30.sp),),icon: Icon(Icons.person,color: Colors.green[800],size: 60.h,),)) :Text(''),
                          )

                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget getWidget(Shape shape, int index) {
    if (shape==Shape.CIRCLE) {
      return Hero(
        tag: "img_${widget.characters[index].docID}",
        child: CircleAvatar(
            radius: 250.r,
            backgroundImage: AssetImage('assets/sewer2.jpg'),
            child: Opacity(
              opacity: widget.characters[index].selected == true ? 0.3 : 1,
              child: CircleAvatar(
                radius: 500.r,
                backgroundColor: Colors.green[800],
               // backgroundImage: NetworkImage('${widget.characters[index].imageUrl}'),
               child: ClipOval(
                  child:
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [

                      Expanded(
                        child: Image.network(
                          widget.characters[index].imageUrl,
                          fit: BoxFit.cover,
                          loadingBuilder: (BuildContext context, Widget child,
                              ImageChunkEvent? loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Center(
                              child: CircularProgressIndicator(
                                value: loadingProgress.expectedTotalBytes != null
                                    ? loadingProgress.cumulativeBytesLoaded /
                                    loadingProgress.expectedTotalBytes!
                                    : null,
                              ),
                            );
                          },


                        ),
                      ),
                    ],
                  ),




                ),
              ),
            )),
      );
    } else {
      return Container(
        height: 495.0.r,
        width: 495.0.r,
        decoration: BoxDecoration(
            //color: widget.character.selected == true ? Color(0xffFDCF09):Colors.transparent,
            image: DecorationImage(
              image: AssetImage('assets/square_sewer.jpg'),
              fit: BoxFit.fill,
            ),
            borderRadius: BorderRadius.all(Radius.circular(20.0.r))),
        child: Opacity(
          opacity: widget.characters[index].selected == true ? 0.3 : 1,
          child: Container(
            height: 895.w,
            width: 895.w,
            decoration: BoxDecoration(
              color: Colors.green[800],
              borderRadius: BorderRadius.all(Radius.circular(20.0.r)),
              // image: DecorationImage(
              //   image: NetworkImage('${widget.characters[index].imageUrl}'),
              //   fit: BoxFit.cover,
              // ),
            ),
            child:
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [

                Expanded(
                  child: Image.network(
                    widget.characters[index].imageUrl,
                    fit: BoxFit.cover,
                    loadingBuilder: (BuildContext context, Widget child,
                        ImageChunkEvent? loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Center(
                        child: CircularProgressIndicator(
                          value: loadingProgress.expectedTotalBytes != null
                              ? loadingProgress.cumulativeBytesLoaded /
                              loadingProgress.expectedTotalBytes!
                              : null,
                        ),
                      );
                    },


                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }
  }

}
