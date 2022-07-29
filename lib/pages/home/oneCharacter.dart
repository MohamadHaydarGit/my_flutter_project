import '../../models/CharacterData.dart';

import 'package:flutter/material.dart';
import '../../models/Character.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../models/enums.dart';
import 'dart:io';
import '../../routes/routes.dart';
import '../details/details.dart';
class OneCharacter extends StatefulWidget {
  late int pageCount;
  late CharacterData character;
  late List<CharacterData> full;
  late Shape shape;
  late Function refreshPageView;


  OneCharacter(int pageCount, List<CharacterData> charactersFull,Shape shape,Function refreshPageView) {
    this.pageCount = pageCount;
    this.full = charactersFull;
    this.character = charactersFull[pageCount];
    this.shape=shape;
    this.refreshPageView=refreshPageView;
  }

  @override
  State<OneCharacter> createState() => _OneCharacterState();
}

class _OneCharacterState extends State<OneCharacter> {
  Selected_Character single = Selected_Character();

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    /*24 is for notification bar on Android*/
    final double itemHeight = (size.height - kToolbarHeight - 24) / 3;
    final double itemWidth = size.width / 2;
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        GridView.count(
          physics: NeverScrollableScrollPhysics(),
          crossAxisCount: 1,
          crossAxisSpacing: 5.0.w,
          mainAxisSpacing: 10.0.h,
          shrinkWrap: true,
          childAspectRatio: (itemWidth / itemHeight),
          children: List.generate(
            1,
            (index) {
              return InkWell(
                onTap: () {
                  //do what you want here
                  if (widget.character.selected == true) {
                    setState(() {
                      widget.character.selected = false;

                    });
                  } else {
                    setState(() {
                      single.selectedCh.selected = false;
                      single.selectedCh = widget.character;
                      single.selectedCh.selected = true;

                    });
                  }
                },
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
                        Text("${widget.character.name}"),
                        AnimatedSwitcher(
                            duration: const Duration(milliseconds: 00),
                          child:  widget.character.selected? TextButton.icon(onPressed:() async {
                          ////  File image = new File('assets/leonardoBody.jpg'); // Or any other way to get a File instance.
                          //  var decodedImage = await decodeImageFromList(image.readAsBytesSync());
                           await Navigator.push(context,routes.createRoute(Details(docID: widget.character.docID)));
                           widget.refreshPageView();

                          },label:Text('View Details',style: TextStyle(color: Colors.green[800]),),icon: Icon(Icons.person,color: Colors.green[800],),) :Text(''),
                        )

                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget getWidget(Shape shape, int index) {
    if (shape == Shape.CIRCLE) {
      return Hero(
        tag: "img_${widget.character.docID}",
        child: CircleAvatar(
            radius: 500.r,

            //backgroundColor: widget.character.selected == true ? Color(0xffFDCF09) : Colors.transparent,
            backgroundImage: AssetImage('assets/sewer2.jpg'),
            child:
             Opacity(
                opacity: widget.character.selected == true ? 0.3 : 1,
                child: CircleAvatar(
                  backgroundColor: Colors.green[800],
                  radius: 500.r,
                 // backgroundImage: NetworkImage('${widget.character.imageUrl}'),
                  child: ClipOval(
                    child:
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [

                        Expanded(
                          child: Image.network(
                            widget.character.imageUrl,
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
              ),
           ),
      );
    } else {
      return Container(
        height: 895.w,
        width: 895.w,
        decoration: BoxDecoration(
            //color: widget.character.selected == true ? Color(0xffFDCF09):Colors.transparent,
            image: DecorationImage(
              image: AssetImage('assets/square_sewer.jpg'),
              fit: BoxFit.fill,

            ),
            borderRadius: BorderRadius.all(Radius.circular(20.0.r))),
        child: Opacity(
          opacity: widget.character.selected == true ? 0.3 : 1,
          child: Container(
            height: 895.w,
            width: 895.w,
            decoration: BoxDecoration(
              color: Colors.green[800],
              borderRadius: BorderRadius.all(Radius.circular(20.0.r)),
              // image: DecorationImage(
              //   image: NetworkImage('${widget.character.imageUrl}'),
              //   fit: BoxFit.cover,
              // ),
            ),
            child:
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [

                Expanded(
                  child: Image.network(
                    widget.character.imageUrl,
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
