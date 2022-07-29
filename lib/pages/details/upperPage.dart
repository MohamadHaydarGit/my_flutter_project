

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import 'package:turtle_ninja/models/CharacterData.dart';
import 'package:turtle_ninja/models/userLikes.dart';
import 'package:vibration/vibration.dart';
import 'package:like_button/like_button.dart';
import '../../models/payload.dart';
import '../../services/boxes.dart';
import '../../services/database.dart';
import '../../services/firebaseDynamicLink.dart';

class UpperPage extends StatefulWidget {
  late CharacterData chData;
  late Function toggleAutoPlay;



  UpperPage(CharacterData chData,Function toggleAutoPlay) {
    this.toggleAutoPlay=toggleAutoPlay;
    this.chData = chData;
  }

  @override
  State<UpperPage> createState() => _UpperPageState();
}

class _UpperPageState extends State<UpperPage> {

  late UserLikes userLike;
  @override
  initState(){
    List<UserLikes> likes=Boxes.getUserLikes().values.toList().cast<UserLikes>();
    userLike=likes.where((like) => like.characterId==widget.chData.docID).first;

  }

  late int counter=0;
  void incrementCounter(){
    counter=counter+1;
    if(counter==5){
      widget.toggleAutoPlay();
      Vibration.vibrate(duration: 2000);
      counter=0;
      Future.delayed(const Duration(milliseconds: 2000), () {
          widget.toggleAutoPlay();
      });
    }

  }
  @override
  Widget build(BuildContext context) {
    bool pressed= userLike.favorite;
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Expanded(
            //   child: AspectRatio(
            //     aspectRatio: MediaQuery
            //         .of(context)
            //         .size
            //         .width / (MediaQuery
            //         .of(context)
            //         .size
            //         .height - kToolbarHeight - 24),
            //     child: Image.network(chData.bodyImage,
            //         fit: BoxFit.fill),
            //   ),
            // ),
            InkWell(
              onTap: (){
                incrementCounter();
              //  print("hi");
              },
              child: Hero(
                tag: "img_${widget.chData.docID}",
                child: CircleAvatar(
                  backgroundImage: NetworkImage(widget.chData.imageUrl),
                  radius: 300.r,
                ),
              ),
            ),
          ],
        ),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            TextButton(
              onPressed: () async {
                Vibration.vibrate(duration: 200);
                PayLoad p = PayLoad(
                    action: "OpenUrl",
                    value: '/details',
                    data: widget.chData.docID);
                String encodedData = PayLoad.encode(p);
                String link =
                await FireBaseDynamicLinkService.createDynamicLink(
                    false, encodedData);
                Clipboard.setData(new ClipboardData(text: link))
                    .then((_) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content:
                      Text('Link copied to your clipboard !')));
                });
              },
              child: Icon(
                Icons.share,
                color: Colors.green[800],
                size: 100.h,
              ),
            ),
          //  Heart(),
            LikeButton(
              isLiked: pressed,
              onTap: (pressed) async {
                userLike.favorite=!userLike.favorite;
                pressed= userLike.favorite;
                await GetIt.I.get<DataBaseService>().updateLikedCharacter(userLike);
                return pressed;
              },
            ),

          ],
        ),

        Divider(
          height: 200.0.h,
          color: Colors.grey[800],
        ),
      ],
    );
  }
}
