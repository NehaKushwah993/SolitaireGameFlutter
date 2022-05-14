import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flutter/material.dart';

import 'game_components/game_components.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  Flame.device.setLandscape();

  runApp(GameWidget(game: CardsGame()));
}

class CardsGame extends FlameGame
    with HasDraggables, HasCollisionDetection, HasTappables {
  static double cardWidth = 90;
  static double cardHeight = 160;
  static double cardGap = 15;
  static double cardRadius = 5;
  static late final Vector2 cardSize;
  static late final Vector2 buttonSize;

  Vector2 positionForStockCards() => Vector2(cardGap, cardGap);

  Vector2 positionForWasteCards() => Vector2(cardGap * 2 + cardWidth, cardGap);

  @override
  Future<void>? onLoad() async {
    cardWidth = size.toRect().size.height * .2;
    cardHeight = cardWidth / 0.71;
    cardSize = Vector2(cardWidth, cardHeight);
    buttonSize = Vector2(30, 30);

    await Flame.images.load('cards-sprites.png');

    final stock = Stock()
      ..size = cardSize
      ..position = positionForStockCards();
    final waste = Waste()
      ..size = cardSize
      ..position = Vector2(cardGap * 2 + cardWidth, cardGap);
    final foundations = List.generate(
      4,
      (index) => Foundation()
        ..size = cardSize
        ..position =
            Vector2((index + 3) * (cardWidth + cardGap) + cardGap, cardGap),
    );

    final piles = List.generate(
      7,
      (i) => Pile()
        ..size = cardSize
        ..position = Vector2(
          cardGap + i * (cardWidth + cardGap),
          cardHeight + 2 * cardGap,
        ),
    );

    add(stock);
    addAll(piles);
    addAll(foundations);
    add(waste);

    _addButtonToRefillStock();
    addAllCardsToStockById();
    _addTopCardToStock();
  }

  List<CardType> stock = [];
  List<CardType> waste = [];
  List<Cards> wasteCards = [];

  void addAllCardsToStockById() {
    for (int suit = 0; suit < 4; suit++) {
      for (int rank = 1; rank <= 13; rank++) {
        stock.add(
          CardType()
            ..suit = suit
            ..rank = rank,
        );
      }
    }
    stock.shuffle();
  }

  void moveFromStockToWaste(CardType cardDetails, Cards card) {
    card.position = positionForWasteCards();
    card.onTap = null;
    card.isDraggable = true;
    card.setFaceUp(true);
    stock.removeLast();
    waste.add(cardDetails);
    wasteCards.add(card);
    _addTopCardToStock();
  }

  void _addTopCardToStock() {
    if (stock.isNotEmpty) {
      CardType cardDetails = stock.last;

      Cards card =
          Cards(cardDetails.rank, cardDetails.suit, positionForStockCards());
      card.setFaceUp(false);
      card.isDraggable = false;
      card.onTap = () {
        moveFromStockToWaste(cardDetails, card);
      };

      add(card);
    }
  }

  void _moveCardsBackToStock() {
    print("_moveCardsBackToStock");
    for (var cardDetail in waste.reversed) {
      stock.add(cardDetail);
    }
    waste = [];
    for (var element in wasteCards) {
      element.removeFromParent();
    }
    _addTopCardToStock();
  }

  void _addButtonToRefillStock() {
    add(
      ButtonComponent(
        button: RefillButton(),
        size: Vector2(30, 30),
        onPressed: () {
          _moveCardsBackToStock();
        },
        position: Vector2(positionForWasteCards().x + cardWidth + cardGap,
            positionForWasteCards().y),
      ),
    );
  }
}

class CardType {
  int suit = 0, rank = 0;

  @override
  String toString() {
    return "-" + suit.toString() + "-" + rank.toString();
  }
}

Sprite cardsSprite(double x, double y, double width, double height) {
  return Sprite(
    Flame.images.fromCache('cards-sprites.png'),
    srcPosition: Vector2(x, y),
    srcSize: Vector2(width, height),
  );
}
