import 'package:flame/components.dart';
import 'package:flame/experimental.dart';
import 'package:flame/input.dart';
import 'package:flutter/material.dart' hide Draggable;

class Movable extends SpriteComponent with Draggable {
  Vector2? dragDeltaPosition;

  Movable() : super(size: Vector2(1000, 1000));

  @override
  void render(Canvas canvas) {
    super.render(canvas);
  }

  Future<void> onLoad() async {
    sprite = await Sprite.load('cards-sprites.png');
    anchor = Anchor.center;
  }

  @override
  bool onDragStart(DragStartInfo info) {
    print("onDragStart");
    // position = Vector2(position.x + 40, position.y + 40);
    dragDeltaPosition = info.eventPosition.game - position;
    return false;
  }

  @override
  bool onDragUpdate(DragUpdateInfo info) {
    // if (parent is! World) {
    //   return true;
    // }
    // final dragDeltaPosition = this.dragDeltaPosition;
    // if (dragDeltaPosition == null) {
    //   return false;
    // }
    position = info.eventPosition.game;

    // position.setFrom(info.eventPosition.game - dragDeltaPosition);

    return false;
  }

  @override
  bool onDragEnd(DragEndInfo _) {
    dragDeltaPosition = null;
    return true;
  }

  @override
  bool onDragCancel() {
    dragDeltaPosition = null;
    return true;
  }

  @override
  void update(double dt) {
    super.update(dt);
    debugColor = isDragged ? Colors.greenAccent : Colors.purple;
  }
}
