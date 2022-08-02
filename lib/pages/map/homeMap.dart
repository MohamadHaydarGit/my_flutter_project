import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:custom_map_markers/custom_map_markers.dart';
import 'package:turtle_ninja/drawer/drawer.dart';
import '../../models/CharacterData.dart';
import '../../models/city.dart';
import '../../models/mission.dart';
import '../../services/boxes.dart';
import 'package:property_change_notifier/property_change_notifier.dart';

class HomeMap extends StatefulWidget {
  const HomeMap({Key? key}) : super(key: key);
  @override
  State<HomeMap> createState() => HomeMapState();
}

class HomeMapState extends State<HomeMap> {

  void refreshMap(){
    setState((){

    });
  }

  Set<Marker> markers = Set(); //markers for google map
  Completer<GoogleMapController> _controller = Completer();
  TextEditingController _searchController = TextEditingController();
  late List<MarkerData> _customMarkers;

  late Timer timer;

  void startTimer(){
    timer = Timer.periodic(Duration(seconds: 1), (Timer t) async {
      //  addMarkers();
    });
  }


  @override
  void initState() {
    super.initState();

    startTimer();

  }
  void dispose(){
    super.dispose();
    timer.cancel();
  }

  void addMarkers() {
    List<Mission> missions = Boxes.getMissions().values.toList().cast<Mission>();
    _customMarkers=[];
    for (int i = 0; i < missions.length; i++) {
      String n=Boxes.getCharacterData().get(missions[i].character_id)!.name;
      Color c;
      switch(n) {
        case "Splinter":{
          c=Colors.grey;
        }
        break;
        case "MichelAngelo":{
          c=Colors.orange;
        }
        break;

        case "Shredder":{
          c=Colors.black;
        }
        break;
        case "Raphael":{
          c=Colors.red;
        }
        break;
        case "April":{
          c=Colors.yellow;
        }
        break;

        case "Donatello":{
          c=Colors.purple;
        }
        break;

        case "Leonardo":{
          c=Colors.blue;
        }
        break;

        case "Casey":{
          c=Colors.cyan;
        }
        break;

        default:{
          c=Colors.blue;
        }
        break;


      }
      setState((){

        _customMarkers.add(
            MarkerData(
                marker:
                Marker(markerId: MarkerId('id-' + i.toString()),
                  position: LatLng(Boxes.getCities().get(missions[i].city_id)!.lat, Boxes.getCities().get(missions[i].city_id)!.lng),
                  infoWindow: InfoWindow(title: Boxes.getCharacterData().get(missions[i].character_id)!.name),),
                child: _customMarker(Boxes.getCharacterData().get(missions[i].character_id)!.imageUrl, c))
        );
      });

    }
  }




  static final Polyline _kPolyLine = Polyline(
    polylineId: PolylineId('_kPolyLine'),
    points: [
      LatLng(37.43296265331129, -122.08832357078792),
      LatLng(37.42796133580664, -122.085749655962),

    ],
    width: 5,

  );

  static final Polygon _kPolygon = Polygon(
    polygonId: PolygonId('_kPolygon'),
    points: [
      LatLng(37.43296265331129, -122.08832357078792),
      LatLng(37.42796133580664, -122.085749655962),
      LatLng(37.418, -122.092),
      LatLng(37.435, -122.092),

    ],
    strokeWidth: 5,
    fillColor: Colors.transparent,

  );

  @override
  Widget build(BuildContext context) {
    addMarkers();
    return Scaffold(
      drawer: MyDrawer(),
      appBar: AppBar(
        backgroundColor: Colors.green[800],
        title: Text('Google Maps'),


      ),
      body: Column(
        children: [
          Row(
            children: <Widget>[
              Expanded(
                  child: TextFormField(
                    controller: _searchController,
                    textCapitalization: TextCapitalization.words,
                    decoration: InputDecoration(
                      hintText: 'Seach By City',
                    ),
                    onChanged: (value) {
                      print(value);
                    },
                  )),
              IconButton(
                onPressed: () async {
                  // await LocationService().getPlaceId(_searchController.text);
                },
                icon: Icon(Icons.search),
              ),
            ],
          ),
          Expanded(
            child: CustomGoogleMapMarkerBuilder(
              //screenshotDelay: const Duration(seconds: 4),
              customMarkers: _customMarkers,
              builder: (BuildContext context, Set<Marker>? markers) {
                if (markers == null) {
                  return const Center(child: CircularProgressIndicator());
                }
                return GoogleMap(
                  initialCameraPosition: CameraPosition(target:_bounds(markers).northeast),
                  markers: markers,
                  onMapCreated: (GoogleMapController controller) {
                    _controller.complete(controller);
                    setState(() {
                      controller.animateCamera(CameraUpdate.newLatLngBounds(_bounds(markers),200));
                    });
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () { setState((){}); },
        child: Icon(Icons.refresh),
        backgroundColor: Colors.green[800],



      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );

    // floatingActionButton: FloatingActionButton.extended(
    //   onPressed: _goToTheLake,
    //   label: Text('To the lake!'),
    //   icon: Icon(Icons.directions_boat),
    // ),

  }
  LatLngBounds _bounds(Set<Marker> markers) {
    return _createBounds(markers.map((m) => m.position).toList());
  }


  LatLngBounds _createBounds(List<LatLng> positions) {
    final southwestLat = positions.map((p) => p.latitude).reduce((value, element) => value < element ? value : element); // smallest
    final southwestLon = positions.map((p) => p.longitude).reduce((value, element) => value < element ? value : element);
    final northeastLat = positions.map((p) => p.latitude).reduce((value, element) => value > element ? value : element); // biggest
    final northeastLon = positions.map((p) => p.longitude).reduce((value, element) => value > element ? value : element);
    return LatLngBounds(
        southwest: LatLng(southwestLat, southwestLon),
        northeast: LatLng(northeastLat, northeastLon)
    );
  }

  // Future<void> _goToTheLake() async {
  //   final GoogleMapController controller = await _controller.future;
  //   controller.animateCamera(CameraUpdate.newCameraPosition(_kLake));
  // }
  _customMarker(String symbol, Color color) {
    return Stack(
      children: [
        Icon(
          Icons.add_location,
          color: color,
          size: 55,
        ),
        Positioned(
          left: 15,
          top: 8,
          child: Container(
            width: 25,
            height: 25,
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(10)),
            child: Center(child: CircleAvatar(
              radius: 25,
              backgroundImage: NetworkImage(symbol),
            ),),
          ),
        )
      ],
    );
  }

}