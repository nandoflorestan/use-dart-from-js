# Consuming Dart code in the front-end

This is a tiny demonstration of how to create a library or app in the Dart language
and use it from JavaScript in the browser.

I suppose it can also be used as a starter project for developing such a library or app.

It was built in 2024-07 using new Dart libraries for JS interop:

- dart:html is being replaced with [package:web](https://pub.dev/packages/web).
    See https://dart.dev/interop/js-interop/package-web
- [dart:js_interop](https://dart.dev/interop/js-interop/js-types)
    is the new source of JS types such as JSAny, JSArray etc.

I built this repo because I could find no examples using the new libraries. The official documentation is very lacking in examples.


## Features

At the time of writing, it doesn't work in node.js:

```
> const mod = await import("./out/dauri.js");
uncaught referenceerror: self is not defined
```

...but it does work in the browser – see the [example/] folder.

I believe it's possible to expose functions and class instances to JS, but not classes themselves. I suppose if you want to expose a constructor you need to write a function that returns an instance and expose that. If I am wrong, please do let me know.


## Getting started

Simply clone this repo, cd into it, and visit example/index.html.


## How I built this

```
dart create -t package dauri  # create a new Dart project
dart pub add web  # add dependency to pubspec.yaml and install it
```

In the lib/src/ directory, write your library and
[mark your classes and functions with @JSExport](https://api.dart.dev/stable/3.4.4/dart-js_interop/JSExport-class.html).

In the lib/ directory, write a main() function that exposes the API (see lib/dauri.dart).


## WASM

Usage of the new libraries makes compilation to Wasm possible, but I haven't tested that yet. If you know how to compile to WebAssembly, please do teach us. At the time of writing, the official documentation is only [in the Flutter site](https://docs.flutter.dev/platform-integration/web/wasm), the Dart site does not mention Wasm, although obviously it should.

That Flutter page says:

- iOS is not supported because every browser in iOS uses WebKit, which doesn't yet support WasmGC. You didn't know every browser in iOS is the same thing? Yeah, Apple is anticompetitive and demands so in the rules of their app store.
- Firefox has a bug but I **think** it's related only to Flutter, not Dart.


## Dart vs TypeScript

Most people will tell you to build JS libraries in TypeScript. But TypeScript unfortunately inherits the main problems with JavaScript: new, this, class... you know these problems [and others](https://www.destroyallsoftware.com/talks/wat). Javascript really is a language that makes kittens cry every day. TypeScript is a superset of Javascript, and this is both its strength and its weakness.

TypeScript assumes you are writing classes. But its syntax for writing classes is terribly verbose. I see myself writing the names of the instance variables 4 (FOUR!) times just to get a constructor going...

The typing annotations in TypeScript are also difficult, you have to spend a long time learning the typing features and it's hard to remember them when you are coding – but in other languages it's not like that. The typing system in Dart doesn't bother you every day, does it. People are also saying the typing system of TypeScript isn't very strong; I don't know.

There are a few alternative languages, such as Elixir, that compile to JS and/or WebAssembly. But many of these are strictly functional (such as Elixir), and currently I have this idea in my big head, that purely functional languages are great for many purposes, but for building user interfaces what you really want is an object-oriented language.

In contrast, Dart is a boring, no-nonsense, no-surprises, clean, multipurpose OO language that works well for building user interfaces. But to use Dart you pay with a more difficult interop, exemplified in this repo. Which is worse, TypeScript boilerplate and difficult typing, or Dart interop? It depends on what you are doing, of course.

The page loads instantaneously, the runtime is small enough.

Here are the bundle sizes for this, I am not sure what a typical hello world weighs in TypeScript to compare:

- 157 KB when compiled with the default optimizations level 1: `-O1`.
- 57 KB when compiled with safe production-oriented optimizations (like minification).
- 55 KB when compiled with potentially unsafe optimizations: `-O3`.
- 55 KB when compiled with more aggressively unsafe optimizations: `-O4`.

Those starting bundle sizes are very acceptable to me if you are building an app. If you are building a library, it depends on the nature of the library. For small things, nope, just use TypeScript.

I wouldn't build a generic small JavaScript library this way; but what I want to build is something different: the core of an app (in Dart) to be used by a reactive GUI (written in JS with MithrilJS). I believe the pleasure of writing Dart instead of TypeScript may be worth the interop burden, especially if this burden is minimal, meaning you must have zero to very few JS libraries you want to call from Dart.
