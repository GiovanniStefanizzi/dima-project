import 'package:dima/utils/map_type.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class MapsOverlayPage extends StatefulWidget {
  const MapsOverlayPage({super.key});

  @override
  State<MapsOverlayPage> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MapsOverlayPage> {
  MapOverlayType? _mapType;
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Row(
            children: [
              Text('ndvi'),
              Radio(
                value: MapOverlayType.ndvi,
                groupValue: _mapType,
                onChanged: (value) {
                  setState(() {
                    _mapType = value;
                  });
                },
              ),
            ],
          ),
          Row(
            children: [
              Text('ndwi'),
              Radio(
                value: MapOverlayType.ndwi,
                groupValue: _mapType,
                onChanged: (value) {
                  setState(() {
                    _mapType = value;
                  });
                },
              ),
            ],
          ),
          Row(
            children: [
              Text('evi'),
              Radio(
                value: MapOverlayType.evi,
                groupValue: _mapType,
                onChanged: (value) {
                  setState(() {
                    _mapType = value;
                  });
                },
              ),
            ],
          ),
          Row(
            children: [
              Text('savi'),
              Radio(
                value: MapOverlayType.savi,
                groupValue: _mapType,
                onChanged: (value) {
                  setState(() {
                    _mapType = value;
                  });
                },
              ),
            ],
          ),
          Row(
            children: [
              Text('lai'),
              Radio(
                value: MapOverlayType.lai,
                groupValue: _mapType,
                onChanged: (value) {
                  setState(() {
                    _mapType = value;
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