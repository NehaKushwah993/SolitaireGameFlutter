import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';

class Button extends PositionComponent with TapCallbacks {
  Function? onTap;

  Button({this.onTap});

  @override
  void onTapUp(TapUpEvent event) {
    onTap?.call();
    super.onTapUp(event);
  }

  @override
  void render(Canvas canvas) {
    const textStyle = TextStyle(
      color: Colors.white,
      fontSize: 16,
    );
    const textSpan = TextSpan(
      text: 'New game',
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
    var offset = Offset(0, size.toRect().size.height / 4);
    textPainter.paint(canvas, offset);

    super.render(canvas);
  }
}
