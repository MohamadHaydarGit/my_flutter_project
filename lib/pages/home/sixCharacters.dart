import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import '../../models/Character.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../models/enums.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../models/CharacterData.dart';
import '../details/details.dart';
import '../../routes/routes.dart';
class SixCharacters extends StatefulWidget {
  late int pageCount;
  late List<CharacterData> characters;
  late List<CharacterData> full;
  late int nb;
  late Shape shape;
  late Function refreshPageView;

  SixCharacters(int pageCount, List<CharacterData> charactersFull,Shape shape,Function refreshPageView) {
    this.pageCount = pageCount;
    this.full = charactersFull;
    if ((pageCount * 6) + 6 > full.length) {
      this.characters = charactersFull.sublist(pageCount * 6, full.length);
      nb = full.length - pageCount * 6;
    } else {
      this.characters =
          charactersFull.sublist(pageCount * 6, (pageCount * 6) + 6);
      nb = 6;
    }
    this.shape=shape;
    this.refreshPageView=refreshPageView;
  }

  @override
  State<SixCharacters> createState() => _SixCharactersState();
}

class _SixCharactersState extends State<SixCharacters> {
  static bool flag = false;
  Selected_Character single = Selected_Character();

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    /*24 is for notification bar on Android*/
    final double itemHeight = ((size.height - kToolbarHeight - 24) / 3.6);
    final double itemWidth = (size.width / 2);
    return Column(
      children: [
        GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 0.0.w,
          mainAxisSpacing: 0.0.h,
          shrinkWrap: true,
          childAspectRatio: (itemWidth / itemHeight),
          children: List.generate(
            widget.nb,
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

                    SizedBox(height: 0.0.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("${widget.characters[index].name}",style: TextStyle(fontSize: 30.sp,),),
                        AnimatedSwitcher(
                          duration: const Duration(milliseconds:00),
                          child: widget.characters[index].selected? SizedBox( height:100.h,child: TextButton.icon(onPressed:() async {
                         //   Navigator.push(context,routes.createRoute2(Details(docID: widget.characters[index].docID)));
                            await Navigator.push(context,PageTransition(
                                duration: Duration(milliseconds: 700),
                                reverseDuration: Duration(milliseconds: 700) ,
                                child:Details(docID: widget.characters[index].docID),
                                type: PageTransitionType.fade));
                            widget.refreshPageView();

                          },label:Text('View Details',style: TextStyle(color: Colors.green[800],fontSize: 30.sp),),icon: Icon(Icons.person,color: Colors.green[800],size: 40.h,),)) :Text(''),
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
    if (shape==Shape.CIRCLE) {
      return Hero(
        tag: "img_${widget.characters[index].docID}",

        child: CircleAvatar(
            radius: 230.0.r,
            backgroundImage :AssetImage('assets/sewer2.jpg'),

            child: Opacity(
              opacity: widget.characters[index].selected == true ? 0.3 : 1,
              child: CircleAvatar(
                backgroundColor: Colors.green[800],
                radius: 500.r,
              //  backgroundImage:
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
        height: 445.0.r,
        width: 445.0.r,
        decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/square_sewer.jpg'),
              fit: BoxFit.fill,
            ),
            borderRadius: BorderRadius.all(Radius.circular(20.0.r))),
        child: Opacity(
          opacity: widget.characters[index].selected == true ? 0.3 : 1,
          child: Container(

            height: 445.0.r,
            width: 445.0.r,
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
