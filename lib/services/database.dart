import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hive/hive.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:turtle_ninja/helpers/dialogHelper.dart';
import 'package:turtle_ninja/models/CharacterData.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:turtle_ninja/models/lastUpdate.dart';
import 'package:turtle_ninja/models/mission.dart';
import 'package:turtle_ninja/models/myuser.dart';
import 'package:turtle_ninja/models/userLikes.dart';
import 'package:turtle_ninja/services/localNotificationService.dart';
import '../dialogs/loaderDialog.dart';
import '../shared/dialog.dart';
import 'boxes.dart';
import '../models/city.dart';

class DataBaseService {
  late String uid;
  final CollectionReference characterCollection =
      FirebaseFirestore.instance.collection('characters');
  final CollectionReference userSettingsCollection =
      FirebaseFirestore.instance.collection('settings');
  final CollectionReference citiesCollection =
      FirebaseFirestore.instance.collection('cities');
  final CollectionReference missionsCollection =
      FirebaseFirestore.instance.collection('user_missions');
  final CollectionReference lastUpdateCollection =
      FirebaseFirestore.instance.collection('last_update');
  final CollectionReference userLikesCollection=
      FirebaseFirestore.instance.collection('user_likes');

  StreamController<List<CharacterData>> controller =
      StreamController<List<CharacterData>>();

  Future updateUserSettingsData(
      double selectedVolume, int selectedOption, String selectedShape,String sort) async {
    return await userSettingsCollection.doc(uid).set({
      'volume': selectedVolume,
      'option': selectedOption,
      'shape': selectedShape,
      'sort': sort,
    });
  }

  Future updateLikedCharacter(UserLikes userLike) async {
     await userLikesCollection.doc(userLike.docID).update({
      'favorite': userLike.favorite,
    }).then((value) {

       userLike.save();

    });
  }


  Future newUser() async {
    List<CharacterData> charactersList = [];
    //do your api call and add data to stream
    QuerySnapshot charactersSnapshot =
    await characterCollection.orderBy('order', descending: false).get();
    charactersList = charactersSnapshot.docs
        .map((doc) => CharacterData(
      name: doc.get('name'),
      imageUrl: doc.get('imageUrl'),
      localImagePath: doc.get('localImagePath'),
      bodyImage: doc.get('bodyImage'),
      order: doc.get('order'),
      details: doc.get('details'),
      selected: false,
      docID: doc.id,
    ))
        .toList();
    charactersList.forEach((character) async {
      await missionsCollection.add({
        'characterId': character.docID,
        'locationId':"DefaultLocation",
        'userId':uid,
        'endDate':Timestamp.now(),
        'successfulMissions': 0,
        'cancelledMissions': 0,
      });

    });

    /// NEW
    charactersList.forEach((character) async {
      await userLikesCollection.add({
        'characterId': character.docID,
        'favorite':false,
        'userId':uid,
      });
    });


  }

  //Character list from snapshot
  List<CharacterData> _chraracterListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return CharacterData(
        name: doc.get('name') ?? '',
        imageUrl: doc.get('imageUrl') ?? '',
        localImagePath: doc.get('localImagePath') ?? '',
        bodyImage: doc.get('bodyImage') ?? '',
        details: doc.get('details') ?? ',',
        order: doc.get('order') ?? 0,
        selected: false,
        docID: doc.id,
      );
    }).toList();
  }

  //User settings from snapshot

  // UserSettings _userSettingsFromSnapShot(DocumentSnapshot snapshot) {
  //   return UserSettings(
  //       volume: snapshot.get('volume'),
  //       option: snapshot.get('option'),
  //       shape: snapshot.get('shape'));
  // }

  Future<void> missionEnd(Mission mission,CharacterData chData) async {
    chData.details['successfulMissions']= chData.details['successfulMissions']+1;
    await characterCollection.doc(chData.docID).update({
      'details': chData.details,

    }).then((value){
      chData.save();
    });

    await missionsCollection.doc(mission.missionId).update({
      'locationId': 'DefaultLocation',
      'successfulMissions':mission.successfulMissions+1,
    }).then((result){
      mission.city_id="DefaultLocation";
      mission.successfulMissions=mission.successfulMissions+1;
      mission.save();
    }).catchError((e){
      print(e);
    });

  }

  Future<void> missionCancel(Mission mission,context,Function toggleIsTimeout,CharacterData chData) async {
    showLoaderDialog(context);
    chData.details['cancelledMissions']=chData.details['cancelledMissions']+1;

    await characterCollection.doc(chData.docID).update({
      'details': chData.details,

    }).then((value){
      chData.save();
    });

    await missionsCollection.doc(mission.missionId).update({
      'endDate': Timestamp.fromDate(DateTime.now()),
      'cancelledMissions': mission.cancelledMissions+1,
    }).then((result){
      FlutterLocalNotificationsPlugin().cancelAll();
      mission.cancelledMissions=mission.cancelledMissions+1;
      mission.endDate=DateTime.now();
      mission.save();



    }).catchError((e){
      // Navigator.of(context).pop();

      showAlertDialog(context);
      print(e);
    }).timeout(Duration(seconds: 5),
    onTimeout: (){
      Navigator.of(context).pop();
      toggleIsTimeout();
      // FirebaseDatabase.instance.purgeOutstandingWrites();
      DialogHelper.noInternet(context);
    });
  }

  
  
  Future<void> setNewMissions(Mission mission) async {
    City city=(Boxes.getCities().values.toList().cast<City>()..shuffle()).first;
    await missionsCollection.doc(mission.missionId).update({
      'locationId': city.docID,
      'endDate': Timestamp.fromDate(DateTime.now().add(Duration(minutes: 1))),
    }).then((result){
      mission.city_id=city.docID;
      mission.endDate=DateTime.now().add(Duration(minutes: 1));
      mission.save();



    }).catchError((e){
      print(e);
    });
    
  }

  Future<void> UpdateData() async {
    Boxes.getCities().deleteAll(Boxes.getCities().keys);
    Boxes.getCharacterData().deleteAll(Boxes.getCharacterData().keys);
    Boxes.getMissions().deleteAll(Boxes.getMissions().keys);
    Boxes.getLastUpdates().deleteAll(Boxes.getLastUpdates().keys);
    Boxes.getUserLikes().deleteAll(Boxes.getUserLikes().keys);


    SharedPreferences prefs = await SharedPreferences.getInstance();

    List<CharacterData> charactersList = [];
    //do your api call and add data to stream
    QuerySnapshot charactersSnapshot =
        await characterCollection.orderBy('order', descending: false).get();
    charactersList = charactersSnapshot.docs
        .map((doc) => CharacterData(
              name: doc.get('name'),
              imageUrl: doc.get('imageUrl'),
              localImagePath: doc.get('localImagePath'),
              bodyImage: doc.get('bodyImage'),
              order: doc.get('order'),
              details: doc.get('details'),
              selected: false,
              docID: doc.id,
            ))
        .toList();

    List<City> citiesList = [];
    //do your api call and add data to stream
    QuerySnapshot citySnapshot = await citiesCollection.get();
    citiesList = citySnapshot.docs
        .map((doc) => City(
            adminName: doc.get('adminName'),
            cityName: doc.get('city'),
            country: doc.get('country'),
            lat: doc.get('lat').toDouble(),
            lng: doc.get('lng').toDouble(),
            population: doc.get('population'),
            docID: doc.id))
        .toList();

    List<Mission> missionsList = [];
    //do your api call and add data to stream
    QuerySnapshot missionsSnapshot =
        await missionsCollection.where('userId', isEqualTo: uid).get();
    missionsList = missionsSnapshot.docs
        .map((doc) => Mission(
            city_id: doc.get('locationId'),
            character_id: doc.get('characterId'),
            missionId: doc.id,
            endDate: doc.get('endDate').toDate(),
            successfulMissions: doc.get('successfulMissions'),
            cancelledMissions: doc.get('cancelledMissions'),
    )).toList();


    List<UserLikes> userLikesList = [];
    QuerySnapshot userLikesSnapshot =
    await userLikesCollection.where('userId', isEqualTo: uid).get();
    userLikesList = userLikesSnapshot.docs
        .map((doc) => UserLikes(
      characterId: doc.get('characterId'),
      favorite: doc.get('favorite'),
      userId: doc.get('userId'),
      docID: doc.id,
    )).toList();

    final charactersBox = Boxes.getCharacterData();
    charactersList.forEach((character) {
      charactersBox.put(character.docID, character);
    });

    final citiesBox = Boxes.getCities();
    citiesList.forEach((city) {
      citiesBox.put(city.docID, city);
    });

    final missionsBox = Boxes.getMissions();
    missionsList.forEach((mission) {
      missionsBox.put(mission.character_id, mission);
    });

    final userLikesBox = Boxes.getUserLikes();
    userLikesList.forEach((userLike) {
      userLikesBox.put(userLike.characterId,userLike);
    });

    LastUpdate ch=LastUpdate(name:"characters", time: DateTime.now());
    LastUpdate ct=LastUpdate(name:"cities", time: DateTime.now());

    Boxes.getLastUpdates().add(ch);
    Boxes.getLastUpdates().add(ct);

    DocumentSnapshot documentSnapshot =
        await userSettingsCollection.doc(uid).get();
    UserSettings userSettings = UserSettings(
      volume: documentSnapshot.get('volume'),
      option: documentSnapshot.get('option'),
      shape: documentSnapshot.get('shape'),
      sort: documentSnapshot.get('sort'),
    );

    // encode user settings
    String encodedUserSettings = UserSettings.encode(userSettings);
    //encode characters list
    // String encodedCharactersList=CharacterData.encode(charactersList);

    String dateOfUpdate = DateTime.now().toUtc().toIso8601String();

    //save encoded data to shared_preferences
    //  await prefs.setString('characters_list_key', encodedCharactersList);
    await prefs.setString('user_settings_key', encodedUserSettings);
    await prefs.setString('update_date', dateOfUpdate);
  }

  Future<void> updateCities() async {
    Boxes.getCities().deleteAll(Boxes.getCities().keys);
    Boxes.getLastUpdates().deleteAll(Boxes.getLastUpdates().keys);
    List<City> citiesList = [];
    //do your api call and add data to stream
    QuerySnapshot citySnapshot = await citiesCollection.get();
    citiesList = citySnapshot.docs
        .map((doc) => City(
            adminName: doc.get('adminName'),
            cityName: doc.get('city'),
            country: doc.get('country'),
            lat: doc.get('lat').toDouble(),
            lng: doc.get('lng').toDouble(),
            population: doc.get('population'),
            docID: doc.id))
        .toList();
    final citiesBox = Boxes.getCities();
    citiesList.forEach((city) {
      citiesBox.put(city.docID, city);
    });


    LastUpdate ct=LastUpdate(name: "cities", time: DateTime.now());

    Boxes.getLastUpdates().add(ct);
  }
  Future <void> updateCharacterData() async{
    Boxes.getCharacterData().deleteAll(Boxes.getCharacterData().keys);
    Boxes.getLastUpdates().deleteAll(Boxes.getLastUpdates().keys);
    List<CharacterData> charactersList = [];
    //do your api call and add data to stream
    QuerySnapshot charactersSnapshot =
    await characterCollection.orderBy('order', descending: false).get();
    charactersList = charactersSnapshot.docs
        .map((doc) => CharacterData(
      name: doc.get('name'),
      imageUrl: doc.get('imageUrl'),
      localImagePath: doc.get('localImagePath'),
      bodyImage: doc.get('bodyImage'),
      order: doc.get('order'),
      details: doc.get('details'),
      selected: false,
      docID: doc.id,
    ))
        .toList();
    final charactersBox = Boxes.getCharacterData();
    charactersList.forEach((character) {
      charactersBox.put(character.docID, character);
    });
    LastUpdate ch=LastUpdate(name: "characters", time: DateTime.now());

    Boxes.getLastUpdates().add(ch);




  }

  List<Mission> getMissions() {
    return Boxes.getMissions().values.toList();
  }

  Future<DateTime> getCharactersLastUpdate() async {
    DocumentSnapshot documentSnapshot = await lastUpdateCollection.doc('JwVBInHdEEKpndUdfUGM').get();
    Timestamp t = documentSnapshot.get('characters');
    DateTime d = t.toDate();
    return d;
  }

  Future<DateTime> getCitiesLastUpdate() async {
    DocumentSnapshot documentSnapshot = await lastUpdateCollection.doc('JwVBInHdEEKpndUdfUGM').get();
    Timestamp t = documentSnapshot.get('cities');
    DateTime d = t.toDate();
    return d;
  }

  // get Characters stream
  Stream<List<CharacterData>> get characters {
    return characterCollection
        .orderBy('order', descending: false)
        .snapshots()
        .map(_chraracterListFromSnapshot);
  }

//get user settings doc stream
//   Stream<UserSettings> get userData {
//     return userSettingsCollection
//         .doc(uid)
//         .snapshots()
//         .map(_userSettingsFromSnapShot);
//   }
}
