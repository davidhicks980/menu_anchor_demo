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
        Container(
          height: 50,
          width: 50,
          color: const ui.Color.fromARGB(255, 0, 8, 255),
        )
      ],
      builder: (
        BuildContext context,
        MenuController controller,
        Widget? child,
      ) {
        return ColoredBox(
          color: controller.isOpen
              ? const ui.Color.fromARGB(30, 255, 255, 255)
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
      title: Text(
        'Padding Example',
        style: TextTheme.of(context).headlineLarge!,
      ),
    );
  }
}
