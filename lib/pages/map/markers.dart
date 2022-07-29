// Column(
// children: <Widget>[
// Row(
// children: <Widget>[
// Expanded(child: TextFormField(
// controller: _searchController,
// textCapitalization: TextCapitalization.words,
// decoration: InputDecoration(
// hintText: 'Seach By City',
// ),
// onChanged: (value){
// print(value);
// },
// )),
// IconButton(onPressed: () async {
// await LocationService().getPlaceId(_searchController.text);
//
// }, icon: Icon(Icons.search),),
//
//
//
// ],
// ),
// Expanded(
// child: GoogleMap(
// mapType: MapType.normal,
// markers: markers,
// // polylines: {
// //   _kPolyLine,
// // },
// // polygons: {
// //   _kPolygon,
// // },
// initialCameraPosition: _kCharacter,
// onMapCreated: (GoogleMapController controller) {
// _controller.complete(controller);
// },
// ),
// ),
// ],
// ),