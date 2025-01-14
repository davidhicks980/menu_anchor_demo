import 'dart:ui' as ui;

import 'package:flutter/material.dart' hide MenuController;
import 'package:raw_menu_anchor_web/raw_menu_anchor_template.dart';

import 'button.dart';
import 'raw_menu_anchor.dart';

List<Widget> buildChildren(
  BuildContext context,
  AlignmentGeometry anchorAlignment,
  AlignmentGeometry menuAlignment,
  Offset alignmentOffset,
) {
  final darkMode = MediaQuery.platformBrightnessOf(context) == Brightness.dark;
  final depth = 0;
  final children = <Widget>[
    for (int index = 0; index < 4; index++)
      Button.text(
        "Sub" * depth + 'menu Item $depth.$index',
        constraints: const BoxConstraints(maxHeight: 30),
      ),
    RawMenuAnchor(
      alignment: anchorAlignment,
      alignmentOffset: alignmentOffset,
      menuAlignment: menuAlignment,
      padding: const EdgeInsetsDirectional.fromSTEB(33, 45, 15, 27),
      panel: RawMenuPanel(
          decoration: const BoxDecoration(
            color: ui.Color.fromARGB(87, 255, 0, 247),
            border: Border.fromBorderSide(BorderSide(color: Color(0x63000000))),
          ),
          constraints: const BoxConstraints(minWidth: 125),
          padding: const EdgeInsets.symmetric(vertical: 5),
          menuChildren: [
            for (int index = 0; index < 4; index++)
              DecoratedBox(
                decoration: (darkMode
                        ? RawMenuPanel.darkSurfaceDecoration as BoxDecoration
                        : RawMenuPanel.lightSurfaceDecoration as BoxDecoration)
                    .copyWith(borderRadius: BorderRadius.zero, boxShadow: []),
                child: Button.text(
                  "Sub" * (depth + 1) + 'menu Item $depth.${index + 1}',
                  constraints: const BoxConstraints(maxHeight: 30),
                ),
              ),
          ]),
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

class PaddingExample extends StatelessWidget {
  const PaddingExample({super.key});

  @override
  Widget build(BuildContext context) {
    return DevelopmentTemplate(
      buildChildren: buildChildren,
      title: Text(
        'Padding Example',
        style: TextTheme.of(context).headlineLarge!,
      ),
    );
  }
}
