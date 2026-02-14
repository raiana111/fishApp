import 'dart:math';
import 'package:flutter/material.dart';

enum FishSize { small, medium, large }

class Fish {
  final String id;
  final FishSize size;
  final Color color;
  final double speed;
  double x;
  double y;
  double dx;
  double dy;

  Fish({
    required this.id,
    required this.size,
    required this.color,
    required this.speed,
    required this.x,
    required this.y,
    required this.dx,
    required this.dy,
  });

  double get radius {
    switch (size) {
      case FishSize.small:
        return 15.0;
      case FishSize.medium:
        return 25.0;
      case FishSize.large:
        return 35.0;
    }
  }

  int get points {
    switch (size) {
      case FishSize.small:
        return 1;
      case FishSize.medium:
        return 2;
      case FishSize.large:
        return 3;
    }
  }

  void move(double width, double height) {
    x += dx * speed;
    y += dy * speed;

    // Отскок от границ
    if (x - radius <= 0 || x + radius >= width) {
      dx *= -1;
      x = x.clamp(radius, width - radius);
    }

    if (y - radius <= 0 || y + radius >= height) {
      dy *= -1;
      y = y.clamp(radius, height - radius);
    }
  }

  bool isCaught(double touchX, double touchY) {
    final distance = sqrt(pow(x - touchX, 2) + pow(y - touchY, 2));
    return distance <= radius * 1.5;
  }
}