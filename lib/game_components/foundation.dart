import 'package:flame/components.dart';

import 'card_for_game.dart';

class Foundation extends PositionComponent {
  int foundationNumber = 0;

  @override
  bool get debugMode => true;

  List<Cards> cards = [];
}
