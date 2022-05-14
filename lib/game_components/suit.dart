import 'package:flame/components.dart';
import 'package:flutter/cupertino.dart';

import '../main.dart';

@immutable
class Suit {
  static late final List<Suit> _singletons = [
    Suit._(0, '♥', 1176, 17, 172, 183),
    Suit._(1, '♦', 973, 14, 177, 182),
    Suit._(2, '♣', 974, 226, 184, 172),
    Suit._(3, '♠', 1178, 220, 176, 182),
  ];
  final int value;
  final String label;
  final Sprite sprite;

  /// Hearts and Diamonds are red, while Clubs and Spades are black.
  bool get isRed => value <= 1;

  bool get isBlack => value >= 2;

  Suit._(
      this.value, this.label, double x, double y, double width, double height)
      : sprite = cardsSprite(x, y, width, height);

  factory Suit.fromInt(int index) {
    assert(index >= 0 && index <= 3);
    return _singletons[index];
  }
}
