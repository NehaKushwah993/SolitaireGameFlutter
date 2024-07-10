import 'dart:ui';

import 'package:flame/components.dart';
import 'package:solitaire_game/main.dart';

import 'card_for_game.dart';

class Foundation extends PositionComponent {
  int foundationNumber = 0;

  @override
  bool get debugMode => kDebugMode;

  List<Cards> cards = [];

  @override
  void render(Canvas canvas) {

    Paint blackBorderPaint = Paint()
      ..color = const Color(0xff7ab2e8)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    canvas.drawRect(Rect.fromLTRB(0, 0, size.x, size.y), blackBorderPaint);
    super.render(canvas);
  }
}
