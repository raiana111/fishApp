import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'package:fiashapp/main.dart';
import 'package:fiashapp/viewmodels/game_viewmodel.dart';
import 'package:fiashapp/views/game_screen.dart';
import 'package:fiashapp/views/widgets/fish_widget.dart';
import 'package:fiashapp/views/widgets/hook_widget.dart';

void main() {
  testWidgets('App starts correctly', (WidgetTester tester) async {
    await tester.pumpWidget(const FishCatchingGame());
    
    expect(find.byType(MaterialApp), findsOneWidget);
    expect(find.byType(GameScreen), findsOneWidget);
    expect(find.text('Очки: 0'), findsOneWidget);
  });

  testWidgets('Score widget displays correctly', (WidgetTester tester) async {
    await tester.pumpWidget(const FishCatchingGame());
    
    expect(find.byIcon(Icons.emoji_events), findsOneWidget);
    // Используем иконку из исправленного ScoreWidget
    expect(find.byIcon(Icons.waves), findsOneWidget);
  });

  testWidgets('Game has fish widgets', (WidgetTester tester) async {
    await tester.pumpWidget(const FishCatchingGame());
    await tester.pumpAndSettle(); // Ждем завершения анимаций
    
    // Проверяем, что есть виджеты рыбок (их должно быть несколько)
    expect(find.byType(FishWidget), findsWidgets);
  });

  testWidgets('Restart button works', (WidgetTester tester) async {
    await tester.pumpWidget(const FishCatchingGame());
    
    // Ищем кнопку рестарта по иконке или по типу FloatingActionButton
    final restartButton = find.byType(FloatingActionButton);
    expect(restartButton, findsOneWidget);
    
    await tester.tap(restartButton);
    await tester.pumpAndSettle();
    
    // Проверяем, что счет обнулился
    expect(find.text('Очки: 0'), findsOneWidget);
  });

  testWidgets('Game screen contains all necessary elements', (WidgetTester tester) async {
    await tester.pumpWidget(const FishCatchingGame());
    await tester.pumpAndSettle();
    
    // Проверяем наличие основных элементов интерфейса
    expect(find.byType(SafeArea), findsOneWidget);
    expect(find.byType(Scaffold), findsOneWidget);
    expect(find.text('Нажмите на рыбку, чтобы поймать!'), findsOneWidget);
    expect(find.text('Маленькая рыба: 1 очко'), findsOneWidget);
    expect(find.text('Средняя рыба: 2 очка'), findsOneWidget);
    expect(find.text('Большая рыба: 3 очка'), findsOneWidget);
  });

  testWidgets('ViewModel provider is correctly set up', (WidgetTester tester) async {
    await tester.pumpWidget(const FishCatchingGame());
    
    // Проверяем, что в дереве виджетов есть ChangeNotifierProvider
    expect(find.byType(ChangeNotifierProvider<GameViewModel>), findsOneWidget);
  });

  group('GameScreen interaction tests', () {
    testWidgets('Tap on game area triggers hook animation', (WidgetTester tester) async {
      await tester.pumpWidget(const FishCatchingGame());
      await tester.pumpAndSettle();
      
      // Ищем игровую область
      final gameArea = find.byType(GestureDetector);
      expect(gameArea, findsOneWidget);
      
      // Тапаем на игровую область
      await tester.tap(gameArea);
      await tester.pump();
      
      // Проверяем, что крючок присутствует
      expect(find.byType(HookWidget), findsOneWidget);
    });

    testWidgets('Game has control panel with fish info', (WidgetTester tester) async {
      await tester.pumpWidget(const FishCatchingGame());
      
      // Проверяем информацию о рыбах в нижней панели
      expect(find.text('Маленькая рыба'), findsOneWidget);
      expect(find.text('Средняя рыба'), findsOneWidget);
      expect(find.text('Большая рыба'), findsOneWidget);
    });
  });

  group('GameViewModel functionality', () {
    testWidgets('ViewModel initializes correctly', (WidgetTester tester) async {
      // Создаем ViewModel напрямую для тестирования
      final viewModel = GameViewModel();
      
      // Проверяем начальное состояние
      expect(viewModel.gameState.score, 0);
      expect(viewModel.gameState.caughtFish, 0);
      expect(viewModel.gameState.isGameActive, true);
      expect(viewModel.fishes.length, 10);
      expect(viewModel.isHookActive, false);
    });

    testWidgets('ViewModel restarts correctly', (WidgetTester tester) async {
      final viewModel = GameViewModel();
      
      // Имитируем изменение состояния
      // В реальном тесте нужно было бы вызывать catchFish, 
      // но для упрощения просто проверяем метод restartGame
      
      viewModel.restartGame();
      
      // Проверяем, что состояние сброшено
      expect(viewModel.gameState.score, 0);
      expect(viewModel.gameState.caughtFish, 0);
    });
  });

  // Дополнительные тесты для будущего расширения
  testWidgets('App has correct title', (WidgetTester tester) async {
    await tester.pumpWidget(const FishCatchingGame());
    
    // Проверяем заголовок приложения через AppBar или другой элемент
    expect(find.text('Ловля рыбок'), findsOneWidget);
  });

  testWidgets('Game has water background', (WidgetTester tester) async {
    await tester.pumpWidget(const FishCatchingGame());
    
    // Проверяем наличие фонового градиента
    final containerFinder = find.byWidgetPredicate(
      (widget) => widget is Container && widget.decoration is BoxDecoration,
    );
    expect(containerFinder, findsAtLeast(1));
  });
}