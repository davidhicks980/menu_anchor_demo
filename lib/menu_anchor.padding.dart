import 'dart:ui' as ui;

import 'package:flutter/material.dart';

import 'button.dart';
// import 'menu_anchor.dart';
import 'menu_anchor_template.dart';
import 'raw_menu_anchor.dart' hide MenuController;
// import 'raw_menu_anchor.dart';

List<Widget> buildChildren(
  AlignmentGeometry anchorAlignment,
  Offset alignmentOffset,
) {
  final depth = 0;
  final children = <Widget>[
    for (int index = 0; index < 4; index++)
      Button.text(
        "Sub" * depth + 'menu Item $depth.$index',
        constraints: const BoxConstraints(maxHeight: 30),
      ),
    MenuAnchor(
      alignmentOffset: alignmentOffset,
      style: MenuStyle(
        alignment: anchorAlignment,
        padding: WidgetStatePropertyAll(
          EdgeInsets.fromLTRB(33, 45, 15, 27),
        ),
        backgroundColor: WidgetStatePropertyAll(
          ui.Color.fromARGB(87, 255, 0, 247),
        ),
      ),
      menuChildren: [
        for (int index = 0; index < 4; index++)
          DecoratedBox(
            decoration: (RawMenuPanel.lightSurfaceDecoration as BoxDecoration)
                .copyWith(borderRadius: BorderRadius.zero, boxShadow: []),
            child: Button.text(
              "Sub" * (depth + 1) + 'menu Item $depth.${index + 1}',
              constraints: const BoxConstraints(maxHeight: 30),
            ),
          ),
      ],
      builder: (
        BuildContext context,
        MenuController controller,
        Widget? child,
      ) {
        return ColoredBox(
          color: controller.isOpen
              ? MediaQuery.platformBrightnessOf(context) == Brightness.dark
                  ? const Color(0x0DFFFFFF)
                  : const ui.Color.fromARGB(49, 26, 26, 26)
              : const Color(0x00000000),
          child: Button(
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Flexible(child: Text('Menu $depth')),
                const Text('▶', style: TextStyle(fontSize: 10)),
              ],
            ),
            onPressed: () {
              if (controller.isOpen) {
                controller.close();
              } else {
                controller.open();
              }
            },
          ),
        );
      },
    ),
  ];

  return children;
}

class MenuAnchorPaddingBugExample extends StatelessWidget {
  const MenuAnchorPaddingBugExample({super.key});

  @override
  Widget build(BuildContext context) {
    return MenuAnchorDevelopmentTemplate(
      buildChildren: buildChildren,
      title: Padding(
        padding: const EdgeInsets.only(bottom: 20.0),
        child: Text(
          'Padding Example',
          style: TextTheme.of(context).headlineLarge!,
        ),
      ),
    );
  }
}
