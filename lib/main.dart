import 'dart:math';
import 'package:fiashapp/firebase.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const FishGame());
}
class FishGame extends StatelessWidget {
  const FishGame({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ловля рыбок',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const FishingScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class FishingScreen extends StatefulWidget {
  const FishingScreen({super.key});

  @override
  State<FishingScreen> createState() => _FishingScreenState();
}

class Fish {
  double x, y;
  double dx, dy;
  final Color color;
  final double size;
  final int points;
  bool isCaught;

  Fish({
    required this.x,
    required this.y,
    required this.dx,
    required this.dy,
    required this.color,
    required this.size,
    required this.points,
    this.isCaught = false,
  });
}

class _FishingScreenState extends State<FishingScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  final List<Fish> _fishes = [];
  int _score = 0;
  int _totalCaught = 0;
  double _hookX = 200;
  double _hookY = 100;
  bool _isHookActive = false;
  final Random _random = Random();

  @override
  void initState() {
    super.initState();

    // Создаем 8 рыбок
    for (int i = 0; i < 8; i++) {
      _fishes.add(_createFish());
    }

    // Анимационный контроллер для движения рыбок
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 16),
    )..repeat();

    _animationController.addListener(_updateGame);
  }

  Fish _createFish() {
    final colors = [
      Colors.red,
      Colors.orange,
      Colors.blue,
      Colors.green,
      Colors.purple,
      Colors.yellow,
    ];

    // Случайный размер: 0=маленькая, 1=средняя, 2=большая
    final sizeType = _random.nextInt(3);
    double size;
    int points;

    switch (sizeType) {
      case 0:
        size = 20.0;
        points = 1;
        break;
      case 1:
        size = 30.0;
        points = 2;
        break;
      case 2:
        size = 40.0;
        points = 3;
        break;
      default:
        size = 25.0;
        points = 1;
    }

    return Fish(
      x: _random.nextDouble() * 300 + 50,
      y: _random.nextDouble() * 400 + 100,
      dx: _random.nextBool() ? 1.5 : -1.5,
      dy: _random.nextBool() ? 1.0 : -1.0,
      color: colors[_random.nextInt(colors.length)],
      size: size,
      points: points,
    );
  }

  void _updateGame() {
    if (!mounted) return;

    setState(() {
      // Двигаем каждую рыбку
      for (var fish in _fishes) {
        if (fish.isCaught) continue;

        fish.x += fish.dx;
        fish.y += fish.dy;

        // Отскок от границ экрана (предполагаем размер 400x600)
        if (fish.x - fish.size <= 0 || fish.x + fish.size >= 400) {
          fish.dx *= -1;
          fish.x = fish.x.clamp(fish.size, 400 - fish.size);
        }

        if (fish.y - fish.size <= 50 || fish.y + fish.size >= 600) {
          fish.dy *= -1;
          fish.y = fish.y.clamp(fish.size + 50, 600 - fish.size);
        }
      }
    });
  }

  void _catchFish(double touchX, double touchY) {
    if (_isHookActive) return;

    setState(() {
      _hookX = touchX;
      _hookY = touchY;
      _isHookActive = true;

      // Проверяем, попали ли по рыбке
      for (var fish in _fishes) {
        if (fish.isCaught) continue;

        final distance = sqrt(pow(fish.x - touchX, 2) + pow(fish.y - touchY, 2));

        // Если касание в пределах рыбки
        if (distance < fish.size) {
          fish.isCaught = true;
          _score += fish.points;
          _totalCaught++;

          // Через секунду заменяем пойманную рыбку новой
          Future.delayed(const Duration(seconds: 1), () {
            if (mounted) {
              setState(() {
                final index = _fishes.indexOf(fish);
                _fishes[index] = _createFish();
              });
            }
          });
          break;
        }
      }

      // Анимация удочки (возврат через 300 мс)
      Future.delayed(const Duration(milliseconds: 300), () {
        if (mounted) {
          setState(() {
            _isHookActive = false;
          });
        }
      });
    });
  }

  void _restartGame() {
    setState(() {
      _score = 0;
      _totalCaught = 0;
      _fishes.clear();
      for (int i = 0; i < 8; i++) {
        _fishes.add(_createFish());
      }
      _hookX = 200;
      _hookY = 100;
      _isHookActive = false;
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF87CEEB),
      body: SafeArea(
        child: Column(
          children: [
            // Панель счета
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.6),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.emoji_events, color: Colors.amber),
                        const SizedBox(width: 8),
                        Text(
                          'Очки: $_score',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        const Icon(Icons.waves, color: Colors.lightBlue),
                        const SizedBox(width: 8),
                        Text(
                          'Рыбок: $_totalCaught',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // Игровое поле
            Expanded(
              child: GestureDetector(
                onTapDown: (details) {
                  final localPosition = (context.findRenderObject() as RenderBox)
                    .globalToLocal(details.globalPosition);
                  _catchFish(localPosition.dx, localPosition.dy);
                },
                child: Container(
                  margin: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                  child: Stack(
                    children: [
                      // Рыбки
                      for (var fish in _fishes)
                        if (!fish.isCaught)
                          Positioned(
                            left: fish.x - fish.size,
                            top: fish.y - fish.size,
                            child: Container(
                              width: fish.size * 2,
                              height: fish.size * 2,
                              child: CustomPaint(
                                painter: _FishPainter(fish: fish),
                              ),
                            ),
                          ),

                      // Удочка
                      Positioned(
                        left: _hookX - 15,
                        top: _hookY - (_isHookActive ? 50 : 30),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          width: 30,
                          height: _isHookActive ? 80 : 60,
                          child: CustomPaint(
                            painter: _HookPainter(),
                          ),
                        ),
                      ),

                      // Инструкция
                      const Positioned(
                        bottom: 10,
                        left: 0,
                        right: 0,
                        child: Center(
                          child: Text(
                            'Нажимайте на рыбок!',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              shadows: [
                                Shadow(
                                  color: Colors.black,
                                  blurRadius: 3,
                                  offset: Offset(1, 1),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Панель управления
            Container(
              padding: const EdgeInsets.all(16),
              color: Colors.black.withOpacity(0.3),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildFishInfo('Маленькая = 1 очко', Colors.orange),
                      _buildFishInfo('Средняя = 2 очка', Colors.blue),
                      _buildFishInfo('Большая = 3 очка', Colors.red),
                    ],
                  ),
                  FloatingActionButton(
                    onPressed: _restartGame,
                    backgroundColor: Colors.blue,
                    child: const Icon(Icons.refresh, color: Colors.white),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
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
            style: const TextStyle(color: Colors.white, fontSize: 12),
          ),
        ],
      ),
    );
  }
}

class _FishPainter extends CustomPainter {
  final Fish fish;

  _FishPainter({required this.fish});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = fish.color
      ..style = PaintingStyle.fill;

    // Тело рыбки (овал)
    final rect = Rect.fromCircle(
      center: Offset(size.width / 2, size.height / 2),
      radius: fish.size,
    );
    canvas.drawOval(rect, paint);

    // Хвост
    final tailPaint = Paint()
      ..color = fish.color.withOpacity(0.8);

    final tailPath = Path();
    tailPath.moveTo(0, size.height * 0.3);
    tailPath.lineTo(-fish.size * 0.8, size.height * 0.5);
    tailPath.lineTo(0, size.height * 0.7);
    canvas.drawPath(tailPath, tailPaint);

    // Глаз
    canvas.drawCircle(
      Offset(size.width * 0.7, size.height * 0.4),
      fish.size * 0.2,
      Paint()..color = Colors.white,
    );

    canvas.drawCircle(
      Offset(size.width * 0.75, size.height * 0.4),
      fish.size * 0.1,
      Paint()..color = Colors.black,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class _HookPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // Леска
    final linePaint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    canvas.drawLine(
      Offset(size.width / 2, 0),
      Offset(size.width / 2, size.height * 0.8),
      linePaint,
    );

    // Крючок
    final hookPaint = Paint()
      ..color = Colors.grey[800]!
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;

    final hookPath = Path();
    hookPath.moveTo(size.width / 2, size.height * 0.8);
    hookPath.quadraticBezierTo(
      size.width / 2 + 10,
      size.height * 0.85,
      size.width / 2 - 5,
      size.height * 0.9,
    );
    canvas.drawPath(hookPath, hookPaint);

    // Поплавок
    canvas.drawCircle(
      Offset(size.width / 2, size.height * 0.3),
      8,
      Paint()..color = Colors.red,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}