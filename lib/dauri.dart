library;

import 'dart:js_interop'; // contains JS types such as JSAny, JSArray etc.
import 'dart:js_interop_unsafe'; // contains window.setProperty()

import 'package:web/web.dart' as web;

import 'src/dauri_base.dart'
    as js_lib; // our library which we are exposing to JS

void main() {
  // https://api.dart.dev/stable/3.4.4/dart-js_interop/createJSInteropWrapper.html

  // Apparently, one cannot export a Dart class to JS:
  // web.window.setProperty("DartApp".toJS, createJSInteropWrapper(DartApp));
  // Error: Class 'Type' does not have a `@JSExport` on it or any of its members.

  // Let's just export an instance:
  web.window
      .setProperty("dartApp".toJS, createJSInteropWrapper(js_lib.DartApp()));
}
