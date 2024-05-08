import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dima/api/earthengine/earthengine.dart';
import 'package:dima/models/field_model.dart';
import 'package:dima/utils/field_utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_map/flutter_map.dart';
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
                OverlayImageLayer(
                  overlayImages: [
                    OverlayImage(
                      bounds: getPolygonBounds(field.points),
                      opacity: 0.5,
                      imageProvider: NetworkImage('https://earthengine.googleapis.com/v1/projects/ee-dima/thumbnails/7c7b08b4efabd233486262aff09ca77a-fd2ad11f57cb95c3f4ae4ce17ea82e2e:getPixels'),
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
                  child: Text(
                    "Page $index",
                    style: TextStyle(fontSize: 24),
                  ),
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
      // body: FutureBuilder<String>(
      //   future: getNDVI('http://10.0.2.2:5000/api/ndvi'),
      //   builder: (context, snapshot) {
      //     if (snapshot.connectionState == ConnectionState.waiting) {
      //       return Center(
      //         child: CircularProgressIndicator(),
      //       );
      //     } else if (snapshot.hasError) {
      //       return Center(
      //         child: Text('Error: ${snapshot.error}'),
      //       );
      //     } else {
      //       return Center(
      //         child: Image.network(snapshot.data!),
      //       );
      //     }
      //   },
      // ),
    );
  }
}