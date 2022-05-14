import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/input.dart';
import 'package:flutter/material.dart' show Colors;
import 'package:solitaire_game/main.dart';

class DraggableSquare extends PositionComponent
    with Draggable, HasGameRef<CardsGame> {
  @override
  bool debugMode = true;

  Vector2? originalPos;

  DraggableSquare({Vector2? position})
      : super(
          position: position ?? Vector2.all(100),
          size: Vector2.all(100),
        );

  Vector2? dragDeltaPosition;

  bool get isDragging => dragDeltaPosition != null;

  @override
  void update(double dt) {
    super.update(dt);
    debugColor = isDragging ? Colors.greenAccent : Colors.purple;
  }

  @override
  bool onDragStart(DragStartInfo info) {
    dragDeltaPosition = info.eventPosition.game - position;
    return false;
  }

  @override
  bool onDragUpdate(DragUpdateInfo event) {
    final dragDeltaPosition = this.dragDeltaPosition;
    if (dragDeltaPosition == null) {
      return false;
    }
    position.x = 0;
    position.y = 0;

    // position.setFrom(event.eventPosition.game - dragDeltaPosition);
    return false;
  }

  @override
  bool onDragEnd(_) {
    dragDeltaPosition = null;
    position.x = 0;
    position.y = 0;
    return false;
  }

  @override
  bool onDragCancel() {
    dragDeltaPosition = null;
    position.x = 0;
    position.y = 0;
    return false;
  }
}
