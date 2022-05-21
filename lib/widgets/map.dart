import "package:flutter/material.dart";
import "package:flutter_map/flutter_map.dart";
import "package:latlong/latlong.dart";
import "package:http/http.dart" as http;
import "dart:convert" as convert;

/**
 * Widget that displays a map and a marker
 */
class MyMap extends StatelessWidget {
  static const String apiKey = "ZwVNqisTHH8Aw7lcgVgNmWkJNCOD4ahd";
  LatLng currentPos;
  LatLng? markerPos;
  double zoom;
  Function fn;
  double? iconSize;
  MyMap(
      {required this.currentPos,
      this.markerPos,
      required this.fn,
      double? zoom,
      double? iconSize})
      : zoom = zoom ?? 13.0,
        iconSize = iconSize ?? 50;

  @override
  Widget build(BuildContext context) {
    return FlutterMap(
      options: new MapOptions(
          center: currentPos, zoom: zoom, onTap: (point) => fn(point)),
      layers: [
        new TileLayerOptions(
          urlTemplate: "https://api.tomtom.com/map/1/tile/basic/main/"
              "{z}/{x}/{y}.png?key=$apiKey",
          additionalOptions: {"apiKey": apiKey},
        ),
        if (markerPos != null)
          MarkerLayerOptions(markers: [
            Marker(
                point: markerPos,
                builder: (ctx) => Icon(
                      Icons.location_on,
                      color: Theme.of(ctx).colorScheme.secondary,
                      size: iconSize,
                    ))
          ])
      ],
    );
  }
}
