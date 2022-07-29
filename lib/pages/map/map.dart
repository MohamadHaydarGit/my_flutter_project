import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:custom_map_markers/custom_map_markers.dart';
import '../../models/CharacterData.dart';
import '../../models/city.dart';
import '../../models/mission.dart';
import '../../services/boxes.dart';
import 'package:property_change_notifier/property_change_notifier.dart';

class MapScreen extends StatefulWidget {

  late CharacterData chData;
  late List<Mission> missions;

  late BitmapDescriptor markerbitmap;

  MapScreen(List<Mission> missions, CharacterData chData) {
    this.missions = missions;
    this.chData = chData;
  }

  @override
  State<MapScreen> createState() => MapScreenState();
}

class MapScreenState extends State<MapScreen> {

  Set<Marker> markers = Set(); //markers for google map
  Completer<GoogleMapController> _controller = Completer();
  TextEditingController _searchController = TextEditingController();
  late List<MarkerData> _customMarkers;

  @override
  void initState() {
    super.initState();
    addMarkers();
  }

  void addMarkers() {
    _customMarkers=[];
    for (int i = 0; i < widget.missions.length; i++) {
      String n=Boxes.getCharacterData().get(widget.missions[i].character_id)!.name;
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
                  position: LatLng(Boxes.getCities().get(widget.missions[i].city_id)!.lat, Boxes.getCities().get(widget.missions[i].city_id)!.lng),
                  infoWindow: InfoWindow(title: Boxes.getCharacterData().get(widget.missions[i].character_id)!.name),),
                child: _customMarker(Boxes.getCharacterData().get(widget.missions[i].character_id)!.imageUrl, c))
        );
      });

    }
  }


  late CameraPosition _kCharacter = _kCharacter = CameraPosition(
    target: LatLng(Boxes.getCities().get(widget.missions.where((mission) =>
    mission.character_id == widget.chData.docID).first.city_id)!.lat,Boxes.getCities().get(widget.missions.where((mission) =>
    mission.character_id == widget.chData.docID).first.city_id)!.lng),
    zoom: 14.4746,
  );


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
    return Scaffold(
      appBar: AppBar(
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
                  initialCameraPosition: _kCharacter,
                  markers: markers,
                  onMapCreated: (GoogleMapController controller) {
                    _controller.complete(controller);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );

    // floatingActionButton: FloatingActionButton.extended(
    //   onPressed: _goToTheLake,
    //   label: Text('To the lake!'),
    //   icon: Icon(Icons.directions_boat),
    // ),

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
                color: Colors.white, borderRadius: BorderRadius.circular(100)),
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