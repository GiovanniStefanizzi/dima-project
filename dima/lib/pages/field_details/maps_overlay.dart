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
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    bool useMobileLayout = screenWidth < 600;

    if (useMobileLayout) {
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
                      const Tooltip(
                        triggerMode:TooltipTriggerMode.tap,
                        message: 'Normalized Difference Vegetation Index',
                        child: Icon(Icons.info_outline, color: Colors.blue)
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
                      const Tooltip(
                        triggerMode:TooltipTriggerMode.tap,
                        message: 'Normalized Difference Water Index',
                        child: Icon(Icons.info_outline, color: Colors.blue)
                      ),
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
                      const Tooltip(
                        triggerMode:TooltipTriggerMode.tap,
                        message: 'Enhanced Vegetation Index',
                        child: Icon(Icons.info_outline, color: Colors.blue)
                      ),
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
                      const Tooltip(
                        triggerMode:TooltipTriggerMode.tap,
                        message: 'Soil Adjusted Vegetation Index',
                        child: Icon(Icons.info_outline, color: Colors.blue)
                      ),
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
                      const Tooltip(
                        triggerMode:TooltipTriggerMode.tap,
                        message: 'Leaf Area Index',
                        child: Icon(Icons.info_outline, color: Colors.blue)
                      ),
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
    else {

      //TABLET LAYOUT


      return SingleChildScrollView(
        child: Container(
          //margin on left and right
          margin: EdgeInsets.only(left: MediaQuery.of(context).size.width*0.03, right: MediaQuery.of(context).size.width*0.03),
          width: MediaQuery.of(context).size.width*0.9,
          height: MediaQuery.of(context).size.height*0.55,
          
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('NORMAL', style: TextStyle(fontSize: screenHeight*0.02)),
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
                  Text('NDVI', style: TextStyle(fontSize: screenHeight*0.02)),
                  Row(
                    children: [
                      const Tooltip(
                        triggerMode:TooltipTriggerMode.tap,
                        message: 'Normalized Difference Vegetation Index',
                        child: Icon(Icons.info_outline, color: Colors.blue)
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
                  Text('NDWI', style: TextStyle(fontSize: screenHeight*0.02)),
                  Row(
                    children: [
                      const Tooltip(
                        triggerMode:TooltipTriggerMode.tap,
                        message: 'Normalized Difference Water Index',
                        child: Icon(Icons.info_outline, color: Colors.blue)
                      ),
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
                  Text('EVI', style: TextStyle(fontSize: screenHeight*0.02)),
                  Row(
                    children: [
                      const Tooltip(
                        triggerMode:TooltipTriggerMode.tap,
                        message: 'Enhanced Vegetation Index',
                        child: Icon(Icons.info_outline, color: Colors.blue)
                      ),
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
                  Text('SAVI', style: TextStyle(fontSize: screenHeight*0.02)),
                  Row(
                    children: [
                      const Tooltip(
                        triggerMode:TooltipTriggerMode.tap,
                        message: 'Soil Adjusted Vegetation Index',
                        child: Icon(Icons.info_outline, color: Colors.blue)
                      ),
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
                  Text('LAI', style: TextStyle(fontSize: screenHeight*0.02)),
                  Row(
                    children: [
                      const Tooltip(
                        triggerMode:TooltipTriggerMode.tap,
                        message: 'Leaf Area Index',
                        child: Icon(Icons.info_outline, color: Colors.blue)
                      ),
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
}