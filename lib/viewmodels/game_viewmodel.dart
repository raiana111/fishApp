import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import '../models/fish.dart';
import '../models/game_state.dart';

class GameViewModel with ChangeNotifier {
  final Random _random = Random();
  late Timer _gameTimer;
  
  GameState _gameState = GameState();
  List<Fish> _fishes = [];
  double _hookX = 0;
  double _hookY = 0;
  bool _isHookActive = false;
  bool _isInitialized = false;

  final int _maxFishes = 8; // Уменьшил для лучшей видимости

  GameViewModel() {
    _initializeGame();
    _startGameLoop();
  }

  GameState get gameState => _gameState;
  List<Fish> get fishes => _fishes;
  double get hookX => _hookX;
  double get hookY => _hookY;
  bool get isHookActive => _isHookActive;
  bool get isInitialized => _isInitialized;

  void _initializeGame() {
    _fishes = [];
    for (int i = 0; i < _maxFishes; i++) {
      _fishes.add(_createRandomFish());
    }
    _hookX = 200; // Начальная позиция крючка
    _hookY = 100;
    _isInitialized = true;
    notifyListeners();
  }

  Fish _createRandomFish() {
    final sizes = FishSize.values;
    final size = sizes[_random.nextInt(sizes.length)];

    final colors = [
      Colors.orange,
      Colors.red,
      Colors.blue,
      Colors.green,
      Colors.purple,
      Colors.yellow,
    ];
    final color = colors[_random.nextInt(colors.length)];

    double speed;
    switch (size) {
      case FishSize.small:
        speed = 1.0 + _random.nextDouble() * 0.5;
      case FishSize.medium:
        speed = 0.7 + _random.nextDouble() * 0.4;
      case FishSize.large:
        speed = 0.4 + _random.nextDouble() * 0.3;
    }

    // Начальные позиции в пределах экрана (предполагаемый размер)
    final x = _random.nextDouble() * 300 + 50;
    final y = _random.nextDouble() * 500 + 50;

    return Fish(
      id: 'fish_${DateTime.now().millisecondsSinceEpoch}_$i',
      size: size,
      color: color,
      speed: speed,
      x: x,
      y: y,
      dx: _random.nextBool() ? 1.0 : -1.0,
      dy: _random.nextBool() ? 0.5 : -0.5,
    );
  }

  void _startGameLoop() {
    _gameTimer = Timer.periodic(const Duration(milliseconds: 50), (_) {
      if (_gameState.isGameActive) {
        _moveFishes();
      }
    });
  }

  void _moveFishes() {
    for (var fish in _fishes) {
      // Двигаем рыбку
      fish.x += fish.dx * fish.speed;
      fish.y += fish.dy * fish.speed;

      // Отскок от границ (предполагаемый размер экрана 400x700)
      if (fish.x - fish.radius <= 0 || fish.x + fish.radius >= 400) {
        fish.dx *= -1;
        fish.x = fish.x.clamp(fish.radius, 400 - fish.radius);
      }

      if (fish.y - fish.radius <= 50 || fish.y + fish.radius >= 650) {
        fish.dy *= -1;
        fish.y = fish.y.clamp(fish.radius + 50, 650 - fish.radius);
      }
    }
    notifyListeners();
  }

  void catchFish(double touchX, double touchY) {
    if (!_gameState.isGameActive || _isHookActive) return;

    _hookX = touchX;
    _hookY = touchY;
    _isHookActive = true;
    notifyListeners();

    // Ищем рыбку, на которую нажали
    Fish? caughtFish;
    double minDistance = double.infinity;

    for (var fish in _fishes) {
      if (_gameState.caughtFishIds.contains(fish.id)) continue;

      final distance = sqrt(pow(fish.x - touchX, 2) + pow(fish.y - touchY, 2));

      // Если касание в пределах рыбки
      if (distance < fish.radius * 1.5) {
        if (distance < minDistance) {
          minDistance = distance;
          caughtFish = fish;
        }
      }
    }

    // Если рыбка поймана
    if (caughtFish != null) {
      _gameState.addCaughtFish(caughtFish.id, caughtFish.points);

      // Удаляем пойманную рыбку и добавляем новую
      _fishes.remove(caughtFish);
      _fishes.add(_createRandomFish());

      notifyListeners();
    }

    // Анимация удочки
    Future.delayed(const Duration(milliseconds: 300), () {
      _isHookActive = false;
      notifyListeners();
    });
  }

  void restartGame() {
    _gameTimer.cancel();
    _gameState.reset();
    _isHookActive = false;
    _initializeGame();
    _startGameLoop();
    notifyListeners();
  }

  @override
  void dispose() {
    _gameTimer.cancel();
    super.dispose();
  }
}