import 'dart:ui' as ui;

import 'package:flutter/material.dart' hide MenuController;

import 'button.dart';
import 'development_template.dart';
import 'raw_menu_anchor.dart';

List<Widget> buildChildren(
  AlignmentGeometry anchorAlignment,
  AlignmentGeometry menuAlignment,
  Offset alignmentOffset,
) {
  List<Widget> children = <Widget>[
    Container(
      height: 50,
      width: 50,
      color: const ui.Color.fromARGB(255, 255, 0, 153),
    )
  ];
  int layers = 5;
  while (layers-- > 0) {
    final int depth = layers;
    children = <Widget>[
      for (int index = 0; index < 4; index++)
        Button.text(
          "Sub" * depth + 'menu Item $depth.$index',
          constraints: const BoxConstraints(maxHeight: 30),
        ),
      RawMenuAnchor(
        constraints: BoxConstraints(minWidth: 125),
        padding: const EdgeInsetsDirectional.fromSTEB(0.5, 4, 1, 6),
        alignmentOffset: alignmentOffset,
        alignment: anchorAlignment,
        menuAlignment: menuAlignment,
        menuChildren: children,
        builder:
            (BuildContext context, MenuController controller, Widget? child) {
          return ColoredBox(
            color: controller.isOpen
                ? const ui.Color.fromARGB(30, 255, 255, 255)
                : const ui.Color.fromARGB(26, 0, 0, 0),
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
  }

  return children;
}

class AlignmentExample extends StatelessWidget {
  const AlignmentExample({super.key});

  @override
  Widget build(BuildContext context) {
    kMenuDebugLayout = true;
    return DevelopmentTemplate(
      buildChildren: buildChildren,
      title: Padding(
        padding: EdgeInsets.only(bottom: 20),
        child: Text(
          'Alignment Example',
          style: TextTheme.of(context).headlineLarge,
        ),
      ),
    );
  }
}
