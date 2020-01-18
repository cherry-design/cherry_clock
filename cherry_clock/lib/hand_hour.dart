// Copyright 2020 Mike Melnikov. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import 'dart:math' as math;
import 'package:flutter/material.dart';

class HandHour extends StatelessWidget {
  const HandHour({
    @required this.color,
    @required this.colorDot,
    @required this.angleRadians,
  })  : assert(color != null),
        assert(angleRadians != null);

  // Hour hand and center dot colors
  final Color color;
  final Color colorDot;

  // Hour hand rotation angle
  final double angleRadians;

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: CustomPaint(
        painter: _HandHourPainter(
          color: color,
          colorDot: colorDot,
          angleRadians: angleRadians,
        ),
      ),
    );
  }
}

class _HandHourPainter extends CustomPainter {
  _HandHourPainter({
    @required this.color,
    @required this.colorDot,
    @required this.angleRadians,
  })  : assert(color != null),
        assert(angleRadians != null);

  final Color color;
  final Color colorDot;
  final double angleRadians;

  @override
  void paint(Canvas canvas, Size size) {
    final radius = size.shortestSide / 2;

    // Parameters of the hour hand for drawing
    final length = 0.35 * radius;
    final width = 12.0;

    // Calculate the size of the rectangle to draw the hour hand
    Rect rect = Offset(-width / 2, -width / 1.5) & Size(width, length);

    final handPaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final dotPaint = Paint()
      ..color = colorDot
      ..style = PaintingStyle.fill;

    // Draw the hour hand
    canvas.save();
    canvas.translate(radius, radius);
    canvas.rotate(this.angleRadians - math.pi);
    canvas.drawRect(rect, handPaint);

    // Draw the center point
    canvas.drawCircle(Offset(0, 0), width / 4, dotPaint);
    canvas.restore();
  }

  @override
  bool shouldRepaint(_HandHourPainter oldDelegate) {
    return oldDelegate.angleRadians != angleRadians ||
        oldDelegate.color != color;
  }
}
