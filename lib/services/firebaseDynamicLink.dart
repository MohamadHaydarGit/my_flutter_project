
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/cupertino.dart';
import 'package:turtle_ninja/models/CharacterData.dart';
import 'package:turtle_ninja/models/payload.dart';
import '../routes/routes.dart';
import '../pages/details/details.dart';

class FireBaseDynamicLinkService{
  static Future<String> createDynamicLink(bool short,String payload) async {
    String _linkMessage;
    PayLoad payLoad=PayLoad.decode(payload);
    final DynamicLinkParameters parameters = DynamicLinkParameters(
      uriPrefix: 'https://turtleninja.page.link',
      link: Uri.parse(_getUrl(payLoad)),
      androidParameters: AndroidParameters(
        packageName: 'com.mohamad2.turtle_ninja',
        minimumVersion: 125,
      ),

    );

    Uri url;
    if (short) {
      final ShortDynamicLink shortLink = await FirebaseDynamicLinks.instance.buildShortLink(parameters);
      url = shortLink.shortUrl;
    } else {
      url = await  FirebaseDynamicLinks.instance.buildLink(parameters);
    }

    _linkMessage = url.toString();
    return _linkMessage;
  }

  static String _getUrl(PayLoad payLoad){
    String url='';
    if(payLoad.value == '/details'){
      url='https://www.turtleninja.com/characterData?id=${payLoad.data}';
    }
    return url;
  }

  static Future<void> initDynamicLink(BuildContext context)async {

    final PendingDynamicLinkData? data = await FirebaseDynamicLinks.instance.getInitialLink();
    try{
      final Uri? deepLink = data?.link;
      var isStory = deepLink?.pathSegments.contains('characterData');
      if(isStory!){ // TODO :Modify Accordingly
        String? id = deepLink?.queryParameters['id']; // TODO :Modify Accordingly
        // TODO : Navigate to your pages accordingly here

        try{
          Navigator.push(context,routes.createRoute(Details(docID:id!)));
        }catch(e){
          print(e);
        }
      }
    }catch(e){
      print('No deepLink found');
    }


    FirebaseDynamicLinks.instance.onLink.listen((PendingDynamicLinkData data ) {
      try{
        final Uri deepLink = data.link;
        var isStory = deepLink.pathSegments.contains('characterData');
        if(isStory){ // TODO :Modify Accordingly
          String? id = deepLink.queryParameters['id']; // TODO :Modify Accordingly

          // TODO : Navigate to your pages accordingly here

          try{


            Navigator.push(context,routes.createRoute(Details(docID:id!)));
          }catch(e){
            print(e);
          }
        }
      }catch(e){
        print('No deepLink found');
      }


    });




  }
}