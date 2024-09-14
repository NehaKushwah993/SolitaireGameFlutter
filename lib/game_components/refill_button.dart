import 'package:flame/components.dart';
import 'package:flame/extensions.dart';
import 'package:flame/flame.dart';
import 'package:flutter/material.dart' hide Draggable;
import '../main.dart';

class RefillButton extends PositionComponent {
  @override
  // ignore: overridden_fields
  bool debugMode = isDebugMode;

  RefillButton() : super();

  Sprite reloadSprite(double x, double y, double width, double height) {
    return Sprite(
      Flame.images.fromCache('reload.png'),
      srcPosition: Vector2(x, y),
      srcSize: Vector2(width, height),
    );
  }

  @override
  void render(Canvas canvas) {
    reloadSprite(0, 0, 32, 32).render(
      canvas,
    );
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
