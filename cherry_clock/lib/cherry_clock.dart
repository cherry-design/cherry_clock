// Copyright 2020 Mike Melnikov. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/semantics.dart';
import 'package:flutter/services.dart';
import 'package:flutter_clock_helper/model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:cherry_clock/background.dart';
import 'package:cherry_clock/clock_face.dart';
import 'package:cherry_clock/hand_hour.dart';
import 'package:cherry_clock/hand_minute.dart';
import 'package:cherry_clock/hand_second.dart';

// The distance that the minute or second hand passes in one second or minute
final radiansPerTick = ((360 / 60) * math.pi) / 180;

// The distance an hour passes in one hour
final radiansPerHour = ((360 / 12) * math.pi) / 180;

class CherryClock extends StatefulWidget {
  const CherryClock(this.model);

  final ClockModel model;

  @override
  _CherryClockState createState() => _CherryClockState();
}

class _CherryClockState extends State<CherryClock> {
  DateTime _dateTime = DateTime.now();
  Timer _timer;

  @override
  void initState() {
    super.initState();

    widget.model.addListener(_updateModel);
    _updateTime();
    _updateModel();
  }

  @override
  void didUpdateWidget(CherryClock oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.model != oldWidget.model) {
      oldWidget.model.removeListener(_updateModel);
      widget.model.addListener(_updateModel);
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    widget.model.removeListener(_updateModel);
    widget.model.dispose();
    super.dispose();
  }

  void _updateModel() {
    setState(() {
      // Cause the clock to rebuild when the model changes.
    });
  }

  void _updateTime() {
    setState(() {
      _dateTime = DateTime.now();
      _timer = Timer(
        Duration(seconds: 1) - Duration(milliseconds: _dateTime.millisecond),
        _updateTime,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    // Find the current colors for drawing
    final customTheme = Theme.of(context).brightness == Brightness.light
        ? Theme.of(context).copyWith(
            // Background main color
            backgroundColor: Colors.white,
            // Background highlight color
            highlightColor: Colors.grey[200],
            // Clock face, hour and minute hands, text
            primaryColor: Colors.black,
            // Weather conditions, second hand, day/night mode icon
            accentColor: Colors.red,
          )
        : Theme.of(context).copyWith(
            backgroundColor: Colors.black,
            highlightColor: Colors.white10,
            primaryColor: Colors.white,
            accentColor: Colors.yellow,
          );

    return Container(
      color: customTheme.backgroundColor,
      child: Stack(
        children: [
          Background(
            color: customTheme.highlightColor,
            angleRadians: (_dateTime.hour % 12) * radiansPerHour +
                (_dateTime.minute / 60) * radiansPerHour,
          ),
          Center(
            child: _clock(customTheme),
          ),
          Positioned(
            right: 32,
            top: 32,
            child: _mode(customTheme),
          ),
          Positioned(
            left: 20,
            bottom: 20,
            child: _weather(customTheme),
          ),
        ],
      ),
    );
  }

  // Day/night mode block
  Widget _mode(ThemeData theme) {
    // Define an icon to display day/night mode
    IconData icon = (Theme.of(context).brightness == Brightness.light)
        ? Icons.wb_sunny // Sun
        : Icons.brightness_3; // Moon

    // Define a semantic label to day/night mode
    String semantic = (Theme.of(context).brightness == Brightness.light)
        ? "Clock in day mode"
        : "Clock in night mode";

    return Icon(
      icon,
      semanticLabel: semantic,
      color: theme.accentColor,
      size: 60,
    );
  }

  // Weather block
  Widget _weather(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          widget.model.weatherString,
          semanticsLabel: "Weather is ${widget.model.weatherString}",
          style: TextStyle(
            color: theme.accentColor,
            fontSize: 24,
            fontFamily: "Roboto",
          ),
        ),
        SizedBox(height: 3),
        Text(
          "↑ ${widget.model.highString}, ↓ ${widget.model.lowString}",
          semanticsLabel:
              "Highest temperature is ${widget.model.highString}, Lowest temperature is ${widget.model.lowString}",
          style: TextStyle(
            color: theme.primaryColor,
            fontSize: 12,
            fontFamily: "Roboto",
          ),
        ),
        Text(
          widget.model.temperatureString,
          semanticsLabel:
              "Current temperature is ${widget.model.temperatureString}",
          style: TextStyle(
            color: theme.primaryColor,
            fontSize: 34,
          ),
        ),
        Text(
          widget.model.location,
          style: TextStyle(
            color: theme.primaryColor,
            fontSize: 12,
            fontFamily: "Roboto",
          ),
        ),
      ],
    );
  }

  // Clock Block
  Widget _clock(ThemeData theme) {
    final timeString = DateFormat.Hms().format(_dateTime);

    return Container(
      padding: EdgeInsets.all(20),
      child: AspectRatio(
        aspectRatio: 1.0,
        child: Semantics.fromProperties(
          properties: SemanticsProperties(
            label: "Spiral clock with time $timeString",
          ),
          child: Stack(
            children: <Widget>[
              ClockFace(color: theme.primaryColor),
              _clockDate(theme.primaryColor),
              HandSecond(
                color: theme.accentColor,
                angleRadians: _dateTime.second * radiansPerTick,
              ),
              HandMinute(
                color: theme.primaryColor,
                angleRadians: _dateTime.minute * radiansPerTick,
              ),
              HandHour(
                color: theme.primaryColor,
                colorDot: theme.backgroundColor,
                angleRadians: (_dateTime.hour % 12) * radiansPerHour +
                    (_dateTime.minute / 60) * radiansPerHour,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Clock Date Block
  Widget _clockDate(Color color) {
    final dateString = DateFormat('EEEE\nMMM d, y').format(_dateTime);

    return Center(
      child: Padding(
        padding: EdgeInsets.only(top: 120),
        child: Text(
          dateString,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: color,
            fontSize: 12,
            fontFamily: "Roboto",
          ),
        ),
      ),
    );
  }
}
