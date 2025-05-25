import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:async';
import 'package:provider/provider.dart';
import '../../providers/route_provider.dart';
import '../../models/route_model.dart';
import '../../models/checkpoint_model.dart';
import '../../providers/user_provider.dart';

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
  /// The accuracy of the current GPS location in meters.
  double _currentLocationAccuracy = 0.0; 
  /// Subscription to the stream of user's position updates from Geolocator.
  StreamSubscription<Position>? _positionStreamSubscription;
  /// Flag indicating whether location permission has been granted.
  bool _locationPermissionGranted = false;
  /// Flag indicating if the app is currently trying to fetch the user's location.
  bool _isLoadingLocation = true;
  /// Flag to ensure that the map fitting logic for an active route is attempted only once per route.
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
  Future<void> _checkAndRequestLocationPermission() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("Location services are disabled. Please enable them in your device settings.")));
      }
      if (mounted) { 
        setState(() {
          _isLoadingLocation = false;
          _locationPermissionGranted = false; 
        });
      }
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) { 
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
    
    if (permission == LocationPermission.deniedForever) { 
        if (mounted) { 
          setState(() {
            _locationPermissionGranted = false;
            _isLoadingLocation = false;
          });
        }
        if (mounted) { 
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text("Location permission is permanently denied. Please enable it in app settings.")));
        }
        return;
    }

    if (mounted) { 
      setState(() {
        _locationPermissionGranted = true;
      });
    }
    await _getCurrentLocationAndStartStreaming();
  }

  /// Fetches the current GPS location and then starts streaming location updates.
  Future<void> _getCurrentLocationAndStartStreaming() async {
    if (!_locationPermissionGranted) return;
    try {
      Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      if (mounted) {
        setState(() {
          _currentUserLocation = LatLng(position.latitude, position.longitude);
          _currentLocationAccuracy = position.accuracy; 
          _currentCenter = _currentUserLocation!;
          _mapController.move(_currentUserLocation!, _currentZoom);
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
  void _startLocationStream() {
    if (!_locationPermissionGranted) return;
    const LocationSettings locationSettings = LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 10, 
    );
    _positionStreamSubscription = Geolocator.getPositionStream(locationSettings: locationSettings).listen((Position position) {
      if (mounted) {
        setState(() {
          _currentUserLocation = LatLng(position.latitude, position.longitude);
          _currentLocationAccuracy = position.accuracy; 
        });
      }
    });
  }

  /// Adjusts the map camera to fit the active route and the user's current location.
  void _fitMapToRouteAndUser(RouteModel route, LatLng? userLocation) {
    if (!mounted) return;

    List<LatLng> pointsToFit = [];
    if (userLocation != null) {
      pointsToFit.add(userLocation);
    }
    
    pointsToFit.addAll(route.pathCoordinates); 
    
    if (route.pathCoordinates.isEmpty && route.checkpoints.isNotEmpty) {
      pointsToFit.addAll(route.checkpoints.map((cp) => cp.position));
    }

    if (pointsToFit.isEmpty) {
      if (mounted && _mapController != null) {
         _mapController.move(_currentUserLocation ?? _currentCenter, _currentZoom);
      }
      return;
    }
    
    if (pointsToFit.length == 1) {
       if (mounted && _mapController != null) {
        _mapController.move(pointsToFit.first, 15.0); 
       }
      return;
    }

    var bounds = LatLngBounds.fromPoints(pointsToFit);
    if (mounted && _mapController != null) {
        _mapController.fitCamera(
        CameraFit.bounds(
            bounds: bounds,
            padding: const EdgeInsets.all(50.0), 
        ),
        );
    }
  }

  /// Displays a dialog for interacting with a checkpoint's minigame.
  ///
  /// This method handles the presentation and logic for different game types:
  /// - **Trivia**: Shows a question and a text field for the answer. Uses [StatefulBuilder]
  ///   to manage the dialog's internal state, such as displaying error messages for
  ///   incorrect answers (`triviaErrorText`). The `TextEditingController` for the
  ///   answer input is initialized here and disposed of when the dialog is closed.
  /// - **Photo Challenge**: Displays the task and simulates photo submission.
  /// - **Prop Hunt (and others)**: Displays the general game description and allows
  ///   the user to mark it as completed.
  ///
  /// If a checkpoint is already completed, it shows a SnackBar and returns.
  /// Upon successful completion of a minigame, it updates the checkpoint status via
  /// [RouteProvider] and awards points via [UserProvider] if the entire route is completed.
  ///
  /// [context] The build context for showing the dialog.
  /// [checkpoint] The [CheckpointModel] data for the specific checkpoint.
  /// [routeProvider] The [RouteProvider] instance to update route state.
  void _showCheckpointDialog(BuildContext context, CheckpointModel checkpoint, RouteProvider routeProvider) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    if (checkpoint.status == CheckpointStatus.completed) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("${checkpoint.name} is already completed!")),
      );
      return;
    }

    // Controller for the trivia answer text field.
    // Initialized only if the game type is trivia.
    TextEditingController? triviaAnswerController;
    if (checkpoint.gameType == MockGameType.trivia) {
      triviaAnswerController = TextEditingController();
    }

    showDialog<void>(
      context: context,
      barrierDismissible: false, 
      builder: (BuildContext dialogContext) {
        // StatefulBuilder is used to manage state that is local to the dialog,
        // such as the error message for trivia answers (triviaErrorText).
        // This allows the dialog content to rebuild without affecting the main page state.
        return StatefulBuilder( 
          builder: (stfContext, stfSetState) {
            String? triviaErrorText; // Holds error message for trivia input.

            return AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
              title: Text(
                "Minigame: ${checkpoint.gameType.toString().split('.').last.replaceAllMapped(RegExp(r'[A-Z]'), (match) => ' ${match.group(0)}').trim()}",
                style: Theme.of(dialogContext).textTheme.headlineSmall?.copyWith(color: Theme.of(dialogContext).colorScheme.onSurface),
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Logic for Trivia game type.
                    if (checkpoint.gameType == MockGameType.trivia) ...[
                      Text(checkpoint.triviaQuestion ?? checkpoint.gameDescription, style: Theme.of(dialogContext).textTheme.bodyLarge),
                      const SizedBox(height: 10),
                      TextField(
                        controller: triviaAnswerController,
                        decoration: InputDecoration(
                          hintText: "Your answer",
                          errorText: triviaErrorText, // Display error if answer is wrong.
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            borderSide: BorderSide(color: Theme.of(dialogContext).colorScheme.primary, width: 2.0),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            borderSide: BorderSide(color: Theme.of(dialogContext).colorScheme.error, width: 1.0),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            borderSide: BorderSide(color: Theme.of(dialogContext).colorScheme.error, width: 2.0),
                          ),
                        ),
                      ),
                    // Logic for Photo Challenge game type.
                    ] else if (checkpoint.gameType == MockGameType.photoChallenge) ...[
                      Text(checkpoint.photoChallengeTask ?? checkpoint.gameDescription, style: Theme.of(dialogContext).textTheme.bodyLarge),
                      const SizedBox(height: 10),
                      Center( 
                        child: Icon(Icons.camera_alt_outlined, size: 50, color: Colors.grey[400]),
                      ),
                      const SizedBox(height: 5),
                      Center(
                        child: Text("Imagine you've taken a photo!", style: Theme.of(dialogContext).textTheme.bodyMedium?.copyWith(fontStyle: FontStyle.italic, color: Colors.grey[600]))
                      ),
                    // Default logic for other game types (e.g., PropHunt).
                    ] else ...[ 
                      Text(checkpoint.gameDescription, style: Theme.of(dialogContext).textTheme.bodyLarge),
                    ],
                  ],
                ),
              ),
              actionsPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
              actions: <Widget>[
                TextButton(
                  child: const Text("Cancel"),
                  onPressed: () => Navigator.of(dialogContext).pop(),
                ),
                ElevatedButton( 
                  child: Text(
                    // Determine button text based on game type.
                    checkpoint.gameType == MockGameType.trivia ? "Submit Answer" :
                    checkpoint.gameType == MockGameType.photoChallenge ? "Photo Submitted!" : 
                    checkpoint.gameAnswerPlaceholder 
                  ),
                  onPressed: () {
                    bool gameSuccessfullyCompleted = false;

                    // Handle game completion logic based on type.
                    if (checkpoint.gameType == MockGameType.trivia) {
                      // Trivia answer checking mechanism.
                      if (triviaAnswerController!.text.trim().toLowerCase() == 
                          (checkpoint.triviaCorrectAnswer?.trim().toLowerCase() ?? "")) {
                        gameSuccessfullyCompleted = true;
                      } else {
                        stfSetState(() { // Update dialog state to show error.
                          triviaErrorText = "Incorrect. Try again!";
                        });
                        return; // Keep dialog open for another attempt.
                      }
                    } else if (checkpoint.gameType == MockGameType.photoChallenge) {
                      // Photo Challenge simulation: assume successful completion.
                      gameSuccessfullyCompleted = true; 
                    } else { // PropHunt or other types: assume successful completion on action.
                      gameSuccessfullyCompleted = true;
                    }

                    if (gameSuccessfullyCompleted) {
                      routeProvider.completeCheckpoint(checkpoint.id);
                      Navigator.of(dialogContext).pop(); // Close the dialog.

                      // Check for overall route completion.
                      if (routeProvider.activeRoute != null && routeProvider.areAllCheckpointsInActiveRouteCompleted()) {
                        userProvider.addPoints(50); // Award points.
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Route Completed! +50 Points. Well done!"),
                            duration: Duration(seconds: 3),
                          ),
                        );
                      }
                    }
                  },
                ),
              ],
            );
          }
        );
      },
    ).then((_) {
      // Ensure TextEditingController is disposed of when the dialog is closed,
      // regardless of how it's closed (e.g., cancel, submit, barrier tap if not dismissible).
      triviaAnswerController?.dispose();
    });
  }

  @override
  Widget build(BuildContext context) {
    final routeProvider = Provider.of<RouteProvider>(context);
    final activeRoute = routeProvider.activeRoute;

    if (activeRoute != null && !_routeFitAttempted) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) { 
          _fitMapToRouteAndUser(activeRoute, _currentUserLocation);
          setState(() {
            _routeFitAttempted = true;
          });
        }
      });
    } else if (activeRoute == null && _routeFitAttempted) {
       if(mounted){
          setState(() {
            _routeFitAttempted = false;
          });
        }
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
              if (activeRoute != null && activeRoute.pathCoordinates.isNotEmpty)
                PolylineLayer(
                  polylines: [
                    Polyline(
                      points: activeRoute.pathCoordinates, 
                      strokeWidth: 5.0, 
                      color: Colors.deepOrangeAccent, 
                    ),
                  ],
                ),
              if (activeRoute != null)
                MarkerLayer(
                  markers: activeRoute.checkpoints.map((checkpoint) {
                    return Marker(
                      width: 100.0, 
                      height: 100.0, 
                      point: checkpoint.position, 
                      child: GestureDetector(
                        onTap: () {
                          _showCheckpointDialog(context, checkpoint, routeProvider);
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center, 
                          children: [
                            Icon(
                              checkpoint.status == CheckpointStatus.completed ? Icons.check_circle : Icons.location_on_sharp,
                              color: checkpoint.status == CheckpointStatus.completed 
                                  ? (Colors.green[700] ?? Colors.green) 
                                  : (Theme.of(context).colorScheme.error),
                              size: 35.0,
                            ),
                            Container( 
                              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                              margin: const EdgeInsets.only(top: 2), 
                              decoration: BoxDecoration( 
                                color: Colors.black.withOpacity(0.6),
                                borderRadius: BorderRadius.circular(4),
                                boxShadow: [ 
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.2),
                                    blurRadius: 2,
                                    offset: const Offset(0,1),
                                  )
                                ]
                              ),
                              child: Text(
                                checkpoint.name,
                                style: const TextStyle(fontSize: 12, color: Colors.white, fontWeight: FontWeight.bold), 
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
              // Accuracy Circle Layer - BEFORE the user location marker
              if (_currentUserLocation != null && _locationPermissionGranted && _currentLocationAccuracy > 0)
                CircleLayer(
                  circles: [
                    CircleMarker(
                      point: _currentUserLocation!,
                      radius: _currentLocationAccuracy, 
                      useRadiusInMeter: true,
                      color: Colors.blue.withOpacity(0.1), 
                      borderColor: Colors.blue.withOpacity(0.3), 
                      borderStrokeWidth: 1,
                    ),
                  ],
                ),
              // User Location Marker Layer
              if (_currentUserLocation != null)
                MarkerLayer(
                  markers: [
                    Marker(
                      width: 80.0,
                      height: 80.0,
                      point: _currentUserLocation!,
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(blurRadius: 5, color: Colors.black.withOpacity(0.5), spreadRadius: 1)
                          ]
                        ),
                        child: Icon(
                          Icons.person_pin_circle, 
                          color: Theme.of(context).colorScheme.primary,
                          size: 40.0,
                          shadows: [ 
                              Shadow(blurRadius: 3.0, color: Colors.black.withOpacity(0.3), offset: Offset(1.0, 1.0)),
                          ]
                        ),
                      )
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
