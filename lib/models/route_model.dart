import 'package:common_atlas_frontend/models/checkpoint_model.dart';
import 'package:latlong2/latlong.dart';

enum RouteType { scenic, active }

class RouteModel {
  final String id;
  final String name;
  final RouteType type;
  final String distance;
  final String difficulty;
  final int energyCost;
  final List<CheckpointModel> checkpoints;
  final String description;
  final String mapImagePlaceholder;
  final List<LatLng> pathCoordinates;

  RouteModel({
    required this.id,
    required this.name,
    required this.type,
    required this.distance,
    required this.difficulty,
    required this.energyCost,
    required this.checkpoints,
    required this.description,
    required this.mapImagePlaceholder,
    required this.pathCoordinates,
  });
}
