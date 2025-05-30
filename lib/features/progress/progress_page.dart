import 'package:common_atlas_frontend/widgets/app_drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';

import '../../models/checkpoint_model.dart';
import '../../models/route_model.dart';
import '../../providers/route_provider.dart';
import '../../providers/user_provider.dart';

class ProgressPage extends StatefulWidget {
  const ProgressPage({super.key});

  @override
  State<ProgressPage> createState() => _ProgressPageState();
}

class _ProgressPageState extends State<ProgressPage> {
  late MapController _mapController;

  @override
  void initState() {
    super.initState();
    _mapController = MapController();

    final routeProvider = Provider.of<RouteProvider>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _fitMapToAllRoutes(routeProvider.availableRoutes);
      }
    });
  }

  void _fitMapToAllRoutes(List<RouteModel> allRoutes) {
    List<LatLng> allPoints = [];
    if (allRoutes.isEmpty) {
      if (mounted) {
        _mapController.move(const LatLng(42.3601, -71.0589), 11.0);
      }
      return;
    }

    for (var route in allRoutes) {
      if (route.pathCoordinates.isNotEmpty) {
        allPoints.addAll(route.pathCoordinates);
      } else {
        allPoints.addAll(route.checkpoints.map((cp) => cp.position));
      }
    }

    if (allPoints.isNotEmpty && mounted) {
      var bounds = LatLngBounds.fromPoints(allPoints);
      _mapController.fitCamera(
        CameraFit.bounds(bounds: bounds, padding: const EdgeInsets.all(30.0)),
      );
    } else if (mounted) {
      _mapController.move(const LatLng(42.3601, -71.0589), 11.0);
    }
  }

  @override
  Widget build(BuildContext context) {
    final routeProvider = Provider.of<RouteProvider>(context);
    final allRoutes = routeProvider.availableRoutes;
    final userProvider = Provider.of<UserProvider>(context);

    int totalCheckpoints = 0;
    int completedCheckpoints = 0;

    for (var route in allRoutes) {
      totalCheckpoints += route.checkpoints.length;
      for (var checkpoint in route.checkpoints) {
        if (checkpoint.status == CheckpointStatus.completed) {
          completedCheckpoints++;
        }
      }
    }

    final double completionPercentage =
        totalCheckpoints > 0 ? (completedCheckpoints / totalCheckpoints * 100) : 0;

    return Scaffold(
      drawer: const AppDrawer(),
      body: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(initialCenter: const LatLng(42.3601, -71.0589), initialZoom: 11.0),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'common_atlas_frontend',
              ),

              PolylineLayer(
                polylines:
                    allRoutes.map((route) {
                      bool isRouteCompleted =
                          route.checkpoints.isNotEmpty &&
                          route.checkpoints.every((cp) => cp.status == CheckpointStatus.completed);
                      return Polyline(
                        points:
                            route.pathCoordinates.isNotEmpty
                                ? route.pathCoordinates
                                : route.checkpoints.map((cp) => cp.position).toList(),
                        strokeWidth: isRouteCompleted ? 4.5 : 3.0,
                        color:
                            isRouteCompleted
                                ? Theme.of(context).colorScheme.primary.withOpacity(0.9)
                                : Colors.grey.withOpacity(0.6),
                      );
                    }).toList(),
              ),

              MarkerLayer(
                markers:
                    allRoutes.expand((route) {
                      return route.checkpoints.map((checkpoint) {
                        return Marker(
                          width: 20.0,
                          height: 20.0,
                          point: checkpoint.position,
                          child: Icon(
                            checkpoint.status == CheckpointStatus.completed
                                ? Icons.check_circle
                                : Icons.radio_button_unchecked_outlined,
                            color:
                                checkpoint.status == CheckpointStatus.completed
                                    ? (Colors.green[700] ?? Colors.green)
                                    : (Colors.red[400] ?? Colors.red),
                            size: checkpoint.status == CheckpointStatus.completed ? 12.0 : 10.0,
                          ),
                        );
                      });
                    }).toList(),
              ),
            ],
          ),

          Positioned(
            top: 20,
            left: 20,
            child: Container(
              padding: const EdgeInsets.all(12.0),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.85),
                borderRadius: BorderRadius.circular(12.0),
                boxShadow: [
                  BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 4, spreadRadius: 1),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Legend",
                    style: Theme.of(
                      context,
                    ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(
                        Icons.timeline,
                        color: Theme.of(context).colorScheme.primary.withOpacity(0.9),
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text("Completed Route Path", style: Theme.of(context).textTheme.bodyMedium),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.timeline, color: Colors.grey.withOpacity(0.6), size: 20),
                      const SizedBox(width: 8),
                      Text("Pending Route Path", style: Theme.of(context).textTheme.bodyMedium),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(
                        Icons.check_circle,
                        color: (Colors.green[700] ?? Colors.green),
                        size: 12,
                      ),
                      const SizedBox(width: 8),
                      Text("Completed Checkpoint", style: Theme.of(context).textTheme.bodyMedium),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(
                        Icons.radio_button_unchecked_outlined,
                        color: (Colors.red[400] ?? Colors.red),
                        size: 10,
                      ),
                      const SizedBox(width: 8),
                      Text("Pending Checkpoint", style: Theme.of(context).textTheme.bodyMedium),
                    ],
                  ),
                ],
              ),
            ),
          ),

          Positioned(
            bottom: 20,
            right: 20,
            child: Container(
              padding: const EdgeInsets.all(12.0),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.85),
                borderRadius: BorderRadius.circular(12.0),
                boxShadow: [
                  BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 4, spreadRadius: 1),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Total Points: ${userProvider.userProfile.points}",
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurface.withOpacity(0.8),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Overall Completion: ${completionPercentage.toStringAsFixed(0)}%",
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurface.withOpacity(0.8),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
