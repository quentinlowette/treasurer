import 'dart:math';

import 'package:flutter/material.dart';
import 'package:treasurer/ui/colors.dart';

class PieChart extends StatelessWidget {
  final List<double> fractions;

  PieChart({@required this.fractions});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: PieChartPainter(fractions: fractions),
    );
  }

}

class PieChartPainter extends CustomPainter {
  final List<double> fractions;

  List<Color> colors = [DefaultThemeColors.blue, DefaultThemeColors.orange];

  PieChartPainter({@required this.fractions});

  @override
  void paint(Canvas canvas, Size size) {
    List<List<Paint>> paints = List<List<Paint>>();
    for (var i = 0; i < fractions.length; i++) {
      Paint borderPaint = Paint()
        ..color = colors[i]
        ..strokeWidth = 4.0
        ..style = PaintingStyle.stroke;

      Paint fillPaint = Paint()
        ..color = colors[i].withAlpha(64)
        ..style = PaintingStyle.fill;

      paints.add([borderPaint, fillPaint]);
    }

    Offset center = Offset(size.width / 2, size.height / 2);

    double radius = 50.0;

    double angle = -pi / 2;

    for (var i = 0; i < fractions.length; i++) {
      canvas.drawArc(Rect.fromCircle(center: center, radius: radius), angle,
          2 * pi * fractions[i], false, paints[i][0]);
      canvas.drawArc(Rect.fromCircle(center: center, radius: radius), angle,
          2 * pi * fractions[i], true, paints[i][1]);
      angle += 2 * pi * fractions[i];
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
