import 'dart:async';
import 'package:app/Map/MyLocationButton.dart';
import 'package:app/Screens/drawer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/services.dart' show rootBundle;

import 'style.dart';

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  MapStyle style = MapStyle();
  final _scaffoldKey = new GlobalKey<ScaffoldState>();
  String _mapStyle;
  Completer<GoogleMapController> _controller = Completer();
  GoogleMapController _mapController;
  static const LatLng _center = LatLng(44.500000, -89.500000);
  final Set<Marker> _markers = {};
  LatLng _lastMapPosition = _center;
  MapType _currentMapType = MapType.normal;
  String _heroText = "Choisir le lieu de départ";

  @override
  void initState() {
    super.initState();
    rootBundle.loadString('assets/map_style.txt').then((string) {
      _mapStyle = string;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: Drawer(
        child: DrawerClass(),
      ),
      body: Stack(
        children: [
          GoogleMap(
            buildingsEnabled: false,
            circles: {
              // define the circle here
            },
            zoomControlsEnabled: false,
            onMapCreated: _onMapCreated,
            initialCameraPosition: CameraPosition(target: _center, zoom: 11.0),
            mapType: _currentMapType,
            markers: _markers,
            onCameraMove: _onCameraMove,
          ),
          SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [Colors.white30, Colors.white10])),
                      child: Row(children: [
                        FloatingActionButton(
                            backgroundColor: Colors.transparent,
                            elevation: 0.0,
                            child:
                                Icon(Icons.menu, color: Colors.black, size: 27),
                            onPressed: () =>
                                _scaffoldKey.currentState.openDrawer()),
                        SizedBox(width: 20),
                        SizedBox(
                            width: MediaQuery.of(context).size.width - 90,
                            child: Text(_heroText,
                                style: TextStyle(fontSize: 25.0),
                                softWrap: true))
                      ]),
                    ),
                    Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white),
                      margin: EdgeInsets.symmetric(horizontal: 10),
                      padding: EdgeInsets.symmetric(vertical: 7),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(width: 10,),
                          Icon(Icons.directions, size: 40, color:style.colorScheme[0]),
                          SizedBox(width: 10,),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                            Text("Home", style: TextStyle(fontSize: 19.0, fontWeight: FontWeight.w500),),
                            Text("dazepok dzepdo kezdokazedkapze ", style: TextStyle(fontSize: 15.0, color: Colors.black54),),
                          ],)
                        ],
                      )
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.white),
                          padding: EdgeInsets.all(9),
                          child: InkWell(
                              child: Icon(Icons.public,
                                  color: (_currentMapType == MapType.normal)
                                      ? Colors.black45
                                      : style.colorScheme[1],
                                  size: 20),
                              onTap: () => setState(() {
                                    _currentMapType =
                                        (_currentMapType == MapType.normal)
                                            ? MapType.satellite
                                            : MapType.normal;
                                  }))),
                      Container(
                        margin: EdgeInsets.symmetric(vertical: 14),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.white),
                        padding: EdgeInsets.all(9),
                        child: InkWell(
                          child: Icon(Icons.my_location,
                              color: Colors.black45, size: 20),
                          onTap: () {},
                        ),
                      ),
                      Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              color: style.colorScheme[0],
                              borderRadius: BorderRadius.circular(6)),
                          margin: EdgeInsets.symmetric(vertical: 35),
                          padding: EdgeInsets.symmetric(vertical: 15),
                          child: Text(
                            "Confirmer le lieu de départ",
                            style: TextStyle(fontSize: 19, color: style.colorScheme[3]),
                          ))
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  dynamic _onMapCreated(GoogleMapController contoller) {
    _controller.complete(contoller);
    _mapController = contoller;
    _mapController.setMapStyle(_mapStyle);
    _onAddMarker();
  }

  dynamic _onCameraMove(CameraPosition position) {
    _lastMapPosition = position.target;
  }

  _onMapTypeBtnTapped() {
    setState(() {
      _currentMapType = _currentMapType = (_currentMapType == MapType.normal)
          ? MapType.satellite
          : MapType.normal;
    });
  }

  _onAddMarker() {
    setState(() {
      _markers.add(Marker(
          markerId: MarkerId(_lastMapPosition.toString()),
          position: _lastMapPosition,
          infoWindow: InfoWindow(
              title: "This is a title", snippet: "This is a snippet"),
          icon: BitmapDescriptor.defaultMarker));
    });
  }

  _goToPosition(CameraPosition position) async {
    final GoogleMapController cont = await _controller.future;
    cont.animateCamera(CameraUpdate.newCameraPosition(position));
  }
}
