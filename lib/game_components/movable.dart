
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart' hide Draggable;

class Movable extends SpriteComponent with DragCallbacks {
  Vector2? dragDeltaPosition;

  Movable() : super(size: Vector2(1000, 1000)){

  (Sprite.load('cards-sprites.png')).then((value){
  sprite = value;
  });

    anchor = Anchor.center;
  }

  @override
  bool onDragStart(DragStartEvent info) {
    super.onDragStart(info);
    print("onDragStart");
    // position = Vector2(position.x + 40, position.y + 40);
    dragDeltaPosition = info.localPosition - position;
    return false;
  }

  @override
  bool onDragUpdate(DragUpdateEvent info) {
    super.onDragUpdate(info);
    // if (parent is! World) {
    //   return true;
    // }
    // final dragDeltaPosition = this.dragDeltaPosition;
    // if (dragDeltaPosition == null) {
    //   return false;
    // }
    position = info.localDelta;

    // position.setFrom(info.eventPosition.game - dragDeltaPosition);

    return false;
  }

  @override
  bool onDragEnd(_) {
    super.onDragEnd(_);
    dragDeltaPosition = null;
    return true;
  }

  @override
  bool onDragCancel(_) {
    super.onDragCancel(_);
    dragDeltaPosition = null;
    return true;
  }

  @override
  void update(double dt) {
    super.update(dt);
    debugColor = isDragged ? Colors.greenAccent : Colors.purple;
  }
}
