// Put public facing types in this file.

import 'dart:js_interop' as js;

// https://api.dart.dev/stable/3.4.4/dart-js_interop/JSExport-class.html
@js.JSExport()
class DartApp {
  DartApp(); // Empty constructor

  bool get isAwesome => true;
  String get name => "La Dart-Aplikaĵo";
  int get age => 48;

  String getWisdom(int n) {
    if (n < 16) {
      return "Tu és o que não és.";
    } else if (n > 47) {
      return "Vi estas tio, kio vi ne estas.";
    } else {
      return "You are that which you aren't.";
    }
  }

  // Now we want to allow JS to instantiate DartApp. Try some options:

  Type get klass => DartApp;
  // If called in JS, fails with Uncaught TypeError: dartApp.klass is not a function
  // Same error when you do: dartApp.constructor()
  // And if you do: new dartApp.klass(), it says "klass is not a constructor"

  DartApp factoryWeird() => DartApp();
  // This doesn't crash but returns a weird JS object with the innards of
  // the translated Dart and without the getters for age, name, isAwesome.

  // This is the right way to do it:
  js.JSObject factory() => js.createJSInteropWrapper(DartApp());
}
