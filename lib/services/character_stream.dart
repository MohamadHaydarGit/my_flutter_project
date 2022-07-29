// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:turtle_ninja/models/CharacterData.dart';
//
// class CharaterStream{
//   late String CharacterID;
//   final CollectionReference characterCollection = FirebaseFirestore.instance.collection('characters');
//   CharaterStream({required this.CharacterID});
//
//   CharacterData _characterDataFromSnapShot(DocumentSnapshot snapshot){
//     return CharacterData(
//       name: snapshot.get('name') ?? '',
//       imageUrl: snapshot.get('imageUrl') ?? '',
//       localImagePath: snapshot.get('localImagePath') ?? '',
//       bodyImage: snapshot.get('bodyImage') ?? '',
//       details: snapshot.get('weapon') ?? ',',
//       order: snapshot.get('order') ?? 0,
//       docID: snapshot.id,
//     );
//
//
//   }
//
//   Stream<CharacterData> get characterData{
//     return characterCollection.doc(CharacterID).snapshots()
//         .map(_characterDataFromSnapShot);
//   }
//
// }