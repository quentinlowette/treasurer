import 'package:flutter/material.dart';
import 'package:treasurer/ui/colors.dart';

export 'pieChart.dart';

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

  Chart({@required this.painter});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: this.painter,
    );
  }
}
