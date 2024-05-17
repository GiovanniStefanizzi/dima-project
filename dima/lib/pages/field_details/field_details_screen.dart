import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dima/api/earthengine/earthengine.dart';
import 'package:dima/models/field_model.dart';
import 'package:dima/pages/field_details/maps_overlay.dart';
import 'package:dima/utils/field_utils.dart';
import 'package:dima/utils/map_type.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_map/flutter_map.dart';
//import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';


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
      _mapType = newData;
      print(_mapType);
    });
  }
  Map<MapOverlayType, String> _mapUrls = {
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
    Placeholder(),
    Placeholder(),
    // MeteoPage(),
    // ActivityPage(),
    MapsOverlayPage(updateParentData: updateDataFromChild),
  ];
  }

  Future<void> fetchMapUrls() async {
    final Field_model field = ModalRoute.of(context)!.settings.arguments as Field_model;
    final _ndviUrl = await getMap(field.points, MapOverlayType.ndvi);
    // final _ndwiUrl = await getMap(field.points, MapOverlayType.ndwi);
    // final _eviUrl = await getMap(field.points, MapOverlayType.evi);
    // final _saviUrl = await getMap(field.points, MapOverlayType.savi);
    // final _laiUrl = await getMap(field.points, MapOverlayType.lai);
    setState(() {
      _mapUrls[MapOverlayType.ndvi] = _ndviUrl;
      // this._ndwiUrl = _ndwiUrl;
      // this._eviUrl = _eviUrl;
      // this._saviUrl = _saviUrl;
      // this._laiUrl = _laiUrl;
    });
    }

  @override
  Widget build(BuildContext context) {

    final Field_model field = ModalRoute.of(context)!.settings.arguments as Field_model;

    return Scaffold(
      appBar: AppBar(
        title: Text(field.name),
      ),
      body: Column(
        children: [
          Container(
            height: MediaQuery.of(context).size.height*0.4,
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
                _mapUrls[_mapType] == null ? Container(child: CircularProgressIndicator()) :
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
                height: MediaQuery.of(context).size.height * 0.6,
                child: Center(
                  child: _pages[index],
                ),
              );
            },
          ),
        ),
        SizedBox(height: 20),
        Container(
          width: 65,
          height: 20,
          margin: EdgeInsets.only(bottom: 10),
          decoration: BoxDecoration(
            color: Color.fromARGB(255, 235, 229, 229),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                spreadRadius: 5,
                blurRadius: 7,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(3, (index) {
              return Container(
                margin: EdgeInsets.symmetric(horizontal: 5),
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _currentPage == index ? Color.fromARGB(255, 41, 70, 0) : Color.fromARGB(255, 169, 169, 169),
                  boxShadow: field.cropType == 'corn' ? [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.5),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: Offset(0, 3),
                    ),
                  ] : null,
                ),
              );
            }),
          ),
        ),
        ],
      ) ,
    );
  }
}