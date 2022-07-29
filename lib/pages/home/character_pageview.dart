import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:turtle_ninja/models/CharacterData.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:turtle_ninja/models/city.dart';
import 'package:turtle_ninja/models/enums.dart';
import 'package:turtle_ninja/services/boxes.dart';
import 'package:turtle_ninja/shared/loader.dart';
import '../../models/Character.dart';
import '../../models/mission.dart';
import '../../models/userLikes.dart';
import 'fourCharacters.dart';
import 'oneCharacter.dart';
import 'sixCharacters.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
class CharacterList extends StatefulWidget {
  Map settings={};
  CharacterList(Map settings){
    this.settings=settings;

  }
  @override
  State<CharacterList> createState() => _CharacterListState();
}

class _CharacterListState extends State<CharacterList> {
  void refreshPageview(){
    setState((){

    });
  }

  PageController _pageController = PageController(initialPage: 0);
  int _currentIndex = 0;
  @override
  Widget build(BuildContext context) {
   // List<CharacterData>? characters2 = Provider.of<List<CharacterData>?>(context);

    List<CharacterData>? characters2=Boxes.getCharacterData().values.toList().cast<CharacterData>();
    //_pageController.jumpToPage(0);
    if (characters2 != null) {
      List<CharacterData> characters=characters2.map((character){

        if(character.name==Selected_Character().selectedCh.name && Selected_Character().selectedCh.selected==true){
          Selected_Character().selectedCh=character;
          character.selected=true;
        }
        else if(character.name==Selected_Character().selectedCh.name && Selected_Character().selectedCh.selected==false){
          Selected_Character().selectedCh=character;
          character.selected=false;
        }
        return character;

      }).toList();

      switch(widget.settings['sort']){
        case Sort.ORDER:{
          characters.sort((a, b) => a.order.compareTo(b.order));
          }
          break;
        case  Sort.ALPHABETICAL:{
          characters.sort((a, b) => a.name.compareTo(b.name));
         }
          break;
        case Sort.CITIES:{
          late int index;
          int counter=0;
          late CharacterData temp;
          late Mission m;
          late CharacterData characterData;
          final missions=Boxes.getMissions().values.toList().cast<Mission>();
          final cities = Boxes.getCities().values.toList().cast<City>();
          cities.sort((a,b) => a.cityName.compareTo(b.cityName));
          cities.forEach((city) {
            if(missions.where((mission) => mission.city_id==city.docID).isNotEmpty) {
              m=missions.where((mission) => mission.city_id==city.docID).first;
              index = characters.indexWhere((character) => character.docID == m.character_id);
              final temp = characters[counter];
              characters[counter] = characters[index];
              characters[index] = temp;
              counter ++;
            }
          });

        }
        break;

        case Sort.FAVORITES:{
          List<UserLikes> userLikesList=Boxes.getUserLikes().values.toList().cast<UserLikes>();
          List <CharacterData> ListFavorites=[];
          List<CharacterData> ListNotFavorites=[];
          userLikesList.forEach((userLike) {
            if(userLike.favorite == true){
              ListFavorites.add(characters.where((character) => character.docID==userLike.characterId).first);
            }
            else{
              ListNotFavorites.add(characters.where((character) => character.docID==userLike.characterId).first);
            }

          });

          ListFavorites.sort((a,b) => a.order.compareTo(b.order));
          ListNotFavorites.sort((a,b) => a.order.compareTo(b.order));
          ListFavorites.addAll(ListNotFavorites);
          characters=ListFavorites;

        }
        break;


      }

    //  print(characters);
      return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            height: 100.h,
            decoration: BoxDecoration(
           //   color: Colors.green[100],
            ),

          ),


          Expanded(
            child: Container(
              decoration: BoxDecoration(
               //   color:Colors.green[100],
              ),
              // height: 1500.h,
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (newIndex) {
                  setState(() {
                    _currentIndex = newIndex;
                  });
                },
                itemBuilder: (context, index) {
                  if (widget.settings['selectedOption'] == Option.ONE) {
                    return OneCharacter(
                        index, characters, widget.settings['selectedShape'],refreshPageview);
                  } else if (widget.settings['selectedOption'] == Option.FOUR) {
                    return FourCharacters(
                        index, characters, widget.settings['selectedShape'],refreshPageview);
                  } else {
                    return SixCharacters(
                        index, characters, widget.settings['selectedShape'],refreshPageview);
                  }
                },

                itemCount: (characters.length /
                    int.parse(widget.settings['selectedOption'].value))
                    .ceil(), // Can be null
              ),
            ),
          ),

          Container(

            height: 200.0.h,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    _pageController.previousPage(
                        duration: Duration(milliseconds: 500),
                        curve: Curves.ease);
                  },
                  icon: Icon(Icons.arrow_back),
                  label: Text(""),
                  style: ElevatedButton.styleFrom(
                    textStyle: TextStyle(fontSize: 15.sp),
                    primary: Colors.green[800], // Background color
                  ),
                ),
                SmoothPageIndicator(
                  controller: _pageController,
                  count: (characters.length / int.parse(
                      widget.settings['selectedOption'].value)).ceil(),
                  effect: JumpingDotEffect(
                    activeDotColor: Colors.green.shade800,
                    dotColor: Colors.green.shade100,
                    dotHeight: 40.w,
                    dotWidth: 40.w,

                    spacing: 40.w,
                    //verticalOffset: 50,
                    jumpScale: 3,
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    _pageController.nextPage(
                        duration: Duration(milliseconds: 500),
                        curve: Curves.ease);
                  },
                  icon: Icon(Icons.arrow_forward),
                  label: Text(""),
                  style: ElevatedButton.styleFrom(
                    textStyle: TextStyle(fontSize: 30.sp),
                    primary: Colors.green[800], // Background color
                  ),
                ),
              ],
            ),
          ),
        ],
      );


    }
    else{
      return Loader();
    }
  }
}