import 'dart:ui';

import 'package:flame/components.dart';
import 'package:solitaire_game/main.dart';

import 'card_for_game.dart';

class Pile extends PositionComponent {
  int pileNumber = 0;

  @override
  bool get debugMode => kDebugMode;

  List<Cards> cards = [];

  @override
  String toString() {
    return "Pile $pileNumber";
  }

  @override
  void render(Canvas canvas) {

    Paint blackBorderPaint = Paint()
      ..color = Color.fromARGB(255, 141, 141, 141)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    canvas.drawRect(Rect.fromLTRB(0, 0, size.x, size.y), blackBorderPaint);
    super.render(canvas);
  }
}
