/// Actors involved in an Operation
enum ActorType {
  /// Represents the cash register
  cash,
  /// Represents the bank account
  bank,
  /// Represents an external person
  extern
}

class Actor {
  final ActorType _actorType;

  Actor(this._actorType);

  bool hasType(ActorType type) {
    return this._actorType == type;
  }

  int toIndex() {
    return this._actorType.index;
  }

  @override
  String toString() {
    switch (this._actorType) {
      case ActorType.bank:
        return "Compte";
      case ActorType.cash:
        return "Caisse";
      case ActorType.extern:
        return "Externe";
      default:
        return "";
    }
  }
}
