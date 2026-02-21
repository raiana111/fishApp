import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'package:fiashapp/viewmodels/game_viewmodel.dart';
import 'package:fiashapp/views/game_screen.dart';
import 'package:fiashapp/views/widgets/fish_widget.dart';
import 'package:fiashapp/views/widgets/hook_widget.dart';

/// Тестовая обёртка без Firebase
Widget createTestApp() {
  return ChangeNotifierProvider(
    create: (_) => GameViewModel(),
    child: const MaterialApp(
      title: 'Ловля рыбок',
      home: GameScreen(),
    ),
  );
}

void main() {
  testWidgets('App starts correctly', (WidgetTester tester) async {
    await tester.pumpWidget(createTestApp());

    expect(find.byType(MaterialApp), findsOneWidget);
    expect(find.byType(GameScreen), findsOneWidget);
    expect(find.text('Очки: 0'), findsOneWidget);
  });

  testWidgets('Score widget displays correctly', (WidgetTester tester) async {
    await tester.pumpWidget(createTestApp());

    expect(find.byIcon(Icons.emoji_events), findsOneWidget);
    expect(find.byIcon(Icons.waves), findsOneWidget);
  });

  testWidgets('Game has fish widgets', (WidgetTester tester) async {
    await tester.pumpWidget(createTestApp());
    await tester.pumpAndSettle();

    expect(find.byType(FishWidget), findsWidgets);
  });

  testWidgets('Restart button works', (WidgetTester tester) async {
    await tester.pumpWidget(createTestApp());

    final restartButton = find.byType(FloatingActionButton);
    expect(restartButton, findsOneWidget);

    await tester.tap(restartButton);
    await tester.pumpAndSettle();

    expect(find.text('Очки: 0'), findsOneWidget);
  });

  testWidgets('Game screen contains all necessary elements',
      (WidgetTester tester) async {
    await tester.pumpWidget(createTestApp());
    await tester.pumpAndSettle();

    expect(find.byType(SafeArea), findsOneWidget);
    expect(find.byType(Scaffold), findsOneWidget);
    expect(find.text('Нажмите на рыбку, чтобы поймать!'), findsOneWidget);
    expect(find.text('Маленькая рыба: 1 очко'), findsOneWidget);
    expect(find.text('Средняя рыба: 2 очка'), findsOneWidget);
    expect(find.text('Большая рыба: 3 очка'), findsOneWidget);
  });

  testWidgets('ViewModel provider is correctly set up',
      (WidgetTester tester) async {
    await tester.pumpWidget(createTestApp());

    expect(find.byType(ChangeNotifierProvider<GameViewModel>), findsOneWidget);
  });

  group('GameScreen interaction tests', () {
    testWidgets('Tap on game area triggers hook animation',
        (WidgetTester tester) async {
      await tester.pumpWidget(createTestApp());
      await tester.pumpAndSettle();

      final gameArea = find.byType(GestureDetector);
      expect(gameArea, findsOneWidget);

      await tester.tap(gameArea);
      await tester.pump();

      expect(find.byType(HookWidget), findsOneWidget);
    });

    testWidgets('Game has control panel with fish info',
        (WidgetTester tester) async {
      await tester.pumpWidget(createTestApp());

      expect(find.text('Маленькая рыба: 1 очко'), findsOneWidget);
      expect(find.text('Средняя рыба: 2 очка'), findsOneWidget);
      expect(find.text('Большая рыба: 3 очка'), findsOneWidget);
    });
  });

  group('GameViewModel functionality', () {
    test('ViewModel initializes correctly', () {
      final viewModel = GameViewModel();

      expect(viewModel.gameState.score, 0);
      expect(viewModel.gameState.caughtFish, 0);
      expect(viewModel.gameState.isGameActive, true);
      expect(viewModel.fishes.length, 10);
      expect(viewModel.isHookActive, false);

      viewModel.dispose();
    });

    test('ViewModel restarts correctly', () {
      final viewModel = GameViewModel();

      viewModel.restartGame();

      expect(viewModel.gameState.score, 0);
      expect(viewModel.gameState.caughtFish, 0);

      viewModel.dispose();
    });
  });

  testWidgets('Game has water background', (WidgetTester tester) async {
    await tester.pumpWidget(createTestApp());

    final containerFinder = find.byWidgetPredicate(
      (widget) => widget is Container && widget.decoration is BoxDecoration,
    );
    expect(containerFinder, findsAtLeast(1));
  });
}
