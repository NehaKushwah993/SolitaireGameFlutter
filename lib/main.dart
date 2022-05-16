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

  List<CardDetail> allCards = [];

  late List<Pile> piles;
  late List<Foundation> foundations;

  static double minHeightToAttachCardToPile = 70;

  double gapInVerticalCards = 40;

  Vector2 positionForStockCards() => Vector2(cardGap, cardGap);

  Vector2 positionForWasteCards() => Vector2(cardGap * 2 + cardWidth, cardGap);

  @override
  Future<void>? onLoad() async {
    cardWidth = size.toRect().size.height * .2;
    cardHeight = cardWidth / 0.71;
    cardSize = Vector2(cardWidth, cardHeight);
    buttonSize = Vector2(30, 30);
    gapInVerticalCards = size.toRect().size.height * .03;

    await Flame.images.load('cards-sprites.png');

    final stock = Stock()
      ..size = cardSize
      ..position = positionForStockCards();
    final waste = Waste()
      ..size = cardSize
      ..position = positionForWasteCards();
    foundations = List.generate(
      4,
      (index) => Foundation()
        ..size = cardSize
        ..position =
            Vector2((index + 3) * (cardWidth + cardGap) + cardGap, cardGap),
    );

    piles = List.generate(
      7,
      (i) => Pile()
        ..pileNumber = i
        ..size = cardSize
        ..position = Vector2(
          cardGap + i * (cardWidth + cardGap),
          cardHeight + 3 * cardGap,
        ),
    );

    add(stock);
    addAll(piles);
    addAll(foundations);
    add(waste);

    _addButtonToRefillStock();
    _generateCards();
    _attachInitialCards();
    _addTopCardToStock();
  }

  List<CardDetail> stock = [];
  List<Cards> waste = [];

  void _generateCards() {
    for (int suit = 0; suit < 4; suit++) {
      for (int rank = 1; rank <= 13; rank++) {
        CardDetail card = CardDetail(rank, suit);
        allCards.add(card);
      }
    }
  }

  void moveFromStockToWaste(Cards card) {
    card.position = positionForWasteCards();
    card.onTap = null;
    card.isDraggable = true;
    card.setFaceUp(true);
    stock.removeLast();
    waste.add(card);
    _addTopCardToStock();
  }

  void _addTopCardToStock({bool addToo = true}) {
    if (stock.isNotEmpty) {
      CardDetail cardDetail = stock.last;

      Cards card = _createCardsByDetail(cardDetail);
      card.position = positionForStockCards();
      card.setFaceUp(false);
      card.isDraggable = false;
      card.onTap = () {
        moveFromStockToWaste(card);
      };

      if (addToo) {
        add(card);
      }
    }
  }

  void _moveCardsBackToStock() {
    print("_moveCardsBackToStock ${stock.length}");
    reorderChildren();
    for (var card in waste.reversed) {
      stock.add(CardDetail(card.rank.value, card.suit.value));
    }
    for (var element in waste) {
      element.removeFromParent();
    }
    waste = [];
    Future.delayed(const Duration(milliseconds: 100), () {
      _addTopCardToStock();
    });
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

  Pile? canAttachToPile(Cards card) {
    Pile? nearestPile;

    double x1 = card.x;
    double y1 = card.y;

    for (Pile pile in piles) {
      nearestPile ??= pile;
      double nearestDifference = abs(nearestPile.x - x1);
      double currentDifference = abs(pile.x - x1);

      if (nearestDifference > currentDifference) {
        nearestPile = pile;
      }
    }

    // Check for y
    if (nearestPile != null) {
      double verticalDiff = 0;
      if (nearestPile.cards.isNotEmpty) {
        verticalDiff = abs(nearestPile.cards.last.y - y1);
      } else {
        verticalDiff = abs((nearestPile.position.y) - y1);
      }
      if (verticalDiff > minHeightToAttachCardToPile) {
        return null;
      }
    }
    if (!_canBeAttachedToPileBySequence(nearestPile!, card)) {
      return null;
    }

    print("nearestPile == ${nearestPile.toString()}");
    return nearestPile;
  }

  Foundation? canAttachToFoundation(Cards card) {
    Foundation? nearestFoundation;

    double x1 = card.x;
    double y1 = card.y;

    for (Foundation foundation in foundations) {
      nearestFoundation ??= foundation;
      double nearestDifference = abs(nearestFoundation.x - x1);
      double currentDifference = abs(foundation.x - x1);

      if (nearestDifference > currentDifference) {
        nearestFoundation = foundation;
      }
    }

    // Check for y
    if (nearestFoundation != null) {
      double verticalDiff = 0;
      if (nearestFoundation.cards.isNotEmpty) {
        verticalDiff = abs(nearestFoundation.cards.last.y - y1);
      } else {
        verticalDiff = abs((nearestFoundation.position.y) - y1);
      }
      if (verticalDiff > minHeightToAttachCardToPile) {
        return null;
      }
    }
    if (!_canBeAttachedToFoundationBySequence(nearestFoundation!, card)) {
      return null;
    }

    print("nearestFoundation == ${nearestFoundation.toString()}");
    return nearestFoundation;
  }

  abs(double value) {
    if (value < 0) return -value;
    return value;
  }

  /// This will attach the card and its bottom cards to the pile
  /// whether its same pile or new pile
  void attachCardToPile(Pile pile, Cards cardToAdd) {
    List<Cards> cardsToAdd = [];
    cardsToAdd.add(cardToAdd);
    cardsToAdd.addAll(cardToAdd.otherCards);

    int fromLength = pile.cards.length;

    if (pile.cards.contains(cardToAdd)) {
      // From same pile
      int indexAtPile = pile.cards.indexOf(cardToAdd);
      fromLength = indexAtPile;
    }

    for (var card in cardsToAdd) {
      removeCardFromItsParentListHolder(card);
      card.position = Vector2(
          pile.position.x, pile.position.y + (fromLength * gapInVerticalCards));

      card.isDraggable = true;
      card.onCardDragStart = () {
        card.otherCards = [];
        bool found = false;
        for (var cardInPile in pile.cards) {
          if (found) {
            card.otherCards.add(cardInPile);
          }
          if (cardInPile == card) {
            found = true;
          }
        }
      };
      pile.cards.add(card);
      fromLength++;
    }
  }

  /// This will attach the card and its bottom cards to the pile
  /// whether its same pile or new pile
  void attachCardToFoundation(Foundation foundation, Cards cardToAdd) {
    List<Cards> cardsToAdd = [];
    cardsToAdd.add(cardToAdd);
    cardsToAdd.addAll(cardToAdd.otherCards);

    for (var card in cardsToAdd) {
      removeCardFromItsParentListHolder(card);
      card.position = Vector2(foundation.position.x, foundation.position.y);
      card.isDraggable = false;
      card.onCardDragStart = () {
        card.otherCards = [];
        bool found = false;
        for (var cardInPile in foundation.cards) {
          if (found) {
            card.otherCards.add(cardInPile);
          }
          if (cardInPile == card) {
            found = true;
          }
        }
      };
      foundation.cards.add(card);
    }
  }

  void removeCardFromItsParentListHolder(Cards card) {
    waste.remove(card);
    for (var pile in piles) {
      pile.cards.remove(card);
    }
  }

  bool _canBeAttachedToPileBySequence(Pile nearestPile, Cards card) {
    if (nearestPile.cards.isEmpty) return true;

    if (nearestPile.cards.last.suit.isBlack != card.suit.isBlack) {
      if (nearestPile.cards.last.rank.value - card.rank.value == 1) {
        return true;
      }
    }

    return false;
  }

  bool _canBeAttachedToFoundationBySequence(
      Foundation nearestFoundation, Cards card) {
    if (nearestFoundation.cards.isEmpty) {
      // 'A' cards can be attached
      return card.rank.value == 1;
    }

    if (nearestFoundation.cards.last.suit.value == card.suit.value) {
      if (nearestFoundation.cards.last.rank.value - card.rank.value == -1) {
        return true;
      }
    }

    return false;
  }

  void _attachInitialCards() {
    List<CardDetail> cards = [];
    cards.addAll(allCards);
    cards.shuffle();

    //Add cards to the piles
    for (int pileNumber = 0; pileNumber < piles.length; pileNumber++) {
      for (int card = 0; card <= pileNumber; card++) {
        CardDetail cardDetail = cards[0];
        Cards cardToBeAdded = _createCardsByDetail(cardDetail);
        cardToBeAdded.setFaceUp(false);
        cardToBeAdded.isDraggable = true;

        add(cardToBeAdded);

        attachCardToPile(piles[pileNumber], cardToBeAdded);
        cards.removeAt(0);
      }

      piles[pileNumber]
          .cards[piles[pileNumber].cards.length - 1]
          .setFaceUp(true);
    }

    //Add remaining cards to stock
    stock.addAll(cards);
  }

  Cards _createCardsByDetail(CardDetail cardDetail) {
    Cards card = Cards(cardDetail.rank, cardDetail.suit);

    card.attachToPileOrFoundation = () {
      //Set by pile
      Pile? pile = canAttachToPile(card);
      if (pile != null) {
        attachCardToPile(pile, card);
        _faceUpLastCardsOfPiles();
        _checkIfWon();
        return;
      }
      //Set by foundation
      Foundation? foundation = canAttachToFoundation(card);
      if (foundation != null) {
        attachCardToFoundation(foundation, card);
        _faceUpLastCardsOfPiles();
        _checkIfWon();
        return;
      }

      // Set by waste or move to last pos
      if (waste.contains(card)) {
        card.position = positionForWasteCards();
      } else {
        // move to its last pile
        for (var pile in piles) {
          if (pile.cards.contains(card)) {
            attachCardToPile(pile, card);
            break;
          }
        }
      }
    };

    return card;
  }

  _faceUpLastCardsOfPiles() {
    for (var pile in piles) {
      if (pile.cards.isNotEmpty) {
        pile.cards.last.setFaceUp(true);
      }
    }
  }



  void _checkIfWon() {
    for (var foundation in foundations) {
      if(foundation.cards.length != 13){
        return;
      }
    }

    //TODO : Won, show button to restart the game
  }
}

class CardDetail {
  int suit = 0, rank = 0;

  CardDetail(this.rank, this.suit);

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
