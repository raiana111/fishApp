class GameState {
  int score;
  int caughtFish;
  bool isGameActive;
  final List<String> caughtFishIds;

  GameState({
    this.score = 0,
    this.caughtFish = 0,
    this.isGameActive = true,
    List<String>? caughtFishIds,
  }) : caughtFishIds = caughtFishIds ?? [];

  void addCaughtFish(String fishId, int points) {
    score += points;
    caughtFish++;
    caughtFishIds.add(fishId);
  }

  void reset() {
    score = 0;
    caughtFish = 0;
    isGameActive = true;
    caughtFishIds.clear();
  }

  GameState copyWith({
    int? score,
    int? caughtFish,
    bool? isGameActive,
    List<String>? caughtFishIds,
  }) {
    return GameState(
      score: score ?? this.score,
      caughtFish: caughtFish ?? this.caughtFish,
      isGameActive: isGameActive ?? this.isGameActive,
      caughtFishIds: caughtFishIds ?? this.caughtFishIds,
    );
  }
}