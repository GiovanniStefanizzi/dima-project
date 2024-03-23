import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapScreen extends StatefulWidget{

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen>{

  final Completer<GoogleMapController> _controller = Completer();
  final TextEditingController _dataController = TextEditingController();


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
  if(_isNotSimplePolygon(_polygonLatLongs)){
    print("errore!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!");
    _polygonLatLongs.removeLast();
    }
  else{
    _setPolygon();
    }                 
}

Future<void> _selectDate() async {
  DateTime? picked = await showDatePicker(
    context: context,
    firstDate: DateTime(2000),
    lastDate: DateTime(2300)
    );

    if(picked!=null){
      setState(() {
        _dataController.text = picked.toString().split(" ")[0];
      });
    }
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
                      _addPoint(point);
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
                    Positioned(
                      bottom: 30,
                      left: 15,
                      child: FloatingActionButton(onPressed:(){
                        setState(() {
                          _polygonLatLongs.removeLast();
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
                      controller: _dataController,
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
                ],
                ),
            )
          ]
        ),
      )
    );
  }

}