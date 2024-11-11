// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:collection/collection.dart';
import 'package:flutter/material.dart'
    hide DropdownMenu, DropdownMenuEntry, DropdownMenuItem;

import 'dropdown_menu.dart';

// Flutter code sample for [DropdownMenu]s. The first dropdown menu
// has the default outlined border and demos using the
// [DropdownMenuEntry] style parameter to customize its appearance.
// The second dropdown menu customizes the appearance of the dropdown
// menu's text field with its [InputDecorationTheme] parameter.

typedef _ColorEntry = DropdownMenuEntry<_ColorLabel>;

// DropdownMenuEntry labels and values for the first dropdown menu.
enum _ColorLabel {
  blue('Blue', Colors.blue),
  pink('Pink', Colors.pink),
  green('Green', Colors.green),
  yellow('Orange', Colors.orange),
  grey('Grey', Colors.grey);

  const _ColorLabel(this.label, this.color);
  final String label;
  final Color color;

  static final List<_ColorEntry> entries = UnmodifiableListView<_ColorEntry>(
    values.map<_ColorEntry>(
      (_ColorLabel color) => _ColorEntry(
        value: color,
        label: color.label,
        enabled: color.label != 'Grey',
        style: MenuItemButton.styleFrom(
          foregroundColor: color.color,
        ),
      ),
    ),
  );
}

typedef _IconEntry = DropdownMenuEntry<_IconLabel>;

// DropdownMenuEntry labels and values for the second dropdown menu.
enum _IconLabel {
  smile('Smile', Icons.sentiment_satisfied_outlined),
  cloud('Cloud', Icons.cloud_outlined),
  brush('Brush', Icons.brush_outlined),
  heart('Heart', Icons.favorite);

  const _IconLabel(this.label, this.icon);
  final String label;
  final IconData icon;

  static final List<_IconEntry> entries = UnmodifiableListView<_IconEntry>(
    values.map<_IconEntry>(
      (_IconLabel icon) => _IconEntry(
        value: icon,
        label: icon.label,
        leadingIcon: Icon(icon.icon),
      ),
    ),
  );
}

class DropdownMenuExample extends StatefulWidget {
  const DropdownMenuExample({super.key});

  @override
  State<DropdownMenuExample> createState() => _DropdownMenuExampleState();
}

class _DropdownMenuExampleState extends State<DropdownMenuExample> {
  final TextEditingController colorController = TextEditingController();
  final TextEditingController iconController = TextEditingController();
  _ColorLabel? selectedColor;
  _IconLabel? selectedIcon;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  DropdownMenu<_ColorLabel>(
                    initialSelection: _ColorLabel.green,
                    controller: colorController,
                    // requestFocusOnTap is enabled/disabled by platforms when it is null.
                    // On mobile platforms, this is false by default. Setting this to true will
                    // trigger focus request on the text field and virtual keyboard will appear
                    // afterward. On desktop platforms however, this defaults to true.
                    requestFocusOnTap: true,
                    label: const Text('Color'),
                    onSelected: (_ColorLabel? color) {
                      setState(() {
                        selectedColor = color;
                      });
                    },
                    dropdownMenuEntries: _ColorLabel.entries,
                  ),
                  const SizedBox(width: 24),
                  DropdownMenu<_IconLabel>(
                    controller: iconController,
                    enableFilter: true,
                    requestFocusOnTap: true,
                    leadingIcon: const Icon(Icons.search),
                    label: const Text('Icon'),
                    inputDecorationTheme: const InputDecorationTheme(
                      filled: true,
                      contentPadding: EdgeInsets.symmetric(vertical: 5.0),
                    ),
                    onSelected: (_IconLabel? icon) {
                      setState(() {
                        selectedIcon = icon;
                      });
                    },
                    dropdownMenuEntries: _IconLabel.entries,
                  ),
                ],
              ),
            ),
            if (selectedColor != null && selectedIcon != null)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                      'You selected a ${selectedColor?.label} ${selectedIcon?.label}'),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    child: Icon(
                      selectedIcon?.icon,
                      color: selectedColor?.color,
                    ),
                  )
                ],
              )
            else
              const Text('Please select a color and an icon.')
          ],
        ),
      ),
    );
  }
}
