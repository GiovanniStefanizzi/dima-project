import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dima/models/field_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:dima/firestore/firestore.dart'; 
//import 'package:latlong2/latlong.dart';
import 'package:uuid/uuid.dart';
import 'package:http/http.dart'as http;
import 'package:location/location.dart';


class MapScreen extends StatefulWidget{

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen>{

  final Completer<GoogleMapController> _controller = Completer();
  TextEditingController _searchController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _fieldNameController = TextEditingController();
  final TextEditingController _cropTypeController = TextEditingController();
  bool _frostController = false;
  bool _hailController = false;
  String _sessionToken = Uuid().v4();

  Set<Marker> _markers = Set<Marker>();
  Set<Polygon> _polygons = Set<Polygon>();
  List<LatLng> _polygonLatLongs = <LatLng>[];
  List<dynamic> _placeList = []; 
  Location currentLocation = Location();
  LatLng? currentLatLng;

  int _polygonIdCounter = 1;


  static const CameraPosition _initialPosition = CameraPosition(
    target: LatLng(45.47822174474001, 9.227324251700615),
    zoom:15,
  );

  @override
  void initState() {
    super.initState();
    _searchController.addListener((){
      _onChanged();
      }
    );
    _setMarker(LatLng(45.47822174474001, 9.227324251700615));
    //get postition
    currentLocation.getLocation().then((LocationData value){
      setState(() {
        currentLatLng = LatLng(value.latitude!, value.longitude!);
      });
    });
  }

  _onChanged() {
    if (_sessionToken == null) {
      setState(() {
        _sessionToken = Uuid().v4();
      });
    }
    getSuggestion(_searchController.text);
  }

  void getSuggestion(String input) async {
    String kPLACES_API_KEY = "AIzaSyBgyp5fhb7cpVEWS2cESCVMcRG0d5PwhR4";
    String type = '(regions)';
    String baseURL =
        'https://maps.googleapis.com/maps/api/place/autocomplete/json';
    String request =
        '$baseURL?input=$input&key=$kPLACES_API_KEY&sessiontoken=$_sessionToken';
    var response = await http.get(Uri.parse(request));
    if (response.statusCode == 200) {
      setState(() {
        _placeList = json.decode(response.body)['predictions'];
      });
    } else {
      throw Exception('Failed to load predictions');
    }
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
      fillColor: Colors.green.withOpacity(0.4),));
  }

 bool _isNotSimplePolygon(List<LatLng> polygon){
  if(polygon.length <= 3) {
    return false;
  }

  for(int i = 0; i < polygon.length - 2; i++){
    double x1 = polygon[i].latitude;
    double y1 = polygon[i].longitude;
    double x2 = polygon[i + 1].latitude;
    double y2 = polygon[i + 1].longitude;

    double maxx1 = max(x1, x2), maxy1 = max(y1, y2);
    double minx1 = min(x1, x2), miny1 = min(y1, y2);

    for (int j = i + 2; j < polygon.length; j++) {
      double x21 = polygon[j].latitude;
      double y21 = polygon[j].longitude;
      double x22 = polygon[(j + 1) == polygon.length ? 0 : (j + 1)].latitude;
      double y22 = polygon[(j + 1) == polygon.length ? 0 : (j + 1)].longitude;

      double maxx2 = max(x21, x22), maxy2 = max(y21, y22);
      double minx2 = min(x21, x22), miny2 = min(y21, y22);

      if ((x1 == x21 && y1 == y21) || (x2 == x22 && y2 == y22) || (x1 == x22 && y1 == y22) || (x2 == x21 && y2 == y21)) {
        continue;
      }

      if (minx1 > maxx2 || maxx1 < minx2 || miny1 > maxy2 || maxy1 < miny2) {
        continue;  // The moment when the lines have one common vertex...
      }


      double dx1 = x2-x1, dy1 = y2-y1; // The length of the projections of the first line on the x and y axes
      double dx2 = x22-x21, dy2 = y22-y21; // The length of the projections of the second line on the x and y axes
      double dxx = x1-x21, dyy = y1-y21;

      double div = dy2 * dx1 - dx2 * dy1;
      double mul1 = dx1 * dyy - dy1 * dxx;
      double mul2 = dx2 * dyy - dy2 * dxx;

      if (div == 0) {
        continue; // Lines are parallel...
      }

      if (div > 0) {
        if (mul1 < 0 || mul1 > div) {
          continue; // The first segment intersects beyond its boundaries...
        }
        if (mul2 < 0 || mul2 > div) {
          continue; // // The second segment intersects beyond its borders...
        }
      }
      else{
        if (-mul1 < 0 || -mul1 > -div) {
          continue; // The first segment intersects beyond its boundaries...
        }
        if (-mul2 < 0 || -mul2 > -div) {
          continue; // The second segment intersects beyond its borders...
        }
      }
      return true;
    }
  }
  return false;
}

void _addPoint(LatLng point){
  _setMarker(point);
  _polygonLatLongs.add(point);
  if(_polygons.isEmpty) _setPolygon();         
}

Future<void> _selectDate() async {
  DateTime? picked = await showDatePicker(
    context: context,
    initialDate: DateTime.now(),
    firstDate: DateTime(2000),
    lastDate: DateTime(2300)
    );

    if(picked!=null){
      setState(() {
        _dateController.text = picked.toString().split(" ")[0];
      });
    }
}

Future<void> _createField() async {
    String name = _fieldNameController.text;
    String cropType = _cropTypeController.text;
    String datePlanted = _dateController.text;
    bool hailAlert = _hailController;
    bool frostAlert = _frostController;
    List<GeoPoint> points = _convertToGeoPoint(_polygonLatLongs);
    Field_model field=Field_model(name: name , cropType: cropType, datePlanted: datePlanted, hailAlert: hailAlert, frostAlert: frostAlert, points: points);
    await Firestore().writeField(field.toMap());
  }

  List<GeoPoint> _convertToGeoPoint(List<LatLng> points){
    List<GeoPoint> geoPoints = <GeoPoint>[];
    for(LatLng point in points){
      geoPoints.add(GeoPoint(point.latitude, point.longitude));
    }
    return geoPoints;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        child: Column(
          
          children: [
            AppBar(
              title: const Text('Map')
            ),
            Container(
              height: 500,
              child:
                Stack(
                  children: [   
                    
                    currentLatLng == null ? Container(child:CircularProgressIndicator()) : 
                    GoogleMap(
                      gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>[
                                              new Factory<OneSequenceGestureRecognizer> (() => new EagerGestureRecognizer(),),
                                            ].toSet(),

                    initialCameraPosition: CameraPosition(target:  currentLatLng!, zoom: 15),
                    
                    onMapCreated: (GoogleMapController controller)
                    {
                      _controller.complete(controller);
                    },
                    mapType: MapType.hybrid,
                    markers: _markers,
                    polygons: _polygons,
                    onTap: (point){ 
                      _addPoint(point);
                    },
                    ),

                    // Positioned(
                    //   child:
                    //     Container( 
                    //       margin: const EdgeInsets.all(20),
                    //       child:
                    //         Column(
                    //           children:[
                    //             Container(
                    //               child: TextField(
                    //                 controller: _searchController,
                    //                 decoration: InputDecoration(
                    //                   hintText: 'Search',
                    //                   filled: true,
                    //                   fillColor: Colors.white,
                    //                   contentPadding: EdgeInsets.all(10),
                    //                   border: InputBorder.none,
                    //                   enabledBorder: OutlineInputBorder(
                    //                     borderRadius: BorderRadius.circular(20),
                    //                     borderSide: BorderSide(color: Colors.grey),
                    //                   ),
                    //                   focusedBorder: OutlineInputBorder(
                    //                     borderRadius: BorderRadius.circular(20),
                    //                     borderSide: BorderSide(color: Colors.grey),
                    //                   ),
                    //                   suffixIcon: Icon(Icons.search),
                    //                   ),
                    //                 ),
                    //             ),
                    //             Container(
                    //               height: 400,
                    //               width: 400,
                    //               child: ListView.builder(
                    //                 shrinkWrap: true,
                    //                 itemCount: _placeList.length,
                    //                 itemBuilder: (context, index){
                    //                   return Container(
                    //                     color: Colors.white,
                    //                     child: ListTile(
                    //                       tileColor: Colors.white,
                    //                       title: Text(_placeList[index]['description']),
                    //                       onTap: (){
                    //                         _searchController.text = _placeList[index]['description'];
                    //                         _placeList = [];
                    //                       },
                    //                     ),
                    //                   );
                    //                 },
                    //               ),
                    //             ),
                    //           ]
                    //         ),
                    //     ),
                    // ),
                    Positioned(
                      bottom: 30,
                      left: 15,
                      child: FloatingActionButton(onPressed:(){
                        setState(() {
                          if(_polygonLatLongs.isNotEmpty) {
                            _polygonLatLongs.removeLast();
                            if(_polygonLatLongs.isEmpty){
                              _polygons.remove(_polygons.elementAt(0));
                            }
                          }
                        });
                      },
                      child: const Icon(
                        Icons.arrow_back,
                      ),
                      ),
                    )
                  ]
                ),
            ),
            Container(
              height: 600,
              padding: EdgeInsets.all(30),
              child: Column(
                children: [
                  const Align(
                    alignment: Alignment(-0.92,0),
                    child: Text(
                      "Field name:",
                      textAlign:TextAlign.right,
                      ),
                  ),
                  const SizedBox(height: 5),
                  Form(child:
                    TextField(
                      controller: _fieldNameController,
                      decoration: InputDecoration(
                        hintText: 'Field name',
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
                      ),
                    ),
                  ),
                const SizedBox(height: 20),
                const Align(
                    alignment: Alignment(-0.92,0),
                    child: Text(
                      "Crop type:",
                      textAlign:TextAlign.right,
                      ),
                  ),
                const SizedBox(height: 5),
                  Form(child:
                    TextField(
                      controller: _cropTypeController,
                      decoration: InputDecoration(
                        hintText: 'Crop type',
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
                      ),
                    ),
                  ), 
                  const SizedBox(height: 20),
                const Align(
                    alignment: Alignment(-0.92,0),
                    child: Text(
                      "Seeding date:",
                      textAlign:TextAlign.right,
                      ),
                  ),
                const SizedBox(height: 5),
                  Form(child:
                    TextField(
                      controller: _dateController,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.calendar_month),
                        hintText: 'Seeding date',
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
                      ),
                      readOnly: true,
                      onTap: (){
                        _selectDate();
                      },
                    ),
                  ), 
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Enable frost notification"),
                      Switch(
                        value: _frostController,
                        inactiveTrackColor: Colors.grey,
                        inactiveThumbColor: Color.fromARGB(255, 75, 75, 75),
                        activeTrackColor: Color.fromARGB(255, 153, 208, 3),
                        activeColor: const Color.fromARGB(255, 77, 115, 78),
                        onChanged: (bool value){
                          setState(() {
                            _frostController = value;
                          });
                        }),
                        
                  ],),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween, 
                    children: [
                    const Text("Enable hail notification"),
                    Switch(
                      value: _hailController,
                      inactiveTrackColor: Colors.grey,
                      inactiveThumbColor: Color.fromARGB(255, 75, 75, 75),
                      activeTrackColor: Color.fromARGB(255, 153, 208, 3),
                      activeColor: const Color.fromARGB(255, 77, 115, 78),
                      onChanged: (bool value){
                        setState(() {
                          _hailController = value;
                        });
                      }),
                  

                  ],
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed:(){
                      if (_isNotSimplePolygon(_polygonLatLongs)){
                        print("errorone");
                      }
                      else{
                        _createField();
                      }
                    },
                    child: const Icon(Icons.save),
                  )
                ],
                ),
            )
          ]
        ),
      )
    );
  }

}