import 'package:flutter_test/flutter_test.dart';
import 'dart:math';

// Модель рыбки для теста
class TestFish {
  final double x;
  final double y;
  final double size;
  final int points;
  
  TestFish({
    required this.x,
    required this.y,
    required this.size,
    required this.points,
  });
  
  // Метод для проверки, поймана ли рыбка
  bool isCaught(double touchX, double touchY) {
    final distance = sqrt(pow(x - touchX, 2) + pow(y - touchY, 2));
    return distance <= size;
  }
}

// Класс для подсчета очков
class ScoreCalculator {
  int totalScore = 0;
  int caughtFish = 0;
  
  void catchFish(TestFish fish) {
    totalScore += fish.points;
    caughtFish++;
  }
  
  void reset() {
    totalScore = 0;
    caughtFish = 0;
  }
}

void main() {
  group('Unit Tests - Логика игры', () {
    
    test('Рыбка должна быть поймана при касании в её радиусе', () {
      // Создаем рыбку в позиции (100, 100) с размером 30
      final fish = TestFish(
        x: 100,
        y: 100,
        size: 30,
        points: 1,
      );
      
      // Тест 1: Касание в центр рыбки
      expect(fish.isCaught(100, 100), true, 
        reason: 'Касание в центр должно поймать рыбку');
      
      // Тест 2: Касание внутри радиуса
      expect(fish.isCaught(115, 115), true,
        reason: 'Касание внутри радиуса должно поймать рыбку');
      
      // Тест 3: Касание на границе радиуса
      expect(fish.isCaught(130, 100), true,
        reason: 'Касание на границе радиуса должно поймать рыбку');
      
      // Тест 4: Касание вне радиуса
      expect(fish.isCaught(200, 200), false,
        reason: 'Касание вне радиуса не должно поймать рыбку');
    });
    
    test('Правильный подсчет очков для разных размеров рыбок', () {
      final calculator = ScoreCalculator();
      
      // Создаем рыбок разных размеров
      final smallFish = TestFish(x: 0, y: 0, size: 15, points: 1);
      final mediumFish = TestFish(x: 0, y: 0, size: 25, points: 2);
      final largeFish = TestFish(x: 0, y: 0, size: 35, points: 3);
      
      // Ловим маленькую рыбку
      calculator.catchFish(smallFish);
      expect(calculator.totalScore, 1, reason: 'Маленькая рыбка должна давать 1 очко');
      expect(calculator.caughtFish, 1, reason: 'Должна быть поймана 1 рыбка');
      
      // Ловим среднюю рыбку
      calculator.catchFish(mediumFish);
      expect(calculator.totalScore, 3, reason: '1 + 2 = 3 очка');
      expect(calculator.caughtFish, 2, reason: 'Поймано 2 рыбки');
      
      // Ловим большую рыбку
      calculator.catchFish(largeFish);
      expect(calculator.totalScore, 6, reason: '3 + 3 = 6 очков');
      expect(calculator.caughtFish, 3, reason: 'Поймано 3 рыбки');
    });
    
    test('Сброс игры должен обнулять счет', () {
      final calculator = ScoreCalculator();
      final fish = TestFish(x: 0, y: 0, size: 15, points: 1);
      
      // Ловим несколько рыбок
      calculator.catchFish(fish);
      calculator.catchFish(fish);
      calculator.catchFish(fish);
      
      expect(calculator.totalScore, 3, reason: 'До сброса должно быть 3 очка');
      expect(calculator.caughtFish, 3, reason: 'До сброса должно быть 3 рыбки');
      
      // Сбрасываем игру
      calculator.reset();
      
      expect(calculator.totalScore, 0, reason: 'После сброса должно быть 0 очков');
      expect(calculator.caughtFish, 0, reason: 'После сброса должно быть 0 рыбок');
    });
    
    test('Расстояние до рыбки вычисляется правильно', () {
      final fish = TestFish(x: 100, y: 100, size: 20, points: 1);
      
      // Расстояние от рыбки до точки (100, 100) = 0
      expect(fish.isCaught(100, 100), true);
      
      // Расстояние от рыбки до точки (120, 100) = 20
      expect(fish.isCaught(120, 100), true);
      
      // Расстояние от рыбки до точки (121, 100) = 21
      expect(fish.isCaught(121, 100), false);
      
      // Расстояние от рыбки до точки (100, 80) = 20
      expect(fish.isCaught(100, 80), true);
      
      // Расстояние от рыбки до точки (100, 79) = 21
      expect(fish.isCaught(100, 79), false);
    });
  });
}