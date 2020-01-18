// Copyright 2020 Mike Melnikov. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import 'dart:math' as math;
import 'package:flutter/material.dart';

class HandSecond extends StatelessWidget {
  const HandSecond({
    @required this.color,
    @required this.angleRadians,
  })  : assert(color != null),
        assert(angleRadians != null);

  // Second hand color
  final Color color;

  // Second hand rotation angle
  final double angleRadians;

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: CustomPaint(
        painter: _HandSecondPainter(
          color: color,
          angleRadians: angleRadians,
        ),
      ),
    );
  }
}

class _HandSecondPainter extends CustomPainter {
  _HandSecondPainter({
    @required this.color,
    @required this.angleRadians,
  })  : assert(color != null),
        assert(angleRadians != null);

  final Color color;
  final double angleRadians;

  @override
  void paint(Canvas canvas, Size size) {
    final radius = size.shortestSide / 2;

    // The minimum and maximum radius of the spiral for drawing the path of the second hand
    final radiusMin = radius * 0.68;
    final radiusMax = radius * 0.82;

    // Parameters of the second hand for drawing
    final length =
        radiusMin + (radiusMax - radiusMin) * (angleRadians / (2 * math.pi));
    final thickness = 2.0;
    final dotRadius = 5.0;

    final handPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = thickness
      ..strokeCap = StrokeCap.butt;

    final dotPaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    // Draw the second hand
    canvas.save();
    canvas.translate(radius, radius);
    canvas.rotate(this.angleRadians - math.pi);
    canvas.drawLine(Offset(0, -length * 0.22), Offset(0, length), handPaint);

    // Draw the dot at the end of the second hand
    canvas.drawCircle(Offset(0, length), dotRadius, dotPaint);
    canvas.restore();
  }

  @override
  bool shouldRepaint(_HandSecondPainter oldDelegate) {
    return oldDelegate.angleRadians != angleRadians ||
        oldDelegate.color != color;
  }
}
