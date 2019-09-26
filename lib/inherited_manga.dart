import 'package:flutter/material.dart';
import 'package:mangacan/helper.dart';

class InheritedManga extends InheritedWidget {
  final Helper helper;

  InheritedManga({this.helper, Widget child}) : super(child: child);

  static InheritedManga of(BuildContext context) {
    return context.inheritFromWidgetOfExactType(InheritedManga) as InheritedManga;
  }

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) {
    return true;
  }

}