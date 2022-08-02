import "package:flutter/material.dart";
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:turtle_ninja/models/CharacterData.dart';

import '../../services/boxes.dart';

class Board extends StatefulWidget {
  const Board({Key? key}) : super(key: key);

  @override
  State<Board> createState() => BoardState();
}

class BoardState extends State<Board> {
  List<CharacterData> charactersList = [];

  Future<void> getScores() async {
    charactersList = Boxes.getCharacterData().values.toList().cast<CharacterData>();
    charactersList.sort((a,b) => a.details['successfulMissions'].compareTo(b.details['successfulMissions']));
    await Future.delayed(Duration(seconds: 2));
    setState((){
      charactersList = List.from(charactersList.reversed);
    });

  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getScores();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text('LeaderBoard'),
        centerTitle: true,
        backgroundColor: Colors.green[800],
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(

                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListTile(
                      leading: CircleAvatar(
                        radius: 70.r,
                        child: Icon(Icons.person,color: Colors.white,),
                        backgroundColor: Colors.green[800],
                      ),
                      title: Text("Name",textAlign: TextAlign.center,),
                      trailing: Icon(Icons.done_outline_outlined,color: Colors.green[800],)//Text("Missions"),
                    ),
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //   children: <Widget>[
                    //     Text("Image"),
                    //     Text("Name"),
                    //     Text("Missions"),
                    //   ],
                    // ),
                  )
                )
            ),

            Expanded(
              child: RefreshIndicator(
                color: Colors.green[800],
                onRefresh: getScores,
                child:
                       ListView.builder(
                        itemCount: charactersList == null ? 0 : charactersList.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: GestureDetector(
                              child: Container(
                                child: Center(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.stretch,
                                    children: <Widget>[
                                      Card(
                                        child: Container(
                                          padding: EdgeInsets.all(12.0),
                                          child:
                                          Column(
                                            children: <Widget>[
                                              ListTile(
                                                leading: CircleAvatar(
                                                  radius: 70.r,
                                                  backgroundImage: NetworkImage(charactersList[index].imageUrl),
                                                ),
                                                title: Text(charactersList[index].name,textAlign: TextAlign.center,),
                                                trailing: Text(charactersList[index].details['successfulMissions'].toString()),
                                              ),
                                            ],
                                          ),
                                        ),
                                        // shape: OutlineInputBorder(
                                        //     borderRadius:
                                        //     BorderRadius.all(Radius.circular(25.0))),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              // onTap: () =>
                              //     Scaffold.of(context).showSnackBar(SnackBar(
                              //       content: Text(data[index]['movieNm']),
                              //       duration: Duration(seconds: 2),)),
                            ),
                          );
                        }),

                ),
              ),
          ],
        ),
      ),
    );
  }
}
