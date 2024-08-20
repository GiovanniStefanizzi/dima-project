import 'package:dima/utils/map_type.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapsOverlayPage extends StatefulWidget {
  final Function(MapOverlayType) updateParentData;
  
  final MapOverlayType startingType;

  const MapsOverlayPage({required this.updateParentData, required this.startingType});

  @override
  State<MapsOverlayPage> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MapsOverlayPage> {
  //get startingType frome the state
  late MapOverlayType _mapType;


  void updateParent() {
    widget.updateParentData(_mapType);
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      _mapType = widget.startingType;
    });
    //print(_mapType);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        width: MediaQuery.of(context).size.width*0.9,
        //height: MediaQuery.of(context).size.height,
        
        child: Column(
          children: [
            Row(
              
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('NORMAL'),
                Radio(
                  value: MapOverlayType.normal,
                  groupValue: _mapType,
                  
                  onChanged: (value) {
                    setState(() {
                      _mapType = value!;
                      updateParent();
                    });
                  },
                ),
              ],
            ),
            //Divider(
            //  color: Colors.grey,
            //  thickness: 1,
            //),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('NDVI'),
                Row(
                  children: [
                    Tooltip(
                      message: 'Normalized Difference Vegetation Index',
                      child: const Icon(Icons.info_outline, color: Colors.blue)
                    ),
                    Radio(
                      value: MapOverlayType.ndvi,
                      groupValue: _mapType,
                      onChanged: (value) {
                        setState(() {
                          _mapType = value!;
                          updateParent();
                        });
                      },
                    ),
                  ],
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('NDWI'),
                Row(
                  children: [
                    const Icon(Icons.info_outline, color: Colors.blue),
                    Radio(
                      value: MapOverlayType.ndwi,
                      groupValue: _mapType,
                      onChanged: (value) {
                        setState(() {
                          _mapType = value!;
                          updateParent();
                        });
                      },
                    ),
                  ],
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('EVI'),
                Row(
                  children: [
                    const Icon(Icons.info_outline, color: Colors.blue),
                    Radio(
                      value: MapOverlayType.evi,
                      groupValue: _mapType,
                      onChanged: (value) {
                        setState(() {
                          _mapType = value!;
                          updateParent();
                        });
                      },
                    ),
                  ],
                ),
                
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('SAVI'),
                Row(
                  children: [
                    const Icon(Icons.info_outline, color: Colors.blue),
                    Radio(
                      value: MapOverlayType.savi,
                      groupValue: _mapType,
                      onChanged: (value) {
                        setState(() {
                          _mapType = value!;
                          updateParent();
                        });
                      },
                    ),
                  ],
                ),
                
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('LAI'),
                Row(
                  children: [
                    const Icon(Icons.info_outline, color: Colors.blue),
                    Radio(
                      value: MapOverlayType.lai,
                      groupValue: _mapType,
                      onChanged: (value) {
                        setState(() {
                          _mapType = value!;
                          updateParent();
                        });
                      },
                    ),
                  ],
                ),
                
              ],
            ),
          ],
        ),
      ),
    );
  }
}