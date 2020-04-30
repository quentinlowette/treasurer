import 'package:flutter/material.dart';
import 'package:treasurer/core/models/actor.m.dart';

/// Radio button like selection for the Actors objects
class ActorPicker extends StatelessWidget {

  final Actor currentActor;
  final Actor differentFrom;
  final void Function(Actor actor) onTap;
  final Widget title;

  const ActorPicker({Key key, @required this.currentActor, @required this.differentFrom, @required this.onTap, @required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        this.title,
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            RaisedButton(
              onPressed: differentFrom == Actor.cash ? null : () => onTap(Actor.cash),
              child: Icon(Icons.local_atm),
              color: currentActor == Actor.cash ? Theme.of(context).accentColor : null,
              textColor: currentActor == Actor.cash ? Colors.white : null,
            ),
            RaisedButton(
              onPressed: differentFrom == Actor.bank ? null : () => onTap(Actor.bank),
              child: Icon(Icons.account_balance),
              color: currentActor == Actor.bank ? Theme.of(context).accentColor : null,
              textColor: currentActor == Actor.bank ? Colors.white : null,
            ),
            RaisedButton(
              onPressed: differentFrom == Actor.extern ? null : () => onTap(Actor.extern),
              child: Icon(Icons.person_add),
              color: currentActor == Actor.extern ? Theme.of(context).accentColor : null,
              textColor: currentActor == Actor.extern ? Colors.white : null,
            ),
          ],
        ),
      ],
    );
  }
}
