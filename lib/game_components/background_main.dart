import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';
import 'package:solitaire_game/constants.dart';
import 'package:solitaire_game/main.dart';

class Background extends PositionComponent with TapCallbacks, DragCallbacks {
  Function? onTap;

  @override
  bool get debugMode => isDebugMode;

  @override
  void render(Canvas canvas) {
    canvas.drawColor(Constants.backgroundColor, BlendMode.hardLight);
    super.render(canvas);
  }

  @override
  void onTapUp(TapUpEvent event) {
    onTap?.call();
    super.onTapUp(event);
  }
}
