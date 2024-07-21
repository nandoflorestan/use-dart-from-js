// Put public facing types in this file.

import 'dart:js_interop';

// https://api.dart.dev/stable/3.4.4/dart-js_interop/JSExport-class.html
@JSExport()
class DartApp {
  DartApp(); // Empty constructor

  bool get isAwesome => true;
  String get name => "La Dart-Aplikaĵo";
  int get age => 48;

  String getWisdom(int n) {
    if (n < 6) {
      return "Tu és o que não és.";
    } else if (n > 44) {
      return "You are that which you aren't.";
    } else {
      return "Vi estas tio, kio vi ne estas.";
    }
  }

  // Type get klass => DartApp;
}
