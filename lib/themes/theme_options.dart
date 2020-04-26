import 'package:flutter/material.dart';
import 'package:theme_provider/theme_provider.dart';

class CustomThemeOptions implements AppThemeOptions{
  final Color surfaceColor;
  final Color mainTextColor;
  final Color secondaryTextColor;
  final Color defaultIconColor;
  final Color accentIconColor;
  final Color backgroundColor;
  final Color defaultDetailColor;
  CustomThemeOptions({
    this.surfaceColor,
    this.mainTextColor,
    this.secondaryTextColor,
    this.defaultIconColor:Colors.black87,
    this.accentIconColor:Colors.amber,
    this.backgroundColor,
    this.defaultDetailColor,
  });
}