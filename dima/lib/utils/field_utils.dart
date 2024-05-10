import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Field_utils{
  static GeoPoint getCentroid(List<GeoPoint> points) {
    double x = 0;
    double y = 0;
    for (GeoPoint point in points) {
      x += point.latitude;
      y += point.longitude;
    }
    x /= points.length;
    y /= points.length;
    return GeoPoint(x, y);
  }

  static LatLngBounds getPolygonBounds(List<GeoPoint> points) {
    double minLat = points[0].latitude;
    double maxLat = points[0].latitude;
    double minLng = points[0].longitude;
    double maxLng = points[0].longitude;

    for (GeoPoint point in points) {
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
      southwest: LatLng(minLat, minLng),
      northeast: LatLng(maxLat, maxLng),
    );
  }

  static double calculateZoomLevel(List<GeoPoint> points, BuildContext context) {
    LatLngBounds bounds = getPolygonBounds(points);
    const double padding = 50.0; // Adjust as needed

    // Get screen dimensions
    double screenWidth = MediaQuery.of(context).size.width - 2 * padding;
    double screenHeight = MediaQuery.of(context).size.height - 2 * padding;

    // Calculate zoom level to fit the entire polygon within the map viewport
    double eastLng = bounds.northeast.longitude;
    double westLng = bounds.southwest.longitude;
    double northLat = bounds.northeast.latitude;
    double southLat = bounds.southwest.latitude;

    double lngDiff = (eastLng - westLng).abs();
    double latDiff = (northLat - southLat).abs();

    double zoom = 0.0;

    // Calculate zoom level based on longitude
    if (lngDiff != 0) {
      double lngZoom = log(360 / lngDiff) / log(2);
      zoom = lngZoom;
    }

    // Calculate zoom level based on latitude
    if (latDiff != 0) {
      double latZoom = log(180 / latDiff) / log(2);
      zoom = min(zoom, latZoom);
    }

    // Adjust zoom level based on screen dimensions
    double lngZoomScale = screenWidth / 256.0;
    double latZoomScale = screenHeight / 256.0;
    double zoomScale = min(lngZoomScale, latZoomScale);
    zoom -= log(zoomScale) / log(2);

    return zoom;
  }

  static String encodeGeoPoints(List<GeoPoint> points) {
    List<String> coordinates = points.map((point) => '${point.longitude},${point.latitude}').toList();
    return coordinates.join('|');
  }
}