
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/extensions.dart';
import 'package:flutter/material.dart';
import 'package:solitaire_game/main.dart';


class AlertGameWon extends PositionComponent with TapCallbacks{

  Function? onTap;

  @override
  bool get debugMode => kDebugMode;


  @override
  void render(Canvas canvas) {

    Paint blackBorderPaint = Paint()
      ..color = Colors.lightBlue
      ..style = PaintingStyle.fill
      ..strokeWidth = 2;
    canvas.drawRect(Rect.fromLTRB(0, 0, size.x, size.y), blackBorderPaint);

 const textStyle = TextStyle(
    color: Colors.black,
    fontSize: 26,
  );
  const textSpan = TextSpan(
    text: 'Congratulations!!\nYou won!!\nClick to restart',
    style: textStyle,
  );
  final textPainter = TextPainter(
    text: textSpan,
    textAlign: TextAlign.center,
    textDirection: TextDirection.ltr,
  );
  textPainter.layout(
    minWidth: 0,
    maxWidth: size.toRect().size.width,
  );
  final xCenter = (size.toRect().size.width - textPainter.width) / 2;
  final yCenter = (size.toRect().size.height - textPainter.height) / 2;
  final offset = Offset(xCenter, yCenter);
  textPainter.paint(canvas, offset);

    super.render(canvas);
  }
  @override
  void onTapUp(TapUpEvent event) {
    onTap?.call();
    super.onTapUp(event);
  }

}