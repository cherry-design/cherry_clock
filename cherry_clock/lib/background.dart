// Copyright 2020 Mike Melnikov. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import 'dart:math' as math;
import 'package:flutter/material.dart';

class Background extends StatelessWidget {
  const Background({
    @required this.color,
    @required this.angleRadians,
  })  : assert(color != null),
        assert(angleRadians != null);

  // Background color
  final Color color;

  // Background rotation angle
  final double angleRadians;

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: SizedBox.expand(
        child: CustomPaint(
          painter: _BackgroundPainter(
            color: color,
            angleRadians: angleRadians,
          ),
        ),
      ),
    );
  }
}

class _BackgroundPainter extends CustomPainter {
  _BackgroundPainter({
    @required this.color,
    @required this.angleRadians,
  })  : assert(color != null),
        assert(angleRadians != null);

  final Color color;
  final double angleRadians;

  @override
  void paint(Canvas canvas, Size size) {
    // Calculate the size of the rectangle to draw the background
    Rect rect = Offset(-size.width, -size.height * 2) &
        Size(size.width * 2, size.height * 2);

    final backgroundPaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    // Draw background
    canvas.save();
    canvas.translate(size.width / 2, size.height / 2);
    canvas.rotate(this.angleRadians - math.pi / 2);
    canvas.drawRect(rect, backgroundPaint);
    canvas.restore();
  }

  @override
  bool shouldRepaint(_BackgroundPainter oldDelegate) {
    return oldDelegate.angleRadians != angleRadians ||
        oldDelegate.color != color;
  }
}
