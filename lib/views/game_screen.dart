import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/game_viewmodel.dart';
import 'widgets/fish_widget.dart';
import 'widgets/hook_widget.dart';
import 'widgets/score_widget.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  @override
  Widget build(BuildContext context) {
    return Consumer<GameViewModel>(
      builder: (context, viewModel, child) {
        return Scaffold(
          body: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFF87CEEB),
                  Color(0xFF1E90FF),
                ],
              ),
            ),
            child: SafeArea(
              child: Column(
                children: [
                  // Верхняя панель с очками
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: ScoreWidget(
                      score: viewModel.gameState.score,
                      caughtFish: viewModel.gameState.caughtFish,
                    ),
                  ),

                  // Игровое поле
                  Expanded(
                    child: GestureDetector(
                      onTapDown: (details) {
                        final renderBox =
                            context.findRenderObject() as RenderBox;
                        final localPosition =
                            renderBox.globalToLocal(details.globalPosition);
                        viewModel.catchFish(
                            localPosition.dx, localPosition.dy, context);
                      },
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 16),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.3),
                            width: 2,
                          ),
                        ),
                        child: Stack(
                          children: [
                            // Фоновые пузырьки
                            _buildWaterBubbles(),

                            // Рыбки
                            if (viewModel.isInitialized)
                              ...viewModel.fishes.map(
                                (fish) => FishWidget(fish: fish),
                              ),

                            // Удочка
                            HookWidget(
                              x: viewModel.hookX,
                              y: viewModel.hookY,
                              isActive: viewModel.isHookActive,
                            ),

                            // Инструкция
                            Positioned(
                              bottom: 10,
                              left: 0,
                              right: 0,
                              child: Center(
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 8,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.black.withOpacity(0.5),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: const Text(
                                    'Нажмите на рыбку, чтобы поймать!',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  // Нижняя панель управления
                  Container(
                    padding: const EdgeInsets.all(16),
                    color: Colors.black.withOpacity(0.3),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Информация о рыбах
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildFishInfo(
                                'Маленькая рыба: 1 очко', Colors.orange),
                            _buildFishInfo('Средняя рыба: 2 очка', Colors.blue),
                            _buildFishInfo('Большая рыба: 3 очка', Colors.red),
                          ],
                        ),

                        // Кнопка рестарта
                        FloatingActionButton(
                          onPressed: viewModel.restartGame,
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                          child: const Icon(Icons.refresh),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildWaterBubbles() {
    return CustomPaint(
      size: Size.infinite,
      painter: _WaterBubblesPainter(),
    );
  }

  Widget _buildFishInfo(String text, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            text,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}

class _WaterBubblesPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.1)
      ..style = PaintingStyle.fill;

    final random = math.Random(42);

    // Рисуем пузырьки
    for (int i = 0; i < 20; i++) {
      final x = random.nextDouble() * size.width;
      final y = random.nextDouble() * size.height;
      final radius = random.nextDouble() * 4 + 1;

      canvas.drawCircle(Offset(x, y), radius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
