import 'dart:ui' as ui;

import 'package:flutter/material.dart' hide MenuController;
import 'package:raw_menu_anchor_web/development_template.dart';

import 'button.dart';
import 'raw_menu_anchor.dart';

List<Widget> buildChildren(
  AlignmentGeometry anchorAlignment,
  AlignmentGeometry menuAlignment,
  Offset alignmentOffset,
) {
  final depth = 0;
  final children = <Widget>[
    for (int index = 0; index < 4; index++)
      Button.text(
        "Sub" * depth + 'menu Item $depth.$index',
        constraints: const BoxConstraints(maxHeight: 30),
      ),
    RawMenuAnchor(
      constraints: BoxConstraints(minWidth: 125),
      padding: const EdgeInsetsDirectional.fromSTEB(33, 45, 15, 27),
      surfaceDecoration: const BoxDecoration(
        color: ui.Color.fromARGB(87, 255, 0, 247),
        border: Border.fromBorderSide(BorderSide(color: Color(0x63000000))),
      ),
      menuChildren: [
        for (int index = 0; index < 4; index++)
          DecoratedBox(
            decoration:
                (RawMenuAnchor.defaultLightOverlayDecoration as BoxDecoration)
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

class PaddingExample extends StatelessWidget {
  const PaddingExample({super.key});

  @override
  Widget build(BuildContext context) {
    kMenuDebugLayout = true;
    return DevelopmentTemplate(
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
