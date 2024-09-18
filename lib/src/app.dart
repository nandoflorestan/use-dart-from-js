// Put public facing types in this file.

import 'dart:js_interop' as js;
import 'dart:js_interop_unsafe' as u;
import 'package:web/web.dart' as web;

Map<String, dynamic> basicMap = {"age": 8, "name": "Elliott"};

// Conversion of Dart Map to JS Map is not supported. So I am trying this:
// A proxy class so JS can consume the Dart Map contents.
class DartMapView<K, V> {
  DartMapView(this._dartMap);
  final Map<K, V> _dartMap;

  js.JSObject get tojs => js.createJSInteropWrapper(this);

  @js.JSExport()
  V? get(K key) => _dartMap[key];

  @js.JSExport()
  List<K> get keys => List<K>.from(_dartMap.keys);

  @js.JSExport()
  List<V> get values => List<V>.from(_dartMap.values);

  @js.JSExport()
  List<List<dynamic>> get entries =>
      List.from(_dartMap.entries.map((MapEntry e) => [e.key, e.value]));
}

// https://api.dart.dev/stable/3.4.4/dart-js_interop/JSExport-class.html
@js.JSExport()
class DartApp {
  DartApp(); // Empty constructor

  // Primitives are seen by JS directly, no problem.
  bool boolField = true;
  int intField = 42;
  double doubleField = 42.42;
  String stringField = "stringField content";
  List<int> listField = [1, 2, 3];

  // Dates and Maps just expose to JS the Dart object; it's not really usable.
  DateTime weirdDateField = DateTime(2024, 9, 12); // does not become a JS date
  Map<String, dynamic> weirdMapField = basicMap; // does not become a JS Map

  // But we can use our proxy class so JS can see the contents of the Dart Map:
  js.JSObject mapView = DartMapView(basicMap).tojs;

  // It's also possible to create a JS object directly.
  js.JSAny aDate = web.window.callMethod("Date".toJS)!;
  // This .callMethod(), and others, are provided by dart:js_interop_unsafe.

  bool get boolGetter => true;
  String get stringGetter => "La Dart-Aplikaĵo";
  int get intGetter => 48;

  String getWisdom(int n) {
    if (n < 0) {
      return "Tu és o que não és.";
    } else if (n > 41) {
      return "Vi estas tio, kio vi ne estas.";
    } else {
      return "You are that which you aren't.";
    }
  }

  // TODO Try to consume generator functions from JS
  // Iterable<js.JSObject> getEntities() sync* {
  //   yield mapView;
  // }

  // Now we want to allow JS to instantiate DartApp. Try some options:

  Type get klass => DartApp;
  // If called in JS, fails with Uncaught TypeError: dartApp.klass is not a function
  // Same error when you do: dartApp.constructor()
  // And if you do: new dartApp.klass(), it says "klass is not a constructor"

  DartApp factoryWeird() => DartApp();
  // This doesn't crash but returns a weird JS object with the innards of
  // the transpiled Dart and without the getters.

  // This is a good way to make a JS constructor:
  static js.JSObject factory() => js.createJSInteropWrapper(DartApp());
  // https://api.dart.dev/stable/3.4.4/dart-js_interop/createJSInteropWrapper.html
}
