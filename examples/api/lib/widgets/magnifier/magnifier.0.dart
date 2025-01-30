// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatefulWidget {
  const MyApp({super.key});
  static const Size loupeSize = Size(200, 200);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Offset dragGesturePositon = Offset.zero;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text('Drag on the logo!'),
              RepaintBoundary(
                child: Stack(
                  children: <Widget>[
                    GestureDetector(
                      onPanUpdate: (DragUpdateDetails details) => setState(
                        () {
                          dragGesturePositon = details.localPosition;
                        },
                      ),
                      child: const FlutterLogo(size: 200),
                    ),
                    Positioned(
                      left: dragGesturePositon.dx,
                      top: dragGesturePositon.dy,
                      child: const RawMagnifier(
                        decoration: MagnifierDecoration(
                          shape: CircleBorder(
                            side: BorderSide(color: Colors.pink, width: 3),
                          ),
                        ),
                        size: Size(100, 100),
                        magnificationScale: 2,
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
