import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:async';
import 'package:provider/provider.dart';
import '../../providers/route_provider.dart';
import '../../models/route_model.dart';
import '../../models/checkpoint_model.dart';
import '../../providers/user_provider.dart'; // Added for UserProvider

/// The main map page of the application.
///
/// Displays a map with the user's current location, an active route (if any),
/// and checkpoints. Allows interaction with checkpoints to complete minigames.
class HomeMapPage extends StatefulWidget {
  const HomeMapPage({super.key});

  @override
  State<HomeMapPage> createState() => _HomeMapPageState();
}

class _HomeMapPageState extends State<HomeMapPage> {
  /// Controller for interacting with the FlutterMap instance.
  late MapController _mapController;

  /// The current geographical center of the map. Defaults to Boston.
  LatLng _currentCenter = const LatLng(42.3601, -71.0589);
  /// The current zoom level of the map.
  double _currentZoom = 13.0;

  /// The user's current GPS location. Null if location is not available or permission denied.
  LatLng? _currentUserLocation;
  /// Subscription to the stream of user's position updates from Geolocator.
  StreamSubscription<Position>? _positionStreamSubscription;
  /// Flag indicating whether location permission has been granted.
  bool _locationPermissionGranted = false;
  /// Flag indicating if the app is currently trying to fetch the user's location.
  bool _isLoadingLocation = true;
  /// Flag to ensure that the map fitting logic for an active route is attempted only once per route.
  ///
  /// This prevents the map from repeatedly trying to fit the route if the user manually
  /// pans or zooms after the initial fit. It's reset when the active route is cleared.
  bool _routeFitAttempted = false;

  @override
  void initState() {
    super.initState();
    _mapController = MapController();
    _checkAndRequestLocationPermission();
  }

  @override
  void dispose() {
    _positionStreamSubscription?.cancel();
    super.dispose();
  }

  /// Checks for location service availability and then requests location permission.
  ///
  /// If services are disabled or permissions are denied, it updates the UI
  /// and shows appropriate SnackBars. Otherwise, it proceeds to fetch the current location.
  Future<void> _checkAndRequestLocationPermission() async {
    // Check if location services are enabled on the device
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("Location services are disabled. Please enable them in your device settings.")));
        // Optionally, offer to open location settings:
        // await Geolocator.openLocationSettings();
      }
      if (mounted) { // Ensure mounted before calling setState
        setState(() {
          _isLoadingLocation = false;
          _locationPermissionGranted = false; // Explicitly set false as services are off
        });
      }
      return;
    }

    // Request location permission from the user.
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) { // User denied permission
        if (mounted) { 
          setState(() {
            _locationPermissionGranted = false;
            _isLoadingLocation = false;
          });
        }
        if (mounted) { 
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text("Location permission is required to show your position on the map.")));
        }
        return;
      }
    }
    
    if (permission == LocationPermission.deniedForever) { // User denied permission permanently
        if (mounted) { 
          setState(() {
            _locationPermissionGranted = false;
            _isLoadingLocation = false;
          });
        }
        if (mounted) { 
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text("Location permission is permanently denied. Please enable it in app settings.")));
          // Optionally, offer to open app settings:
          // await Geolocator.openAppSettings();
        }
        return;
    }

    // If permissions are granted and services enabled
    if (mounted) { 
      setState(() {
        _locationPermissionGranted = true;
      });
    }
    await _getCurrentLocationAndStartStreaming();
  }

  /// Fetches the current GPS location and then starts streaming location updates.
  ///
  /// If location permission is not granted, this method does nothing.
  /// On successful location fetch, it updates the map center and user location.
  Future<void> _getCurrentLocationAndStartStreaming() async {
    if (!_locationPermissionGranted) return;
    try {
      Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      if (mounted) {
        setState(() {
          _currentUserLocation = LatLng(position.latitude, position.longitude);
          _currentCenter = _currentUserLocation!;
          _mapController.move(_currentUserLocation!, _currentZoom); // Move map to current location
          _isLoadingLocation = false;
        });
      }
      _startLocationStream();
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoadingLocation = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Failed to get current location: $e")));
      }
    }
  }

  /// Starts listening to the stream of location updates from Geolocator.
  ///
  /// Updates `_currentUserLocation` whenever a new position is received.
  /// Requires `_locationPermissionGranted` to be true.
  void _startLocationStream() {
    if (!_locationPermissionGranted) return;
    const LocationSettings locationSettings = LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 10, // Update location if user moves by 10 meters
    );
    _positionStreamSubscription = Geolocator.getPositionStream(locationSettings: locationSettings).listen((Position position) {
      if (mounted) {
        setState(() {
          _currentUserLocation = LatLng(position.latitude, position.longitude);
        });
      }
    });
  }

  /// Adjusts the map camera to fit the active route and the user's current location.
  ///
  /// [route] The active [RouteModel] to display.
  /// [userLocation] The user's current [LatLng] (optional).
  ///
  /// Checkpoints are plotted using mock LatLng positions relative to the user's location
  /// or a default if user location is unavailable, as `CheckpointModel` lacks LatLng.
  void _fitMapToRouteAndUser(RouteModel route, LatLng? userLocation) {
    if (!mounted) return;
    List<LatLng> pointsToFit = [];

    // Add user's location to the list of points to fit, if available.
    if (userLocation != null) {
      pointsToFit.add(userLocation);
    }

    // Add mock checkpoint locations to the list.
    // These positions are derived for demonstration as CheckpointModel lacks actual coordinates.
    for (int i = 0; i < route.checkpoints.length; i++) {
      pointsToFit.add(LatLng(
        (userLocation?.latitude ?? 42.3601) + i * 0.002, // Base latitude or default Boston
        (userLocation?.longitude ?? -71.0589) + i * 0.003 // Base longitude or default Boston
      ));
    }

    if (pointsToFit.isEmpty) {
      // If no points (e.g., route has no checkpoints and no user location),
      // try to center on the first mock checkpoint if available, or do nothing.
      if (route.checkpoints.isNotEmpty) {
        LatLng firstCheckpointPos = LatLng(42.3601, -71.0589); // Default mock position
         _mapController.move(firstCheckpointPos, 14.0);
      }
      return;
    }
    
    if (pointsToFit.length == 1) {
      _mapController.move(pointsToFit.first, 15.0); // Zoom in on a single point (e.g., only user location)
    } else {
      // Fit map to the bounds of all collected points.
      _mapController.fitCamera(
          CameraFit.bounds(
              bounds: LatLngBounds.fromPoints(pointsToFit),
              padding: const EdgeInsets.all(50.0), // Add padding around the bounds
          )
      );
    }
  }

  /// Displays a dialog for interacting with a checkpoint's minigame.
  ///
  /// [context] The build context.
  /// [checkpoint] The [CheckpointModel] to interact with.
  /// [routeProvider] The [RouteProvider] instance for updating checkpoint status.
  ///
  /// If the checkpoint is already completed, a SnackBar is shown. Otherwise,
  /// an AlertDialog is displayed with the minigame details. Completing the minigame
  /// updates its status and awards points if the entire route is finished.
  void _showCheckpointDialog(BuildContext context, CheckpointModel checkpoint, RouteProvider routeProvider) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    // Prevent interaction if checkpoint is already completed.
    if (checkpoint.status == CheckpointStatus.completed) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("${checkpoint.name} is already completed!")),
      );
      return;
    }

    // Show the minigame dialog.
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

                // Check if all checkpoints in the active route are now completed.
                if (routeProvider.activeRoute != null && routeProvider.areAllCheckpointsInActiveRouteCompleted()) {
                  userProvider.addPoints(50); // Award points for route completion.
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Route Completed! +50 Points. Well done!"),
                      duration: Duration(seconds: 3),
                    ),
                  );
                  // Optional: Further actions like clearing the active route.
                  // routeProvider.clearActiveRoute();
                }
              },
            ),
             TextButton( // Added Cancel button for better UX
              child: const Text("Cancel"),
              onPressed: () {
                Navigator.of(dialogContext).pop();
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

    // Fit map to route when it first becomes available or changes
    if (activeRoute != null && !_routeFitAttempted) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _fitMapToRouteAndUser(activeRoute, _currentUserLocation);
        if(mounted){
          setState(() {
            _routeFitAttempted = true;
          });
        }
      });
    } else if (activeRoute == null && _routeFitAttempted) {
      // Reset flag if route is cleared
       if(mounted){
          setState(() {
            _routeFitAttempted = false;
          });
        }
    }


    List<LatLng> routePoints = [];
    if (activeRoute != null && activeRoute.checkpoints.isNotEmpty) {
      routePoints = activeRoute.checkpoints.map((cp) {
        int index = activeRoute.checkpoints.indexOf(cp);
        // Generating mock positions as CheckpointModel doesn't have LatLng
        return LatLng((_currentUserLocation?.latitude ?? 42.3601) + index * 0.002, 
                      (_currentUserLocation?.longitude ?? -71.0589) + index * 0.003);
      }).toList();
    }

    return Scaffold(
      body: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: _currentCenter,
              initialZoom: _currentZoom,
              onPositionChanged: (MapPosition position, bool hasGesture) {
                if (mounted && hasGesture) {
                  setState(() {
                    _currentCenter = position.center ?? _currentCenter;
                    _currentZoom = position.zoom ?? _currentZoom;
                  });
                }
              },
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'common_atlas_frontend',
              ),
              if (activeRoute != null && routePoints.length > 1)
                PolylineLayer(
                  polylines: [
                    Polyline(
                      points: routePoints,
                      strokeWidth: 4.0,
                      color: Colors.deepOrange,
                    ),
                  ],
                ),
              if (activeRoute != null)
                MarkerLayer(
                  markers: activeRoute.checkpoints.map((checkpoint) {
                    int index = activeRoute.checkpoints.indexOf(checkpoint);
                    LatLng checkpointPosition = LatLng(
                        (_currentUserLocation?.latitude ?? 42.3601) + index * 0.002,
                        (_currentUserLocation?.longitude ?? -71.0589) + index * 0.003
                    );

                    return Marker(
                      width: 100.0,
                      height: 100.0,
                      point: checkpointPosition,
                      child: GestureDetector(
                        onTap: () {
                          // routeProvider is in scope from the build method.
                          _showCheckpointDialog(context, checkpoint, routeProvider);
                        },
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              checkpoint.status == CheckpointStatus.completed ? Icons.check_circle : Icons.location_on_sharp,
                              color: checkpoint.status == CheckpointStatus.completed ? Colors.green : Colors.red,
                              size: 35.0,
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 1),
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.5),
                                borderRadius: BorderRadius.circular(3)
                              ),
                              child: Text(
                                checkpoint.name, 
                                style: const TextStyle(fontSize: 10, color: Colors.white, fontWeight: FontWeight.bold), 
                                textAlign: TextAlign.center,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
              if (_currentUserLocation != null)
                MarkerLayer(
                  markers: [
                    Marker(
                      width: 80.0,
                      height: 80.0,
                      point: _currentUserLocation!,
                      child: Icon(Icons.person_pin_circle, color: Colors.blue, size: 40.0),
                    ),
                  ],
                ),
            ],
          ),
          if (_isLoadingLocation)
            const Center(child: CircularProgressIndicator()),
          if (!_locationPermissionGranted && !_isLoadingLocation)
            Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  "Location permission denied. Please enable it in settings to see your location.",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, color: Colors.red[700], backgroundColor: Colors.white70),
                ),
              ),
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (_currentUserLocation != null) {
            _mapController.move(_currentUserLocation!, _currentZoom);
          } else {
            _checkAndRequestLocationPermission();
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Fetching your location... Please ensure permissions are granted.")),
            );
          }
        },
        tooltip: 'My Location',
        child: const Icon(Icons.my_location),
      ),
    );
  }
}
