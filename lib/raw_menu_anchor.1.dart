// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' hide MenuController;
import 'package:flutter/services.dart';

import 'raw_menu_anchor.dart';

/// Flutter code sample for a [CupertinoMenuAnchor] that shows a basic menu.
// void main() => runApp(const CupertinoSimpleMenuApp());

class ContextMenuExample extends StatefulWidget {
  const ContextMenuExample({super.key});

  @override
  State<ContextMenuExample> createState() => _ContextMenuExampleState();
}

class _ContextMenuExampleState extends State<ContextMenuExample> {
  final MenuController controller = MenuController();
  bool _menuWasEnabled = false;

  @override
  void initState() {
    super.initState();
    _disablePlatformContextMenu();
  }

  @override
  void dispose() {
    _enablePlatformContextMenu();
    super.dispose();
  }

  void _enablePlatformContextMenu() {
    if (!kIsWeb) {
      // Does nothing on non-web platforms.
      return;
    }
    if (_menuWasEnabled && !BrowserContextMenu.enabled) {
      BrowserContextMenu.enableContextMenu();
    }
  }

  Future<void> _disablePlatformContextMenu() async {
    if (!kIsWeb) {
      // Does nothing on non-web platforms.
      return;
    }
    _menuWasEnabled = BrowserContextMenu.enabled;
    if (_menuWasEnabled) {
      await BrowserContextMenu.disableContextMenu();
    }
  }

  void _handlePressed() {
    controller.close();
  }

  @override
  Widget build(BuildContext context) {
    return RawMenuAnchor(
      controller: controller,
      constraints: const BoxConstraints(minWidth: 180),
      padding: const EdgeInsets.symmetric(vertical: 5),
      alignmentOffset: const Offset(0, 6),
      menuChildren: <Widget>[
        MenuItemButton(
          autofocus: true,
          onPressed: _handlePressed,
          leadingIcon: const Icon(Icons.undo),
          child: const Text('Undo'),
        ),
        MenuItemButton(
          onPressed: _handlePressed,
          leadingIcon: const Icon(Icons.redo),
          child: const Text('Redo'),
        ),
        const Divider(thickness: 0.0, indent: 12, endIndent: 12),
        MenuItemButton(
          onPressed: _handlePressed,
          leadingIcon: const Icon(Icons.cut),
          child: const Text('Cut'),
        ),
        MenuItemButton(
          onPressed: _handlePressed,
          leadingIcon: const Icon(Icons.content_copy),
          child: const Text('Copy'),
        ),
        MenuItemButton(
          onPressed: _handlePressed,
          leadingIcon: const Icon(Icons.content_paste),
          child: const Text('Paste'),
        ),
        const Divider(thickness: 0.0, indent: 12, endIndent: 12),
        RawMenuAnchor(
          padding: const EdgeInsetsDirectional.symmetric(vertical: 5),
          alignmentOffset: const Offset(-4, 0),
          constraints: const BoxConstraints(minWidth: 180),
          menuChildren: [
            MenuItemButton(
              onPressed: _handlePressed,
              leadingIcon: const Icon(Icons.format_bold),
              child: const Text('Bold'),
            ),
            MenuItemButton(
              onPressed: _handlePressed,
              leadingIcon: const Icon(Icons.format_italic),
              child: const Text('Italic'),
            ),
            MenuItemButton(
              onPressed: _handlePressed,
              leadingIcon: const Icon(Icons.format_underline),
              child: const Text('Underline'),
            ),
          ],
          builder: (
            BuildContext context,
            MenuController controller,
            Widget? child,
          ) {
            return MergeSemantics(
              child: Semantics(
                expanded: controller.isOpen,
                child: ColoredBox(
                  color: controller.isOpen
                      ? const Color(0x0D1A1A1A)
                      : Colors.transparent,
                  child: MenuItemButton(
                    onPressed: () {
                      if (controller.isOpen) {
                        controller.close();
                      } else {
                        controller.open();
                      }
                    },
                    leadingIcon: const Icon(Icons.text_format),
                    trailingIcon: const Icon(Icons.keyboard_arrow_right),
                    child: const Text('Format'),
                  ),
                ),
              ),
            );
          },
        )
      ],
      child: const NestedWidget(),
    );
  }
}

class NestedWidget extends StatelessWidget {
  const NestedWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onSecondaryTapDown: (TapDownDetails details) {
        MenuController.maybeOf(context)?.open(position: details.localPosition);
      },
      onTapDown: (TapDownDetails details) {
        MenuController.maybeOf(context)?.close();
      },
      child: Stack(
        children: [
          Positioned.fill(
            child: ColoredBox(
              color: Theme.of(context).colorScheme.secondaryContainer,
              child: Center(
                child: Text(
                  'Right-click me!',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSecondaryContainer,
                    fontSize: 24,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ContextMenuApp extends StatelessWidget {
  const ContextMenuApp({super.key});

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
    kMenuDebugLayout = false;
    return Theme(
      data: Theme.of(context).copyWith(
        menuButtonTheme: const MenuButtonThemeData(style: menuButtonStyle),
      ),
      child: const Scaffold(body: ContextMenuExample()),
    );
  }
}
