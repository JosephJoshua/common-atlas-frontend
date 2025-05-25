import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../../models/route_model.dart';
import '../../models/checkpoint_model.dart';
import '../../providers/route_provider.dart';
import '../../providers/user_provider.dart';
import '../../app.dart'; // For MainScreen navigation
import 'package:common_atlas_frontend/widgets/app_drawer.dart';

class ActiveRouteScreen extends StatefulWidget {
  const ActiveRouteScreen({super.key});

  @override
  State<ActiveRouteScreen> createState() => _ActiveRouteScreenState();
}

class _ActiveRouteScreenState extends State<ActiveRouteScreen> {
  void _showCheckpointDialog(BuildContext context, CheckpointModel checkpoint) {
    final routeProvider = Provider.of<RouteProvider>(context, listen: false);
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    // Do not show dialog if checkpoint is already completed
    if (checkpoint.status == CheckpointStatus.completed) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("${checkpoint.name} is already completed."),
          duration: const Duration(seconds: 2),
        ),
      );
      return;
    }

    showDialog<void>(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text("Minigame: ${checkpoint.gameType.toString().split('.').last.replaceAllMapped(RegExp(r'[A-Z]'), (match) => ' ${match.group(0)}').trim()}"),
          content: SingleChildScrollView(child: Text(checkpoint.gameDescription)),
          actions: <Widget>[
            TextButton(
              child: Text(checkpoint.gameAnswerPlaceholder),
              onPressed: () {
                routeProvider.completeCheckpoint(checkpoint.id);
                Navigator.of(dialogContext).pop(); // Close the dialog

                if (routeProvider.areAllCheckpointsInActiveRouteCompleted()) {
                  userProvider.addPoints(50); // Mock points award
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Route Completed! +50 Points. Well done!"),
                      duration: Duration(seconds: 3),
                    ),
                  );
                  // Optional: After a short delay, navigate back to RoutesPage
                  // Future.delayed(const Duration(seconds: 3), () {
                  //   if (mounted) { // Ensure widget is still in tree
                  //     routeProvider.clearActiveRoute();
                  //     Navigator.pop(context); // Back to RoutesPage
                  //   }
                  // });
                }
              },
            ),
            TextButton(
              child: const Text("Cancel"),
              onPressed: () {
                Navigator.of(dialogContext).pop(); // Close the dialog
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final routeProvider = Provider.of<RouteProvider>(context);
    final activeRoute = routeProvider.activeRoute;

    if (activeRoute == null) {
      return Scaffold(
        appBar: AppBar(title: const Text("Error")),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("No active route selected."),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (Navigator.canPop(context)) {
                    Navigator.pop(context);
                  }
                },
                child: const Text("Go to Routes Page"),
              )
            ],
          ),
        ),
      );
    }

    List<Marker> checkpointMarkers = activeRoute.checkpoints.asMap().entries.map((entry) {
      int index = entry.key;
      CheckpointModel checkpoint = entry.value;
      LatLng position = LatLng(42.3600 + (index * 0.001), -71.0580 + (index * 0.001));

      return Marker(
        point: position,
        width: 80,
        height: 80,
        child: GestureDetector(
          onTap: () {
            _showCheckpointDialog(context, checkpoint);
          },
          child: Tooltip(
            message: "${checkpoint.name}\nStatus: ${checkpoint.status.toString().split('.').last}",
            child: Icon(
              Icons.location_on,
              color: checkpoint.status == CheckpointStatus.completed ? Colors.grey : Theme.of(context).colorScheme.primary,
              size: 40,
            ),
          ),
        ),
      );
    }).toList();

    Marker userLocationMarker = Marker(
      point: LatLng(42.3580, -71.0590),
      width: 80,
      height: 80,
      child: Tooltip(
        message: "You are here (Mock)",
        child: Icon(Icons.person_pin_circle, color: Theme.of(context).colorScheme.secondary, size: 50),
      ),
    );

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () {
            Scaffold.of(context).openDrawer();
          },
        ),
        title: Text(activeRoute.name),
        actions: [
          IconButton(
            icon: const Icon(Icons.help_outline),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text("Route Information"),
                  content: Text(Provider.of<RouteProvider>(context, listen: false).activeRoute?.description ?? "No specific information available for this route."),
                  actions: [TextButton(child: const Text("OK"), onPressed: () => Navigator.of(context).pop())],
                ),
              );
            },
          ),
        ],
      ),
      drawer: const AppDrawer(),
      body: FlutterMap(
        options: MapOptions(
          initialCenter: LatLng(42.361145, -71.057083),
          initialZoom: 14.0,
          interactiveFlags: InteractiveFlag.all,
        ),
        children: [
          Container(color: Colors.green[100]),
          PolylineLayer(
            polylines: [
              Polyline(
                points: [
                  LatLng(42.3600, -71.0580),
                  LatLng(42.3605, -71.0570),
                  LatLng(42.3610, -71.0585),
                  LatLng(42.3615, -71.0575),
                ],
                strokeWidth: 4.0,
                color: Colors.blue.withOpacity(0.7),
              ),
            ],
          ),
          MarkerLayer(
            markers: [...checkpointMarkers, userLocationMarker],
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.map_outlined), label: 'Map'),
          BottomNavigationBarItem(icon: Icon(Icons.list_alt_outlined), label: 'Routes'),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'Profile'),
        ],
        currentIndex: 0, // Map is always the "active" context here
        onTap: (index) {
          if (index == 0) {
            // Already on map, no action or refresh map data if needed
          } else if (index == 1) { // Routes List
            Provider.of<RouteProvider>(context, listen: false).clearActiveRoute();
            if (Navigator.canPop(context)) {
                 Navigator.pop(context); // Go back to MainScreen (which shows RoutesPage)
            } else {
                 Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => const MainScreen(initialPageIndex: 0)), // Routes is index 0
                    (route) => false, 
                 );
            }
          } else if (index == 2) { // Profile
            Provider.of<RouteProvider>(context, listen: false).clearActiveRoute(); // Clean up
            Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => const MainScreen(initialPageIndex: 3)), // Profile is index 3
              (route) => false, 
            );
          }
        },
      ),
    );
  }
}
