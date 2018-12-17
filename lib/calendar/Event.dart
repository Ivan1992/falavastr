import 'package:flutter/material.dart';

class Event {
  final DateTime date;
  final String title;
  final Widget icon;
  final ShapeBorder shape;
  final Color borderColor;
  final Color fillColor;
  final Decoration decoration;

  Event({
    this.date,
    this.title,
    this.icon,
    this.shape,
    this.borderColor,
    this.fillColor,
    this.decoration
  }) : assert(date != null);
}