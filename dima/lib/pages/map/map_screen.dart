import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapScreen extends StatefulWidget{

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen>{

  final Completer<GoogleMapController> _controller = Completer();


  Set<Marker> _markers = Set<Marker>();
  Set<Polygon> _polygons = Set<Polygon>();
  List<LatLng> _polygonLatLongs = <LatLng>[];

  int _polygonIdCounter = 1;


  static const CameraPosition _initialPosition = CameraPosition(
    target: LatLng(45.47822174474001, 9.227324251700615),
    zoom:15,
  );

  @override
  void initState() {
    super.initState();

    _setMarker(LatLng(45.47822174474001, 9.227324251700615));
  }

  void _setMarker(LatLng point){
    setState(() {
      _markers.add(
        Marker(
          markerId:MarkerId('marker'), 
          position: point,)
      );
    });
  }

  void _setPolygon(){
    final String polygonIdVal = 'polygon_$_polygonIdCounter';
    _polygonIdCounter++;

    _polygons.add(Polygon(
      polygonId: PolygonId(polygonIdVal),
      points: _polygonLatLongs,
      strokeWidth: 2,
      fillColor: Colors.green.withOpacity(0.2),));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          
          children: [
            AppBar(
              title: Text('Map')
            ),
            Container(
              height: 500,
              child:
                Stack(
                  children: [   
                    
                    GoogleMap(
                    initialCameraPosition: _initialPosition,
                    onMapCreated: (GoogleMapController controller)
                    {
                      _controller.complete(controller);
                    },
                    mapType: MapType.hybrid,
                    markers: _markers,
                    polygons: _polygons,
                    onTap: (point){
                      _setMarker(point);
                      _polygonLatLongs.add(point);
                      _setPolygon();
                    },
                    ),
                    Positioned(
                      child:
                        Container( 
                          margin: const EdgeInsets.all(20),
                          child:
                            Row(
                              children:[
                                Expanded(
                                  child: TextField(
                                    decoration: InputDecoration(
                                      hintText: 'Search',
                                      filled: true,
                                      fillColor: Colors.white,
                                      contentPadding: EdgeInsets.all(10),
                                      border: InputBorder.none,
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(20),
                                        borderSide: BorderSide(color: Colors.grey),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(20),
                                        borderSide: BorderSide(color: Colors.grey),
                                      ),
                                      suffixIcon: Icon(Icons.search),
                                      ),
                                    ),
                                ),
                              ]
                            ),
                        ),
                    ),
                  
                  ]
                ),
            ),
          ]
        )
      )
    );
  }

}