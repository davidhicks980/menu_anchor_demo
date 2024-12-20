// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart'
    hide MenuAnchor, MenuBar, MenuController, SubmenuButton;

import 'raw_menu_anchor.dart';

// void main() => runApp(const CupertinoSimpleMenuApp());

class MenuItem {
  const MenuItem(this.label,
      {this.leading, this.children = const <MenuItem>[]});
  final String label;
  final Widget? leading;
  final List<MenuItem> children;
}

const List<MenuItem> options = <MenuItem>[
  MenuItem('File', children: <MenuItem>[
    MenuItem('New', leading: Icon(Icons.edit_document)),
    MenuItem('Open', leading: Icon(Icons.folder)),
    MenuItem('Print', leading: Icon(Icons.print)),
    MenuItem('Share', leading: Icon(Icons.share), children: <MenuItem>[
      MenuItem('Email', leading: Icon(Icons.email)),
      MenuItem('Message', leading: Icon(Icons.message)),
      MenuItem('Copy Link', leading: Icon(Icons.link)),
    ]),
  ]),
  MenuItem('Edit', children: <MenuItem>[
    MenuItem('Undo', leading: Icon(Icons.undo)),
    MenuItem('Redo', leading: Icon(Icons.redo)),
    MenuItem('Cut', leading: Icon(Icons.cut)),
    MenuItem('Copy', leading: Icon(Icons.copy)),
    MenuItem('Paste', leading: Icon(Icons.paste))
  ]),
  MenuItem('View', children: <MenuItem>[
    MenuItem('Zoom In', leading: Icon(Icons.zoom_in)),
    MenuItem('Zoom Out', leading: Icon(Icons.zoom_out)),
    MenuItem('Fit', leading: Icon(Icons.fullscreen)),
  ]),
  MenuItem('Tools', children: <MenuItem>[
    MenuItem('Spelling', leading: Icon(Icons.spellcheck)),
    MenuItem('Grammar', leading: Icon(Icons.text_format)),
    MenuItem('Thesaurus', leading: Icon(Icons.book_outlined)),
    MenuItem('Dictionary', leading: Icon(Icons.book)),
  ]),
];

class _MenuNodeExample extends StatefulWidget {
  const _MenuNodeExample({super.key});

  @override
  State<_MenuNodeExample> createState() => _MenuNodeExampleState();
}

class _MenuNodeExampleState extends State<_MenuNodeExample> {
  final MenuController controller = MenuController();
  String _selected = '';

  RawMenuAnchor _buildMenuItem(MenuItem option, {bool isSubmenu = false}) {
    return RawMenuAnchor(
      padding: const EdgeInsets.symmetric(vertical: 5),
      alignmentOffset: const Offset(-4, 0),
      constraints: const BoxConstraints(minWidth: 180),
      menuChildren: <Widget>[
        for (final MenuItem child in option.children)
          if (child.children.isNotEmpty)
            _buildMenuItem(child, isSubmenu: true)
          else
            MenuItemButton(
              onPressed: () {
                setState(() {
                  _selected = child.label;
                });
                controller.close();
              },
              leadingIcon: child.leading,
              child: Text(child.label),
            )
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
                leadingIcon: option.leading,
                trailingIcon:
                    isSubmenu ? const Icon(Icons.keyboard_arrow_right) : null,
                child: Text(option.label),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          if (_selected.isNotEmpty)
            Text('Selected: $_selected',
                style: Theme.of(context).textTheme.titleMedium),
          UnconstrainedBox(
            clipBehavior: Clip.hardEdge,
            child: RawMenuAnchor.node(
              controller: controller,
              menuChildren: <Widget>[
                for (final MenuItem option in options) _buildMenuItem(option),
              ],
              builder: (BuildContext context, List<Widget> menuChildren) {
                return Row(
                  mainAxisSize: MainAxisSize.min,
                  children: menuChildren,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class MenuNodeExample extends StatelessWidget {
  const MenuNodeExample({super.key});

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
      child: const _MenuNodeExample(),
    );
  }
}
