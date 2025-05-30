import 'package:latlong2/latlong.dart';

enum CheckpointStatus { pending, completed }

enum MockGameType { trivia, photoChallenge, propHunt }

class CheckpointModel {
  final String id;
  final String name;
  CheckpointStatus status;
  final MockGameType gameType;
  final String gameDescription;
  final String gameAnswerPlaceholder;
  final LatLng position;
  final String? triviaQuestion;
  final String? triviaCorrectAnswer;
  final String? photoChallengeTask;

  CheckpointModel({
    required this.id,
    required this.name,
    this.status = CheckpointStatus.pending,
    required this.gameType,
    required this.gameDescription,
    required this.gameAnswerPlaceholder,
    required this.position,
    this.triviaQuestion,
    this.triviaCorrectAnswer,
    this.photoChallengeTask,
  });
}
