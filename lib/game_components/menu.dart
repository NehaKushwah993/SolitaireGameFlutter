import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:solitaire_game/game_components/button.dart';

class Menu extends PositionComponent {
  double paddingRight = 16;
  Function? onNewGame;

  Menu({var size, this.onNewGame}) : super(size: size);

  @override
  void render(Canvas canvas) {
    Paint blackBorderPaint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.fill;
    canvas.drawRect(Rect.fromLTRB(0, 0, size.x, size.y), blackBorderPaint);

    var widthOfButton = 100.0;
    var heightOfButton = 40.0;

    final xCenter = (size.toRect().size.width - widthOfButton) - paddingRight;
    final yCenter = (size.toRect().size.height - heightOfButton) / 2;

    var newGameButton = Button(
        text: "New Game",
        onTap: () {
          onNewGame?.call();
        });

    newGameButton.width = widthOfButton;
    newGameButton.height = heightOfButton;
    newGameButton.position = Vector2(xCenter, yCenter);

    add(newGameButton);

    super.render(canvas);
  }
}
