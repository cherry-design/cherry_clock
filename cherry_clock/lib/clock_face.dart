// Copyright 2020 Mike Melnikov. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import 'dart:math' as math;
import 'package:flutter/material.dart';

class ClockFace extends StatelessWidget {
  const ClockFace({
    @required this.color,
  }) : assert(color != null);

  // Clock face color
  final Color color;

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: CustomPaint(
        painter: _ClockFacePainter(color: color),
      ),
    );
  }
}

// [CustomPainter] to draw the clock face
class _ClockFacePainter extends CustomPainter {
  _ClockFacePainter({
    @required this.color,
  }) : assert(color != null);

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final width = 4.0;
    final radius = size.shortestSide / 2;
    final radiusMin = radius * 0.6;
    final radiusMax = radius * 0.9;

    final angleStep = 4 * math.pi / 120;
    final radiusStep = (radiusMax - radiusMin) / 120;

    final textPainter = TextPainter(
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );

    final textStyle = TextStyle(
      color: color,
      fontFamily: "Roboto",
      fontSize: 14.0,
    );

    final spiralPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = width
      ..strokeCap = StrokeCap.square;

    // For every 1/60 marks
    final markPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1
      ..strokeCap = StrokeCap.butt;

    // For every 1/12 marks
    final markPaint2 = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5
      ..strokeCap = StrokeCap.butt;

    canvas.save();
    canvas.translate(radius, radius);

    // Сreate spiral path
    Path path = Path();
    var radiusCurrent = radiusMin;
    var angleCurrent = -math.pi / 2;
    var position = Offset(0, -radiusCurrent);
    path.moveTo(position.dx, position.dy);
    for (var i = 0; i < 120; i++) {
      radiusCurrent += radiusStep;
      angleCurrent += angleStep;
      position = Offset(math.cos(angleCurrent), math.sin(angleCurrent)) *
          radiusCurrent;
      path.arcToPoint(position, radius: Radius.circular(radiusCurrent));
    }

    // Draw spiral
    canvas.drawPath(path, spiralPaint);

    // Draw marks and numbers
    radiusCurrent = radiusMin;
    for (var i = 0; i <= 120; i++) {
      radiusCurrent += radiusStep;

      // Draw marks
      if (i % 5 == 0) {
        // Draw every 1/12 mark
        if (i < 60 || i % 15 != 0) {
          canvas.drawLine(Offset(0, -radiusCurrent),
              Offset(0, -radiusCurrent + 10), markPaint2);
        } else {
          canvas.drawLine(Offset(0, -radiusCurrent),
              Offset(0, -radiusCurrent + 5), markPaint2);
        }
      } else {
        // Draw every 1/60 mark
        canvas.drawLine(Offset(0, -radiusCurrent),
            Offset(0, -radiusCurrent + 5), markPaint);
      }

      // Draw numbers
      if (i % 15 == 0) {
        canvas.save();
        // Slightly increase the padding for the numbers located outside
        if (i > 60) {
          canvas.translate(0, -radiusCurrent - 15.0);
        } else {
          canvas.translate(0, -radiusCurrent - 10.0);
        }
        textPainter.text = TextSpan(text: "${i ~/ 5}", style: textStyle);
        canvas.rotate(-angleStep * i);
        textPainter.layout();
        textPainter.paint(canvas,
            Offset(-(textPainter.width / 2), -(textPainter.height / 2)));
        canvas.restore();
      }

      canvas.rotate(angleStep);
    }

    canvas.restore();
  }

  @override
  bool shouldRepaint(_ClockFacePainter oldDelegate) {
    return oldDelegate.color != color;
  }
}
