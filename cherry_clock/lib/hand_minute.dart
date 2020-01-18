// Copyright 2020 Mike Melnikov. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import 'dart:math' as math;
import 'package:flutter/material.dart';

class HandMinute extends StatelessWidget {
  const HandMinute({
    @required this.color,
    @required this.angleRadians,
  })  : assert(color != null),
        assert(angleRadians != null);

  // Minute hand color
  final Color color;

  // Minute hand rotation angle
  final double angleRadians;

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: CustomPaint(
        painter: _HandMinutePainter(
          color: color,
          angleRadians: angleRadians,
        ),
      ),
    );
  }
}

class _HandMinutePainter extends CustomPainter {
  _HandMinutePainter({
    @required this.color,
    @required this.angleRadians,
  })  : assert(color != null),
        assert(angleRadians != null);

  final Color color;
  final double angleRadians;

  @override
  void paint(Canvas canvas, Size size) {
    final radius = size.shortestSide / 2;

    // Parameters of the minute hand for drawing
    final length = 0.57 * radius;
    final width = 7.0;
    final thickness = 2.0;

    // Calculate the size of the rectangle to draw the minute hand
    Rect rect = Offset(-width / 2, -width / 2) & Size(width, length);

    final handPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = thickness
      ..strokeCap = StrokeCap.butt;

    // Draw the minute hand
    canvas.save();
    canvas.translate(radius, radius);
    canvas.rotate(this.angleRadians - math.pi);
    canvas.drawRect(rect, handPaint);
    canvas.restore();
  }

  @override
  bool shouldRepaint(_HandMinutePainter oldDelegate) {
    return oldDelegate.angleRadians != angleRadians ||
        oldDelegate.color != color;
  }
}
