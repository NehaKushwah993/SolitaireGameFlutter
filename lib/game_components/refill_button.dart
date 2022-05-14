import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/experimental.dart';
import 'package:flame/extensions.dart';
import 'package:flame/input.dart';
import 'package:flutter/material.dart' hide Draggable;
import '../main.dart';
import 'game_components.dart';

class RefillButton extends PositionComponent {
  @override
  bool debugMode = true;

  RefillButton() : super();

  @override
  void render(Canvas canvas) {
    _renderBack(canvas);
  }

  static final RRect cardRect = RRect.fromRectAndRadius(
      CardsGame.buttonSize.toRect(), Radius.circular(CardsGame.cardRadius));
  static final RRect innerRect = cardRect.deflate(12);
  static final Paint backBackgroundPaint = Paint()
    ..color = const Color(0xff380c02);
  static final Paint backBorderPaint1 = Paint()
    ..color = const Color(0xffdbaf58)
    ..style = PaintingStyle.stroke
    ..strokeWidth = 2;

  void _renderBack(Canvas canvas) {
    canvas.drawRRect(cardRect, backBackgroundPaint);
    canvas.drawRRect(cardRect, backBorderPaint1);
  }
}
