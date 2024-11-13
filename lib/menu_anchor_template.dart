import "dart:ui" as ui;

import 'package:flutter/material.dart';

import 'button.dart';
import 'grid_slider.dart';
// import 'menu_anchor.dart';

class MenuAnchorDevelopmentTemplate extends StatefulWidget {
  const MenuAnchorDevelopmentTemplate(
      {super.key, required this.buildChildren, this.title});
  final List<Widget> Function(
    AlignmentGeometry anchorAlignment,
    Offset alignmentOffset,
  ) buildChildren;

  final Widget? title;

  @override
  State<MenuAnchorDevelopmentTemplate> createState() =>
      _MenuAnchorDevelopmentTemplateState();
}

class _MenuAnchorDevelopmentTemplateState
    extends State<MenuAnchorDevelopmentTemplate> {
  final FocusNode anchorFocusNode = FocusNode();
  final FocusNode anchorFocusNode2 = FocusNode();
  final FocusNode anchorFocusNode3 = FocusNode();
  ScrollController scrollController = ScrollController();
  MenuController controller = MenuController();

  ui.Brightness brightness = ui.Brightness.dark;
  (double, double) _menuPosition = (0, 0);
  (double, double) _anchorAttachment = (1, -1);
  (double, double) _anchorPosition = (0, 0);
  (double, double) _alignmentOffset = (0, 0);

  @override
  Widget build(BuildContext context) {
    final AlignmentDirectional anchorAlignment = AlignmentDirectional(
      _anchorAttachment.$1,
      _anchorAttachment.$2,
    );
    final Offset offset = Offset(
      _alignmentOffset.$1 * 200,
      _alignmentOffset.$2 * 200,
    );
    return Theme(
      data: ThemeData(visualDensity: VisualDensity.standard),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: <Widget>[
            if (widget.title != null) widget.title!,
            DefaultTextStyle(
              style: const TextStyle(color: Color(0xffffffff)),
              child: FocusTraversalGroup(
                policy: WidgetOrderTraversalPolicy(),
                child: Wrap(
                  spacing: 20.0,
                  runSpacing: 20.0,
                  children: <Widget>[
                    GridSlider(
                      x: _anchorPosition.$1,
                      y: _anchorPosition.$2,
                      title: const Text('Anchor Position'),
                      onChange: (double x, double y) {
                        setState(() {
                          _anchorPosition = (x, y);
                        });
                      },
                    ),
                    GridSlider(
                      x: _menuPosition.$1,
                      y: _menuPosition.$2,
                      title: const Text('Controller Position'),
                      onChange: (double x, double y) {
                        setState(() {
                          _menuPosition = (x, y);
                          controller.open(
                            position: Offset(x * 200, y * 200),
                          );
                        });
                      },
                    ),
                    GridSlider(
                      x: _anchorAttachment.$1,
                      y: _anchorAttachment.$2,
                      title: const Text('Alignment'),
                      onChange: (double x, double y) {
                        setState(() {
                          _anchorAttachment = (x, y);
                        });
                      },
                    ),
                    GridSlider(
                      x: _alignmentOffset.$1,
                      y: _alignmentOffset.$2,
                      title: const Text('Alignment Offset'),
                      onChange: (double x, double y) {
                        setState(() {
                          _alignmentOffset = (x, y);
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
                child: Align(
              alignment: AlignmentDirectional(
                _anchorPosition.$1,
                _anchorPosition.$2,
              ),
              child: MenuAnchor(
                controller: controller,
                menuChildren: widget.buildChildren(
                  anchorAlignment,
                  offset,
                ),
                child: Button(
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Flexible(child: Text('Menu')),
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
              ),
            )),
          ],
        ),
      ),
    );
  }
}
