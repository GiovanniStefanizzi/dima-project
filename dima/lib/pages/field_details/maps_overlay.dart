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
    print(_mapType);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('normal'),
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
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('ndvi'),
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
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('ndwi'),
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
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('evi'),
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
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('savi'),
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
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('lai'),
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
    );
  }
}