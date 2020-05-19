/// The different kind of actors that can be involved in an operation.
enum ActorType {
  /// The cash box.
  cash,
  /// The bank account.
  bank,
  /// An external person.
  extern
}

/// An actor involved in an operation.
class Actor {
  /// The actor's type
  final ActorType _actorType;

  Actor(this._actorType);

  /// Returns `true` if this actor is of type `type`.
  bool hasType(ActorType type) {
    return this._actorType == type;
  }

  /// Returns a integer representation of this actor.
  int toInteger() {
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
