enum CheckpointStatus { pending, completed }

enum MockGameType { trivia, photoChallenge, propHunt }

class CheckpointModel {
  final String id;
  final String name;
  final CheckpointStatus status;
  final MockGameType gameType;
  final String gameDescription;
  final String gameAnswerPlaceholder;

  CheckpointModel({
    required this.id,
    required this.name,
    this.status = CheckpointStatus.pending,
    required this.gameType,
    required this.gameDescription,
    required this.gameAnswerPlaceholder,
  });
}
