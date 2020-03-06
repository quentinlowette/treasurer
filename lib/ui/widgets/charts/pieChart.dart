import 'dart:math';

import 'package:flutter/material.dart';
import 'package:treasurer/ui/widgets/charts/charts.dart';

class PieChartPainter extends ChartPainter {
  final List<double> fractions;

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
}
