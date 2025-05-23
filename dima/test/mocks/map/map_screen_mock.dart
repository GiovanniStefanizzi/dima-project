import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dima/models/field_model.dart';
import 'package:dima/pages/field_list/field_list_screen.dart';
import 'package:dima/pages/homepage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:dima/firestore/firestore.dart'; 
//import 'package:latlong2/latlong.dart';
//import 'package:uuid/uuid.dart';
import 'package:http/http.dart'as http;

import 'package:location/location.dart';

import '../homepage/homepage_mock.dart';


class MapScreenMock extends StatefulWidget{

  @override
  State<MapScreenMock> createState() => _MapScreenState();

  
}

class _MapScreenState extends State<MapScreenMock>{

  final Completer<GoogleMapController> _controller = Completer();
  TextEditingController _searchController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _fieldNameController = TextEditingController();
  final TextEditingController _cropTypeController = TextEditingController();
  bool _frostController = false;
  bool _hailController = false;
  //String _sessionToken = Uuid().v4();

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
    // _searchController.addListener((){
    //   _onChanged();
    //   }
    // );
    //_setMarker(LatLng(45.47822174474001, 9.227324251700615));
    //get postition
    currentLocation.getLocation().then((LocationData value){
      setState(() {
        currentLatLng = LatLng(value.latitude!, value.longitude!);
      });
    });
  }

  
  
  @visibleForTesting
   void _setMarker(LatLng point){
    setState(() {
      _markers.add(
        Marker(
          markerId:const MarkerId('marker'), 
          position: point,
          )
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
    Field_model field=Field_model(name: name , cropType: cropType, datePlanted: datePlanted, hailAlert: hailAlert, frostAlert: frostAlert, points: points, activities: []);
  }

  List<GeoPoint> _convertToGeoPoint(List<LatLng> points){
    List<GeoPoint> geoPoints = <GeoPoint>[];
    for(LatLng point in points){
      geoPoints.add(GeoPoint(point.latitude, point.longitude));
    }
    return geoPoints;
  }

  
  @visibleForTesting
  LatLng setMarkerAndReturn(){
    _setMarker(LatLng(1, 1));
    return LatLng(1, 1);
  }

  @override
  Widget build(BuildContext context) {

    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    bool useMobileLayout = screenWidth < 600;

    if(useMobileLayout){
      return Scaffold(
        resizeToAvoidBottomInset: true,
        body: SingleChildScrollView(
          child: Column(
            
            children: [
              AppBar(
                toolbarHeight: screenHeight*0.07,
                title: const Text('Map')
              ),
              Container(
                height: screenHeight*0.6,
                child:
                  Stack(
                    children: [   
                      
                      currentLatLng == null ? Stack(
                        children: [
                          Placeholder(),
                          Center(
                            
                            child: const CircularProgressIndicator(),
                          )
                        ],
                      ) :
                      Placeholder(),
                      Positioned(
                        bottom: 30,
                        left: 15,
                        child: FloatingActionButton(
                        backgroundColor:   const Color.fromARGB(255, 153, 194, 162),
                          onPressed:(){
                          setState(() {
                            if(_polygonLatLongs.isNotEmpty) {
                              _polygonLatLongs.removeLast();
                              _markers.remove(_markers.elementAt(_markers.length - 1));
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
                        key: Key('fieldName'),
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
                        key: Key('cropType'),
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
                        key: Key('date'),
                        controller: _dateController,
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.calendar_month, color: const Color.fromARGB(255, 153, 194, 162),),
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
                        //const Text("Enable frost notification"),
                        Switch(
                          key: Key('frost'),
                          value: _frostController,
                          inactiveTrackColor: Colors.grey,
                          inactiveThumbColor: const Color.fromARGB(255, 75, 75, 75),
                          activeTrackColor: const Color.fromARGB(255, 153, 194, 162),
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
                      //const Text("Enable hail notification"),
                      Switch(
                        key: Key('hail'),
                        value: _hailController,
                        inactiveTrackColor: Colors.grey,
                        inactiveThumbColor: Color.fromARGB(255, 75, 75, 75),
                        activeTrackColor: const Color.fromARGB(255, 153, 194, 162),
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
                      key: Key('saveButton'),
                      onPressed:(){
                        _addPoint(LatLng(45.478, 9.230));
                        _addPoint(LatLng(45.475, 9.230));
                        _addPoint(LatLng(45.478, 9.235));
                        if (_isNotSimplePolygon(_polygonLatLongs)){
                          print("errorone");
                        }
                        else{
                          _createField();

                          //sleep(const Duration(seconds: 1));
                          
                          Navigator.push(context, MaterialPageRoute(builder: (context) => const HomepageMock()));                      }
                      },
                      child:  Text(key: Key('ButtonText') ,_isNotSimplePolygon(_polygonLatLongs) ? "Error" : "Save"),
                    )
                  ],
                  ),
              )
            ]
          ),
        )
      );
    }
    else{


      //TABLET LAYOUT
      

      return Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          toolbarHeight: screenHeight*0.07,
          title: const Text('Add field'),
          shape:const Border(
              bottom: BorderSide(
              color: Color.fromARGB(255, 220, 220, 220),
              width: 1
            ),
          ),
        ),
        body: Row(
          
            
            children: [
              Container(
                width: screenWidth*0.6,
                child:
                  Stack(
                    children: [   
                      
                      currentLatLng == null ? const Stack(
                        children: [
                          //GoogleMap(
                          //  
                          //  gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>[new Factory<OneSequenceGestureRecognizer> (() => new EagerGestureRecognizer(),),].toSet(),
                          //  initialCameraPosition: _initialPosition,
                          //  onMapCreated: (GoogleMapController controller)
                          //  {
                          //    _controller.complete(controller);
                          //  },
                          //  mapType: MapType.hybrid,
                          //  markers: _markers,
                          //  polygons: _polygons,
                          //  onTap: (point){ 
                          //    _addPoint(point);
                          //  },
                          //),
                          Center(
                            
                            child: CircularProgressIndicator(),
                          )
                        ],
                      ) :
                      const Placeholder(),
                      //GoogleMap(
                      //  gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>[
                      //                          new Factory<OneSequenceGestureRecognizer> (() => new EagerGestureRecognizer(),),
                      //                        ].toSet(),
//
                      //initialCameraPosition: CameraPosition(target:  currentLatLng!, zoom: 15),
                      //
                      //onMapCreated: (GoogleMapController controller)
                      //{
                      //  _controller.complete(controller);
                      //},
                      //mapType: MapType.hybrid,
                      //markers: _markers,
                      //polygons: _polygons,
                      //onTap: (point){ 
                      //  _addPoint(point);
                      //},
                      //),
                      Positioned(
                        bottom: 30,
                        left: 15,
                        child: FloatingActionButton(
                        backgroundColor:   const Color.fromARGB(255, 153, 194, 162),
                          onPressed:(){
                          setState(() {
                            if(_polygonLatLongs.isNotEmpty) {
                              _polygonLatLongs.removeLast();
                              _markers.remove(_markers.elementAt(_markers.length - 1));
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
              SingleChildScrollView(
                child: Container(
                  width: screenWidth*0.4,
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
                            prefixIcon: Icon(Icons.calendar_month, color: const Color.fromARGB(255, 153, 194, 162),),
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
                      SingleChildScrollView(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              width: screenWidth*0.2,
                              child: const Text("Enable frost notification")
                            ),
                            Switch(
                              value: _frostController,
                              inactiveTrackColor: Colors.grey,
                              inactiveThumbColor: const Color.fromARGB(255, 75, 75, 75),
                              activeTrackColor: const Color.fromARGB(255, 153, 194, 162),
                              activeColor: const Color.fromARGB(255, 77, 115, 78),
                              onChanged: (bool value){
                                setState(() {
                                  _frostController = value;
                                });
                              }),
                              
                        ],),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween, 
                        children: [
                        SizedBox(
                          width: screenWidth*0.2,
                          child: const Text("Enable hail notification")
                        ),
                        Switch(
                          value: _hailController,
                          inactiveTrackColor: Colors.grey,
                          inactiveThumbColor: Color.fromARGB(255, 75, 75, 75),
                          activeTrackColor: const Color.fromARGB(255, 153, 194, 162),
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
                        key: Key('saveButton'),
                        onPressed:(){
                        _addPoint(LatLng(45.478, 9.230));
                        _addPoint(LatLng(45.475, 9.230));
                        _addPoint(LatLng(45.478, 9.235));
                        if (_isNotSimplePolygon(_polygonLatLongs)){
                          print("errorone");
                        }
                        else{
                          _createField();

                          sleep(const Duration(seconds: 1));
                          //todo caricatore
                          //Navigator.of(context).pushAndRemoveUntil(
                          //  MaterialPageRoute(builder: (context) => const Homepage()),
                          //  (Route<dynamic> route) => false,
                          //);
                        }
                      },
                        child:  Text(key: Key('ButtonText') ,_isNotSimplePolygon(_polygonLatLongs) ? "Error" : "Save"),
                      )
                    ],
                    ),
                ),
              )
            ]
          ),
        );
      
    }
  }

}