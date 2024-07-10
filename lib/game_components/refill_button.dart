import 'package:flame/components.dart';
import 'package:flame/extensions.dart';
import 'package:flutter/material.dart' hide Draggable;
import '../main.dart';

class RefillButton extends PositionComponent {
  @override
  bool debugMode = kDebugMode;

  RefillButton() : super();

  @override
  void render(Canvas canvas) {
    reloadSprite(0, 0, 32,32).render(canvas,);
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

}
