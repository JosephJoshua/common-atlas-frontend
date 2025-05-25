import 'package:latlong2/latlong.dart';

class Destination {
  final String id;
  final String name;
  final LatLng position;
  final String snippet;
  final int pointsOnArrival;
  final String gameType;

  Destination({
    required this.id,
    required this.name,
    required this.position,
    required this.snippet,
    this.pointsOnArrival = 10,
    this.gameType = 'explore',
  });
}
