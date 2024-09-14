import 'dart:ui';

import 'package:flame/components.dart';
import 'package:solitaire_game/constants.dart';
import 'package:solitaire_game/main.dart';

import 'card_for_game.dart';

class Pile extends PositionComponent {
  int pileNumber = 0;

  @override
  bool get debugMode => isDebugMode;

  List<Cards> cards = [];

  @override
  String toString() {
    return "Pile $pileNumber";
  }

  @override
  void render(Canvas canvas) {
    Paint blackBorderPaint = Paint()
      ..color = Constants.pileBorderColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    Rect rect = Rect.fromLTRB(0, 0, size.x, size.y);

    var pile =
        RRect.fromRectAndRadius(rect, Radius.circular(CardsGame.cardRadius));
    canvas.drawRRect(
      pile,
      blackBorderPaint,
    );
    super.render(canvas);
  }
}
