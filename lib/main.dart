library;

import 'dart:js_interop' as js; // contains JS types such as JSAny, JSArray etc.
import 'dart:js_interop_unsafe' as u; // contains window.setProperty()
import 'package:web/web.dart' as web; // contains window and other browser APIs

import 'src/app.dart' as our_lib; // the library we are exposing to JS

// The simplest way to allow JS to see DartApp is to export a constructor:
// void main() {
//   web.window.setProperty("DartApp".toJS, our_lib.DartApp.factory.toJS);
// }
// The above is certainly brief and easy to understand.

// But that uses window.setProperty(), which comes from the unsafe library.
// Code is better when it avoids using the js_interop_unsafe library.
// Also, when I replaced the above code, the transpiled JS got smaller.
// So here is a better alternative (thanks to ykmnkmi):

@js.JS("DartApp")
external set jsDartApp(js.JSFunction constructor);

void main() {
  jsDartApp = our_lib.DartApp.factory.toJS;
}
