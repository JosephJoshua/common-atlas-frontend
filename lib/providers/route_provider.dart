import 'package:flutter/material.dart';
import '../models/route_model.dart';
import '../models/checkpoint_model.dart';

class RouteProvider extends ChangeNotifier {
  List<RouteModel> _availableRoutes;
  RouteModel? _activeRoute;

  List<RouteModel> get availableRoutes => _availableRoutes;
  RouteModel? get activeRoute => _activeRoute;

  RouteProvider() : _availableRoutes = [] {
    // Mock Checkpoints for Freedom Trail Snippet
    CheckpointModel ftCp1 = CheckpointModel(
        id: "ft1",
        name: "Boston Common",
        gameType: MockGameType.trivia,
        gameDescription: "What year was Boston Common founded?",
        gameAnswerPlaceholder: "Enter Year");
    CheckpointModel ftCp2 = CheckpointModel(
        id: "ft2",
        name: "Massachusetts State House",
        gameType: MockGameType.photoChallenge,
        gameDescription: "Take a picture of the golden dome.",
        gameAnswerPlaceholder: "Capture Photo");
    CheckpointModel ftCp3 = CheckpointModel(
        id: "ft3",
        name: "Old South Meeting House",
        gameType: MockGameType.propHunt,
        gameDescription: "Find the plaque commemorating the Boston Tea Party.",
        gameAnswerPlaceholder: "Found It!");

    // Mock Checkpoints for Harborwalk Quick View
    CheckpointModel hwCp1 = CheckpointModel(
        id: "hw1",
        name: "Rowes Wharf",
        gameType: MockGameType.trivia,
        gameDescription: "What type of boat often docks here?",
        gameAnswerPlaceholder: "Enter boat type");
    CheckpointModel hwCp2 = CheckpointModel(
        id: "hw2",
        name: "Institute of Contemporary Art",
        gameType: MockGameType.photoChallenge,
        gameDescription: "Take a picture of the ICA building.",
        gameAnswerPlaceholder: "Capture Photo");
    CheckpointModel hwCp3 = CheckpointModel(
        id: "hw3",
        name: "Fan Pier Park",
        gameType: MockGameType.propHunt,
        gameDescription: "Find the interactive water feature.",
        gameAnswerPlaceholder: "Found It!");
    
    // Mock Checkpoints for Emerald Necklace Path
    CheckpointModel enCp1 = CheckpointModel(
        id: "en1",
        name: "Fenway Park Overlook",
        gameType: MockGameType.photoChallenge,
        gameDescription: "Take a picture of Fenway Park from a distance.",
        gameAnswerPlaceholder: "Capture Photo");
    CheckpointModel enCp2 = CheckpointModel(
        id: "en2",
        name: "Japanese Temple Bell",
        gameType: MockGameType.trivia,
        gameDescription: "What is the significance of this bell?",
        gameAnswerPlaceholder: "Enter significance");
    CheckpointModel enCp3 = CheckpointModel(
        id: "en3",
        name: "Victory Gardens",
        gameType: MockGameType.propHunt,
        gameDescription: "Find the oldest continuously cultivated victory garden.",
        gameAnswerPlaceholder: "Found It!");


    _availableRoutes = [
      RouteModel(
        id: "route1",
        name: "Freedom Trail Snippet",
        type: RouteType.scenic,
        distance: "1.5 miles",
        difficulty: "Easy",
        energyCost: 10,
        checkpoints: [ftCp1, ftCp2, ftCp3],
        description: "A short walk through some of Boston's most historic sites, starting at the Boston Common.",
        mapImagePlaceholder: "assets/maps/freedom_trail_mock.png",
      ),
      RouteModel(
        id: "route2",
        name: "Harborwalk Quick View",
        type: RouteType.active,
        distance: "2 miles",
        difficulty: "Medium",
        energyCost: 15,
        checkpoints: [hwCp1, hwCp2, hwCp3],
        description: "A brisk walk along Boston's waterfront, offering views of the harbor and city skyline.",
        mapImagePlaceholder: "assets/maps/harborwalk_mock.png",
      ),
       RouteModel(
        id: "route3",
        name: "Emerald Necklace Path",
        type: RouteType.scenic,
        distance: "3 miles",
        difficulty: "Medium",
        energyCost: 20,
        checkpoints: [enCp1, enCp2, enCp3],
        description: "Explore a section of Boston's famous chain of parks, designed by Frederick Law Olmsted.",
        mapImagePlaceholder: "assets/maps/emerald_necklace_mock.png",
      ),
    ];
  }

  void setActiveRoute(String routeId) {
    _activeRoute = _availableRoutes.firstWhere((route) => route.id == routeId, orElse: () => _availableRoutes.first); // Fallback to first if not found
    notifyListeners();
  }

  void clearActiveRoute() {
    _activeRoute = null;
    notifyListeners();
  }

  void completeCheckpoint(String checkpointId) {
    if (_activeRoute != null) {
      try {
        CheckpointModel checkpoint = _activeRoute!.checkpoints.firstWhere((cp) => cp.id == checkpointId);
        // Create a new CheckpointModel with updated status
        CheckpointModel updatedCheckpoint = CheckpointModel(
          id: checkpoint.id,
          name: checkpoint.name,
          status: CheckpointStatus.completed, // Update status
          gameType: checkpoint.gameType,
          gameDescription: checkpoint.gameDescription,
          gameAnswerPlaceholder: checkpoint.gameAnswerPlaceholder,
        );
        // Replace the old checkpoint with the updated one
        int checkpointIndex = _activeRoute!.checkpoints.indexWhere((cp) => cp.id == checkpointId);
        _activeRoute!.checkpoints[checkpointIndex] = updatedCheckpoint;

        notifyListeners();
      } catch (e) {
        // Checkpoint not found, handle error or log
        print("Error completing checkpoint: $e");
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
