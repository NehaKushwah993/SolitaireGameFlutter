class CardDetail {
  int suit = 0, rank = 0;

  CardDetail(this.rank, this.suit);

  @override
  String toString() {
    return suit.toString() + "-" + rank.toString();
  }
}