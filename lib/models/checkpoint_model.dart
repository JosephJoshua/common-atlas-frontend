import 'package:latlong2/latlong2.dart'; // Added import

enum CheckpointStatus { pending, completed }

enum MockGameType { trivia, photoChallenge, propHunt }

class CheckpointModel {
  final String id;
  final String name;
  CheckpointStatus status; // Made non-final
  final MockGameType gameType;
  final String gameDescription;
  final String gameAnswerPlaceholder;
  final LatLng position; // New field
  final String? triviaQuestion;
  final String? triviaCorrectAnswer;
  final String? photoChallengeTask;

  CheckpointModel({
    required this.id,
    required this.name,
    this.status = CheckpointStatus.pending,
    required this.gameType,
    required this.gameDescription, // General description, can be used as fallback
    required this.gameAnswerPlaceholder, // May become less relevant for functional games
    required this.position,
    this.triviaQuestion,
    this.triviaCorrectAnswer,
    this.photoChallengeTask,
  });
}
