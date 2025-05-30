import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';

import '../models/checkpoint_model.dart';
import '../models/route_model.dart';

class RouteProvider extends ChangeNotifier {
  List<RouteModel> _availableRoutes;
  RouteModel? _activeRoute;

  List<RouteModel> get availableRoutes => _availableRoutes;
  RouteModel? get activeRoute => _activeRoute;

  RouteProvider() : _availableRoutes = [] {
    final LatLng ftCp1Pos = LatLng(42.3550, -71.0650);
    final LatLng ftCp2Pos = LatLng(42.3587, -71.0625);
    final LatLng ftCp3Pos = LatLng(42.3590, -71.0600);

    final LatLng hwCp1Pos = LatLng(42.3580, -71.0510);
    final LatLng hwCp2Pos = LatLng(42.3520, -71.0450);
    final LatLng hwCp3Pos = LatLng(42.3535, -71.0410);

    _availableRoutes = [
      RouteModel(
        id: "freedom_trail_snippet",
        name: "Freedom Trail Snippet",
        type: RouteType.scenic,
        distance: "Approx. 1 mile",
        difficulty: "Easy",
        energyCost: 10,
        description:
            "A short walk through some of Boston's historic landmarks, starting at the Boston Common.",
        mapImagePlaceholder: "assets/maps/freedom_trail_mock.png",
        checkpoints: [
          CheckpointModel(
            id: "ft1",
            name: "Boston Common",
            gameType: MockGameType.trivia,
            gameDescription: "Oldest city park in the United States.",
            gameAnswerPlaceholder: "Enter Year",
            position: ftCp1Pos,
            triviaQuestion: "What year was Boston Common established as a public park?",
            triviaCorrectAnswer: "1634",
          ),
          CheckpointModel(
            id: "ft2",
            name: "State House",
            gameType: MockGameType.photoChallenge,
            gameDescription:
                "The Massachusetts State House is the state capitol and house of government.",
            gameAnswerPlaceholder: "Simulate Photo",
            position: ftCp2Pos,
            photoChallengeTask: "Take a unique photo of the State House's golden dome.",
          ),
          CheckpointModel(
            id: "ft3",
            name: "Park Street Church",
            gameType: MockGameType.propHunt,
            gameDescription: "Find the historic plaque near the entrance.",
            gameAnswerPlaceholder: "Found It!",
            position: ftCp3Pos,
          ),
        ],
        pathCoordinates: [
          ftCp1Pos,
          LatLng(42.3570, -71.0630),
          ftCp2Pos,
          LatLng(42.3588, -71.0610),
          ftCp3Pos,
        ],
      ),
      RouteModel(
        id: "harborwalk_quick_view",
        name: "Harborwalk Quick View",
        type: RouteType.active,
        distance: "Approx. 1.5 miles",
        difficulty: "Easy",
        energyCost: 15,
        description: "A scenic stroll along a portion of Boston's Harborwalk.",
        mapImagePlaceholder: "assets/maps/harborwalk_mock.png",
        checkpoints: [
          CheckpointModel(
            id: "hw1",
            name: "Rowes Wharf Arch",
            gameType: MockGameType.photoChallenge,
            gameDescription: "Iconic archway at Rowes Wharf, a gateway to the harbor.",
            gameAnswerPlaceholder: "Simulate Photo",
            position: hwCp1Pos,
            photoChallengeTask:
                "Capture a creative photo of the Rowes Wharf Arch, perhaps with a boat in the background.",
          ),
          CheckpointModel(
            id: "hw2",
            name: "ICA Overlook",
            gameType: MockGameType.trivia,
            gameDescription: "The Institute of Contemporary Art offers stunning harbor views.",
            gameAnswerPlaceholder: "Enter Year",
            position: hwCp2Pos,
            triviaQuestion: "What major body of water does the ICA overlook?",
            triviaCorrectAnswer: "Boston Harbor",
          ),
          CheckpointModel(
            id: "hw3",
            name: "Fan Pier Green",
            gameType: MockGameType.propHunt,
            gameDescription: "Find the large outdoor sculpture near the waterfront.",
            gameAnswerPlaceholder: "Found It!",
            position: hwCp3Pos,
          ),
        ],
        pathCoordinates: [
          hwCp1Pos,
          LatLng(42.3555, -71.0480),
          hwCp2Pos,
          LatLng(42.3528, -71.0430),
          hwCp3Pos,
        ],
      ),
    ];
  }

  void setActiveRoute(String routeId) {
    _activeRoute = _availableRoutes.firstWhere(
      (route) => route.id == routeId,
      orElse: () => _availableRoutes.first,
    );
    notifyListeners();
  }

  void clearActiveRoute() {
    _activeRoute = null;
    notifyListeners();
  }

  void completeCheckpoint(String checkpointId) {
    if (_activeRoute != null) {
      final checkpointIndex = _activeRoute!.checkpoints.indexWhere((cp) => cp.id == checkpointId);
      if (checkpointIndex != -1) {
        _activeRoute!.checkpoints[checkpointIndex].status = CheckpointStatus.completed;
        notifyListeners();
      } else {
        print(
          "Error completing checkpoint: Checkpoint ID $checkpointId not found in active route.",
        );
      }
    }
  }

  bool areAllCheckpointsInActiveRouteCompleted() {
    if (_activeRoute == null || _activeRoute!.checkpoints.isEmpty) {
      return false;
    }
    return _activeRoute!.checkpoints.every((cp) => cp.status == CheckpointStatus.completed);
  }
}
