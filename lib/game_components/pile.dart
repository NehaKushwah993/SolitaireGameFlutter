import 'package:flame/components.dart';
import 'package:solitaire_game/main.dart';

import 'card_for_game.dart';

class Pile extends PositionComponent {
  int pileNumber = 0;

  @override
  bool get debugMode => true;

  List<Cards> cards = [];

  @override
  String toString() {
    return "Pile $pileNumber";
  }
}
