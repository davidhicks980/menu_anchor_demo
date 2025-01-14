// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart' hide MenuController;

import 'raw_menu_anchor.dart';

/// Flutter code sample for a [RawMenuAnchor] that shows a simple menu with
/// three items.

class SimpleMenuExample extends StatefulWidget {
  const SimpleMenuExample({super.key});

  @override
  State<SimpleMenuExample> createState() => _SimpleMenuExampleState();
}

class _SimpleMenuExampleState extends State<SimpleMenuExample> {
  final MenuController controller = MenuController();
  String _selected = '';

  void _handlePressed(String value) {
    setState(() {
      _selected = value;
    });
    controller.close();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            'Selected: $_selected',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          RawMenuAnchor(
            controller: controller,
            padding: const EdgeInsets.symmetric(vertical: 5),
            alignmentOffset: const Offset(0, 6),
            panel: RawMenuPanel(
              constraints: const BoxConstraints(minWidth: 125),
              menuChildren: <Widget>[
                MenuItemButton(
                  onPressed: () {
                    _handlePressed('Cut');
                  },
                  child: const Text('Cut'),
                ),
                MenuItemButton(
                  onPressed: () {
                    _handlePressed('Copy');
                  },
                  child: const Text('Copy'),
                ),
                MenuItemButton(
                  onPressed: () {
                    _handlePressed('Paste');
                  },
                  child: const Text('Paste'),
                ),
              ],
            ),
            builder: (
              BuildContext context,
              MenuController controller,
              Widget? child,
            ) {
              return TextButton(
                onPressed: () {
                  if (controller.isOpen) {
                    controller.close();
                  } else {
                    controller.open();
                  }
                },
                child: const Text('Edit'),
              );
            },
          ),
        ],
      ),
    );
  }
}

class SimpleMenuApp extends StatelessWidget {
  const SimpleMenuApp({super.key});

  static const ButtonStyle menuButtonStyle = ButtonStyle(
    splashFactory: InkSparkle.splashFactory,
    iconSize: WidgetStatePropertyAll<double>(17),
    padding: WidgetStatePropertyAll<EdgeInsets>(
        EdgeInsets.symmetric(horizontal: 12)),
    visualDensity: VisualDensity(
      horizontal: VisualDensity.minimumDensity,
      vertical: VisualDensity.minimumDensity,
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        menuButtonTheme: const MenuButtonThemeData(style: menuButtonStyle),
      ),
      child: const SimpleMenuExample(),
    );
  }
}
