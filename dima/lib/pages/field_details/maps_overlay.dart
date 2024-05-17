import 'package:dima/utils/map_type.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class MapsOverlayPage extends StatefulWidget {
  final Function(MapOverlayType?) updateParentData;

  const MapsOverlayPage({required this.updateParentData});

  @override
  State<MapsOverlayPage> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MapsOverlayPage> {
  MapOverlayType? _mapType;

  void updateParent() {
    widget.updateParentData(_mapType);
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      _mapType = null;
    });
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
                value: null,
                groupValue: _mapType,
                
                onChanged: (value) {
                  setState(() {
                    _mapType = value;
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
                    _mapType = value;
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
                    _mapType = value;
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
                    _mapType = value;
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
                    _mapType = value;
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
                    _mapType = value;
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