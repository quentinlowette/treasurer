import 'package:flutter/material.dart';
import 'package:treasurer/ui/colors.dart';

export 'pie_chart.dart';

abstract class ChartPainter extends CustomPainter {
  final List<Color> colors = [
    DefaultThemeColors.blue,
    DefaultThemeColors.orange
  ];

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

class Chart extends StatelessWidget {
  final CustomPainter painter;
  final Widget child;

  Chart({@required this.painter, this.child});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: this.painter,
      child: this.child,
    );
  }
}
