import 'dart:io';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dima/api/earthengine/earthengine.dart';
import 'package:dima/firestore/firestore.dart';
import 'package:dima/models/field_model.dart';
import 'package:dima/pages/field_details/activity.dart';
import 'package:dima/pages/field_details/maps_overlay.dart';
import 'package:dima/pages/field_list/field_list_screen.dart';
import 'package:dima/utils/field_utils.dart';
import 'package:dima/utils/map_type.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_map/flutter_map.dart';
//import 'package:google_maps_flutter/google_maps_flutter.dart';
//import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';
import 'package:dima/pages/field_details/meteo_details.dart';


class FieldDetailsScreen extends StatefulWidget {
  const FieldDetailsScreen({super.key});

  @override
  State<FieldDetailsScreen> createState() => _FieldDetailsScreenState();
}

class _FieldDetailsScreenState extends State<FieldDetailsScreen> {
  int _currentPage = 0;
  final PageController _pageController = PageController();
  MapOverlayType _mapType = MapOverlayType.normal;
  List<Widget> _pages = [];

  void updateDataFromChild(MapOverlayType newData) {
    setState(() {
      _pages[2]= MapsOverlayPage(updateParentData: updateDataFromChild, startingType: newData);
      _mapType = newData;
      //print(_mapType);
    });
  }
  final Map<MapOverlayType, String> _mapUrls = {
    MapOverlayType.ndvi: '',
    MapOverlayType.ndwi: '',
    MapOverlayType.evi: '',
    MapOverlayType.savi: '',
    MapOverlayType.lai: '',
  };
  
  
  LatLngBounds getPolygonBounds(List<GeoPoint> points) {
    //connvert points to latlng
    List<LatLng> latLngPoints = points.map((point) => LatLng(point.latitude, point.longitude)).toList();
    
    double minLat = latLngPoints[0].latitude;
    double maxLat = latLngPoints[0].latitude;
    double minLng = latLngPoints[0].longitude;
    double maxLng = latLngPoints[0].longitude;

    for (LatLng point in latLngPoints) {
      if (point.latitude < minLat) {
        minLat = point.latitude;
      }
      if (point.latitude > maxLat) {
        maxLat = point.latitude;
      }
      if (point.longitude < minLng) {
        minLng = point.longitude;
      }
      if (point.longitude > maxLng) {
        maxLng = point.longitude;
      }
    }

    return LatLngBounds(
      LatLng(minLat, minLng),
      LatLng(maxLat, maxLng),
    );
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      fetchMapUrls();
    });
    _pages = [
    const MeteoDetailsWidget(),
    ActivityWidget(),
    MapsOverlayPage(updateParentData: updateDataFromChild, startingType: _mapType),
  ];
  }

  Future<void> fetchMapUrls() async {
    final arguments = (ModalRoute.of(context)?.settings.arguments ?? <String, Object>{}) as Map;
    final Field_model field = arguments['field'] as Field_model;
    final ndviUrl = await getMap(field.points, MapOverlayType.ndvi);
    // final _ndwiUrl = await getMap(field.points, MapOverlayType.ndwi);
    // final _eviUrl = await getMap(field.points, MapOverlayType.evi);
    // final _saviUrl = await getMap(field.points, MapOverlayType.savi);
    // final _laiUrl = await getMap(field.points, MapOverlayType.lai);
    setState(() {
      _mapUrls[MapOverlayType.ndvi] = ndviUrl;
      // this._ndwiUrl = _ndwiUrl;
      // this._eviUrl = _eviUrl;
      // this._saviUrl = _saviUrl;
      // this._laiUrl = _laiUrl;
    });
    }

  @override
  Widget build(BuildContext context) {
    final arguments = (ModalRoute.of(context)?.settings.arguments ?? <String, Object>{}) as Map;
    final Field_model field = arguments['field'] as Field_model;
    final int index = arguments['index'] as int;

    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    bool useMobileLayout = screenWidth < 600;

    if(useMobileLayout){
      return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          toolbarHeight: screenHeight*0.07,
          title: Text(field.name, style: TextStyle(fontSize: screenHeight * 0.035),),
          actions: [
            PopupMenuButton <String>(
              onSelected: (value) {handleClick(value, index);},
              itemBuilder: (BuildContext context){
                return{'Delete', 'Change settings'}.map((String choice){
                  return PopupMenuItem<String>(
                    value: choice,
                    child: Text(choice),
                  );
                }).toList();
              },
            )
          ],
        ),
        body: Column(
          children: [
            Container(
              height: MediaQuery.of(context).size.height*0.5,
              child: FlutterMap(
                options: MapOptions(
                  initialCenter: LatLng(Field_utils.getCentroid(field.points).latitude, Field_utils.getCentroid(field.points).longitude),
                  initialZoom: Field_utils.calculateZoomLevel(field.points, context),
                ),
                children: [
                  TileLayer(
                    //isri imagery
                    urlTemplate: "https://mt1.google.com/vt/lyrs=s&x={x}&y={y}&z={z}",
                    userAgentPackageName: 'dima',
                  ),
                  PolygonLayer(polygons: [
                    Polygon(
                      points: field.points.map((point) => LatLng(point.latitude, point.longitude)).toList(),
                      color: Colors.green.withOpacity(0.2),
                      borderStrokeWidth: screenHeight*0.001,
                      borderColor: Colors.black,
                      isFilled: _mapType==MapOverlayType.normal ? true : false,
                    ),
                  ],),
                  _mapUrls[_mapType] == null ? Container() :
                  OverlayImageLayer(
                    overlayImages: [
                      OverlayImage(
                        bounds: getPolygonBounds(field.points),
                        opacity: 0.5,
                        imageProvider: NetworkImage(_mapUrls[_mapType]!),
                      ),
                    ],
                  )
                ],
              ),
            ),
            Expanded(
            child: PageView.builder(
              controller: _pageController,
              scrollDirection: Axis.horizontal,
              itemCount: 3,
              onPageChanged: (int page) {
                setState(() {
                  _currentPage = page;
                });
              },
              itemBuilder: (context, index) {
                return Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height * 0.5,
                  child: Center(
                    child: _pages[index],
                  ),
                );
              },
            ),
          ),
          //SizedBox(height: screenHeight*0.005),
          Container(
            width: screenHeight * 0.1,
            height: screenHeight * 0.02,
            margin: EdgeInsets.only(bottom: screenHeight*0.01),
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 246, 243, 243),
              borderRadius: BorderRadius.circular(20),
            
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(3, (index) {
                return Container(
                  margin: EdgeInsets.symmetric(horizontal: screenHeight*0.005),
                  width: screenHeight*0.01,
                  height: screenHeight*0.02,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _currentPage == index ? const Color.fromARGB(255, 57, 96, 1) : const Color.fromARGB(255, 169, 169, 169),
                    
                  ),
                );
              }),
            ),
          ),
          ],
        ) ,
      );
    }
    else{
      //*********************//

      //TABLET LAYOUT

      //*********************//
      
      return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          shape:const Border(
              bottom: BorderSide(
              color: Color.fromARGB(255, 220, 220, 220),
              width: 1
            ),
          ),
          toolbarHeight: screenHeight*0.07,
          title: Text(field.name, style: TextStyle(fontSize: screenHeight * 0.035),),
          actions: [
            PopupMenuButton <String>(
              onSelected: (value) {handleClick(value, index);},
              itemBuilder: (BuildContext context){
                return{'Delete', 'Change settings'}.map((String choice){
                  return PopupMenuItem<String>(
                    value: choice,
                    child: Text(choice),
                  );
                }).toList();
              },
            )
          ],
        ),
        body: Row(
          children: [
            Container(
              width: MediaQuery.of(context).size.width*0.5,
              child: FlutterMap(
                options: MapOptions(
                  initialCenter: LatLng(Field_utils.getCentroid(field.points).latitude, Field_utils.getCentroid(field.points).longitude),
                  initialZoom: Field_utils.calculateZoomLevel(field.points, context),
                ),
                children: [
                  TileLayer(
                    //isri imagery
                    urlTemplate: "https://mt1.google.com/vt/lyrs=s&x={x}&y={y}&z={z}",
                    userAgentPackageName: 'dima',
                  ),
                  PolygonLayer(polygons: [
                    Polygon(
                      points: field.points.map((point) => LatLng(point.latitude, point.longitude)).toList(),
                      color: Colors.green.withOpacity(0.2),
                      borderStrokeWidth: screenHeight*0.001,
                      borderColor: Colors.black,
                      isFilled: _mapType==MapOverlayType.normal ? true : false,
                    ),
                  ],),
                  _mapUrls[_mapType] == null ? Container() :
                  OverlayImageLayer(
                    overlayImages: [
                      OverlayImage(
                        bounds: getPolygonBounds(field.points),
                        opacity: 0.5,
                        imageProvider: NetworkImage(_mapUrls[_mapType]!),
                      ),
                    ],
                  )
                ],
              ),
            ),
            Expanded(
            child: Column(
              
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.86,
                  child: PageView.builder(
                    controller: _pageController,
                    scrollDirection: Axis.horizontal,
                    itemCount: 3,
                    onPageChanged: (int page) {
                      setState(() {
                        _currentPage = page;
                      });
                    },
                    itemBuilder: (context, index) {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.86,
                            width: MediaQuery.of(context).size.width * 0.5,
                            child: Center(
                              child: _pages[index],
                            ),
                          ),
                          
                        ],
                      );
                    },
                  ),
                ),
                Container(
                  width: screenHeight * 0.1,
                  height: screenHeight * 0.02,
                  //margin: EdgeInsets.only(bottom: screenHeight*0.01),
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 246, 243, 243),
                    borderRadius: BorderRadius.circular(20),
                  
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(3, (index) {
                      return Container(
                        margin: EdgeInsets.symmetric(horizontal: screenHeight*0.005),
                        width: screenHeight*0.01,
                        height: screenHeight*0.02,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: _currentPage == index ? const Color.fromARGB(255, 57, 96, 1) : const Color.fromARGB(255, 169, 169, 169),
                          
                        ),
                      );
            }),
          ),
        ),
              ],
              
            ),
          ),
          //SizedBox(height: screenHeight*0.005),
          ],
        ) ,
      );
    }
  }

  Future<void> handleClick(String value, int index) async {
    switch (value){
      case 'Delete':
          //show alert dialog asking for confirmation to delete
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Delete field'),
                content: Text('Are you sure you want to delete this field?'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () async {
                      //Fdelete field
                      Firestore().removeField(index);
                      await Future.delayed(Duration(seconds: 1));
                      //todo caricatore
                      Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (context) => FieldListScreen()),
                        (Route<dynamic> route) => false,
                      );
                    },
                    child: Text('Delete'),
                  ),
                ],
              );
            },
          );
        break;
      case 'Change settings':
        Field_model fieldModel = await Firestore().getField(index);
        Navigator.pushNamed(context, '/modify_field', arguments: {'index': index,'field': fieldModel});
        break;
    }
  }
}