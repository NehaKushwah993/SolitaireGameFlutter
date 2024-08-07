import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/extensions.dart';
import 'package:flutter/material.dart';
import '../main.dart';
import 'game_components.dart';

class Cards extends PositionComponent with DragCallbacks, TapCallbacks {
  Vector2? dragDeltaPosition;
  List<Vector2?> dragDeltaPositions = [];
  //Cards attached below the current card
  List<Cards> otherCards = [];

  @override
  bool debugMode = kDebugMode;

  var isDraggable;

  Function? onTap;
  Function? attachToPileOrFoundation;

  Function? onCardDragStart;

  Cards(
    int intRank,
    int intSuit, {
    this.isDraggable = true,
    this.onTap,
    this.attachToPileOrFoundation,
    this.onCardDragStart,
  })  : rank = Rank.fromInt(intRank),
        suit = Suit.fromInt(intSuit),
        _faceUp = false,
        super(size: CardsGame.cardSize);

  final Rank rank;
  final Suit suit;
  bool _faceUp;

  bool get isFaceUp => _faceUp;

  void flip() => _faceUp = !_faceUp;

  void setFaceUp(bool faceUp) => _faceUp = faceUp;

  @override
  String toString() => rank.label + suit.label; // e.g. "Q♠" or "10♦"

  @override
  void render(Canvas canvas) {
    if (_faceUp) {
      _renderFront(canvas);
    } else {
      _renderBack(canvas);
    }
  }

  static final RRect cardRect = RRect.fromRectAndRadius(
      CardsGame.cardSize.toRect(), Radius.circular(CardsGame.cardRadius));
  static final RRect innerRect = cardRect.deflate(12);
  static final Paint backBackgroundPaint = Paint()
    ..color = const Color(0xff380c02);
  static final Paint backBorderPaint1 = Paint()
    ..color = const Color(0xffdbaf58)
    ..style = PaintingStyle.stroke
    ..strokeWidth = 2;
  static final Paint backBorderPaint2 = Paint()
    ..color = const Color(0x5CEF971B)
    ..style = PaintingStyle.stroke
    ..strokeWidth = 3;
  static late final Sprite flameSprite = cardsSprite(1367, 6, 357, 501);
  static final Paint frontBackgroundPaint = Paint()
    ..color = const Color(0xff000000);
  static final Paint redBorderPaint = Paint()
    ..color = const Color(0xffece8a3)
    ..style = PaintingStyle.stroke
    ..strokeWidth = 2;
  static final Paint blackBorderPaint = Paint()
    ..color = const Color(0xff7ab2e8)
    ..style = PaintingStyle.stroke
    ..strokeWidth = 2;
  static late final Sprite redJack = cardsSprite(81, 565, 562, 488);
  static late final Sprite redQueen = cardsSprite(717, 541, 486, 515);
  static late final Sprite redKing = cardsSprite(1305, 532, 407, 549);
  static final blueFilter = Paint()
    ..colorFilter = const ColorFilter.mode(
      Color(0x880d8bff),
      BlendMode.srcATop,
    );
  static late final Sprite blackJack = cardsSprite(81, 565, 562, 488)
    ..paint = blueFilter;
  static late final Sprite blackQueen = cardsSprite(717, 541, 486, 515)
    ..paint = blueFilter;
  static late final Sprite blackKing = cardsSprite(1305, 532, 407, 549)
    ..paint = blueFilter;

  void _renderFront(Canvas canvas) {
    canvas.drawRRect(cardRect, frontBackgroundPaint);
    canvas.drawRRect(
      cardRect,
      suit.isRed ? redBorderPaint : blackBorderPaint,
    );

    final rankOfSprite = suit.isBlack ? rank.blackSprite : rank.redSprite;
    final suitSprite = suit.sprite;
    _drawSprite(canvas, rankOfSprite, 0.1, 0.08);
    _drawSprite(canvas, suitSprite, 0.1, 0.18, scale: 0.5);
    _drawSprite(canvas, rankOfSprite, 0.1, 0.08, rotate: true);
    _drawSprite(canvas, suitSprite, 0.1, 0.18, scale: 0.5, rotate: true);
    switch (rank.value) {
      case 1:
        _drawSprite(canvas, suitSprite, 0.5, 0.5, scale: 2.5);
        break;
      case 2:
        _drawSprite(canvas, suitSprite, 0.5, 0.25);
        _drawSprite(canvas, suitSprite, 0.5, 0.25, rotate: true);
        break;
      case 3:
        _drawSprite(canvas, suitSprite, 0.5, 0.2);
        _drawSprite(canvas, suitSprite, 0.5, 0.5);
        _drawSprite(canvas, suitSprite, 0.5, 0.2, rotate: true);
        break;
      case 4:
        _drawSprite(canvas, suitSprite, 0.3, 0.25);
        _drawSprite(canvas, suitSprite, 0.7, 0.25);
        _drawSprite(canvas, suitSprite, 0.3, 0.25, rotate: true);
        _drawSprite(canvas, suitSprite, 0.7, 0.25, rotate: true);
        break;
      case 5:
        _drawSprite(canvas, suitSprite, 0.3, 0.25);
        _drawSprite(canvas, suitSprite, 0.7, 0.25);
        _drawSprite(canvas, suitSprite, 0.3, 0.25, rotate: true);
        _drawSprite(canvas, suitSprite, 0.7, 0.25, rotate: true);
        _drawSprite(canvas, suitSprite, 0.5, 0.5);
        break;
      case 6:
        _drawSprite(canvas, suitSprite, 0.3, 0.25);
        _drawSprite(canvas, suitSprite, 0.7, 0.25);
        _drawSprite(canvas, suitSprite, 0.3, 0.5);
        _drawSprite(canvas, suitSprite, 0.7, 0.5);
        _drawSprite(canvas, suitSprite, 0.3, 0.25, rotate: true);
        _drawSprite(canvas, suitSprite, 0.7, 0.25, rotate: true);
        break;
      case 7:
        _drawSprite(canvas, suitSprite, 0.3, 0.2);
        _drawSprite(canvas, suitSprite, 0.7, 0.2);
        _drawSprite(canvas, suitSprite, 0.5, 0.35);
        _drawSprite(canvas, suitSprite, 0.3, 0.5);
        _drawSprite(canvas, suitSprite, 0.7, 0.5);
        _drawSprite(canvas, suitSprite, 0.3, 0.2, rotate: true);
        _drawSprite(canvas, suitSprite, 0.7, 0.2, rotate: true);
        break;
      case 8:
        _drawSprite(canvas, suitSprite, 0.3, 0.2);
        _drawSprite(canvas, suitSprite, 0.7, 0.2);
        _drawSprite(canvas, suitSprite, 0.5, 0.35);
        _drawSprite(canvas, suitSprite, 0.3, 0.5);
        _drawSprite(canvas, suitSprite, 0.7, 0.5);
        _drawSprite(canvas, suitSprite, 0.3, 0.2, rotate: true);
        _drawSprite(canvas, suitSprite, 0.7, 0.2, rotate: true);
        _drawSprite(canvas, suitSprite, 0.5, 0.35, rotate: true);
        break;
      case 9:
        _drawSprite(canvas, suitSprite, 0.3, 0.2);
        _drawSprite(canvas, suitSprite, 0.7, 0.2);
        _drawSprite(canvas, suitSprite, 0.5, 0.3);
        _drawSprite(canvas, suitSprite, 0.3, 0.4);
        _drawSprite(canvas, suitSprite, 0.7, 0.4);
        _drawSprite(canvas, suitSprite, 0.3, 0.2, rotate: true);
        _drawSprite(canvas, suitSprite, 0.7, 0.2, rotate: true);
        _drawSprite(canvas, suitSprite, 0.3, 0.4, rotate: true);
        _drawSprite(canvas, suitSprite, 0.7, 0.4, rotate: true);
        break;
      case 10:
        _drawSprite(canvas, suitSprite, 0.3, 0.2);
        _drawSprite(canvas, suitSprite, 0.7, 0.2);
        _drawSprite(canvas, suitSprite, 0.5, 0.3);
        _drawSprite(canvas, suitSprite, 0.3, 0.4);
        _drawSprite(canvas, suitSprite, 0.7, 0.4);
        _drawSprite(canvas, suitSprite, 0.3, 0.2, rotate: true);
        _drawSprite(canvas, suitSprite, 0.7, 0.2, rotate: true);
        _drawSprite(canvas, suitSprite, 0.5, 0.3, rotate: true);
        _drawSprite(canvas, suitSprite, 0.3, 0.4, rotate: true);
        _drawSprite(canvas, suitSprite, 0.7, 0.4, rotate: true);
        break;
      case 11:
        _drawSprite(canvas, suit.isRed ? redJack : blackJack, 0.5, 0.5);
        break;
      case 12:
        _drawSprite(canvas, suit.isRed ? redQueen : blackQueen, 0.5, 0.5);
        break;
      case 13:
        _drawSprite(canvas, suit.isRed ? redKing : blackKing, 0.5, 0.5);
        break;
    }
  }

  void _renderBack(Canvas canvas) {
    canvas.drawRRect(cardRect, backBackgroundPaint);
    canvas.drawRRect(cardRect, backBorderPaint1);
    canvas.drawRRect(innerRect, backBorderPaint2);
    flameSprite.render(canvas,
        position: size / 2, anchor: Anchor.center, size: Vector2(10, 10));
  }

  void _drawSprite(
    Canvas canvas,
    Sprite sprite,
    double relativeX,
    double relativeY, {
    double scale = 1,
    bool rotate = false,
  }) {
    if (rotate) {
      canvas.save();
      canvas.translate(size.x / 2, size.y / 2);
      canvas.rotate(pi);
      canvas.translate(-size.x / 2, -size.y / 2);
    }
    sprite.render(
      canvas,
      position: Vector2(relativeX * size.x, relativeY * size.y),
      anchor: Anchor.center,
      size: sprite.srcSize.scaled(0.1),
    );
    if (rotate) {
      canvas.restore();
    }
  }

  @override
  bool onDragStart(DragStartEvent info) {
    super.onDragStart(info);
    if (!isDraggable && isFaceUp) return true;
    onCardDragStart?.call();

    // This allows you to control the order in which your components are rendered.
    int p = 100;
    priority = p;
    for (var element in otherCards) {
      element.priority = ++p;
    }
    dragDeltaPosition = position;
    otherCards.forEach((element) {
      dragDeltaPositions.add(element.position);
    });
    return false;
  }

  @override
  bool onDragUpdate(DragUpdateEvent event) {
    if (!isDraggable || !isFaceUp) return true;
    final dragDeltaPosition = this.dragDeltaPosition;
    if (dragDeltaPosition == null) {
      return false;
    }

    position += event.localDelta;
    for (int i = 0; i < otherCards.length; i++) {

      otherCards[i]
          .position+= event.localDelta;
    }

    return false;
  }

  @override
  bool onDragEnd(_) {
    super.onDragEnd(_);
    // all cards on same level
    priority = 0;
    for (var element in otherCards) {
      element.priority = 0;
    }
    dragDeltaPosition = null;
    dragDeltaPositions.clear();
    attachToPileOrFoundation?.call();
    return false;
  }

  @override
  bool onDragCancel(_) {
    super.onDragCancel(_);
    priority = 0;
    for (var element in otherCards) {
      element.priority = 0;
    }
    dragDeltaPosition = null;
    attachToPileOrFoundation?.call();
    return false;
  }

  @override
  void update(double dt) {
    super.update(dt);
    debugColor = isDragged ? Colors.greenAccent : Colors.purple;
  }

  @override
  bool onTapUp(TapUpEvent _) {
    super.onTapUp(_);
    return true;
  }

  @override
  bool onTapDown(TapDownEvent _) {
    super.onTapDown(_);
    print("onTapDown" + toString());
    onTap?.call();
    return false;
  }

  @override
  bool onTapCancel(_) {
    super.onTapCancel(_);
    print("onTapCancel" + toString());
    return false;
  }
}
