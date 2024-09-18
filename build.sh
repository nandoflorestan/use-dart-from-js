#!/usr/bin/env bash

dart compile js lib/main.dart -o out/interop.js && ls -lh out
