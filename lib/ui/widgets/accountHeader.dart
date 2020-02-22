import 'package:flutter/material.dart';

class AccountHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Container(
        height: 255,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            stops: [0.3, 0.9],
            colors: [
              Colors.greenAccent,
              Theme.of(context).primaryColor,
            ],
          ),
          borderRadius: BorderRadius.only(
            bottomLeft:
                Radius.elliptical(MediaQuery.of(context).size.width * 0.50, 18),
            bottomRight:
                Radius.elliptical(MediaQuery.of(context).size.width * 0.50, 18),
          ),
        ),
        child: Center(
          child: Text("Header", style: Theme.of(context).textTheme.headline3,),
        ),
      );
}
