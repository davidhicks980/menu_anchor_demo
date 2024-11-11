import "dart:ui" as ui;

import 'package:flutter/widgets.dart';

import 'button.dart';
import 'grid_slider.dart';
import 'raw_menu_anchor.dart';

class DevelopmentTemplate extends StatefulWidget {
  const DevelopmentTemplate({super.key, required this.buildChildren});
  final List<Widget> Function(
    AlignmentGeometry anchorAlignment,
    AlignmentGeometry menuAlignment,
    Offset alignmentOffset,
  ) buildChildren;

  @override
  State<DevelopmentTemplate> createState() => _DevelopmentTemplateState();
}

class _DevelopmentTemplateState extends State<DevelopmentTemplate> {
  final FocusNode anchorFocusNode = FocusNode();
  final FocusNode anchorFocusNode2 = FocusNode();
  final FocusNode anchorFocusNode3 = FocusNode();
  ScrollController scrollController = ScrollController();
  MenuController controller = MenuController();

  ui.Brightness brightness = ui.Brightness.dark;
  (double, double) _menuPosition = (0, 0);
  (double, double) _menuAttachment = (-1, 1);
  (double, double) _anchorAttachment = (1, -1);
  (double, double) _anchorPosition = (0, 0);
  (double, double) _alignmentOffset = (0, 0);

  bool _ltr = true;

  @override
  Widget build(BuildContext context) {
    final AlignmentDirectional anchorAlignment = AlignmentDirectional(
      _anchorAttachment.$1,
      _anchorAttachment.$2,
    );
    final AlignmentDirectional menuAlignment = AlignmentDirectional(
      _menuAttachment.$1,
      _menuAttachment.$2,
    );
    final Offset offset = Offset(
      _alignmentOffset.$1 * 200,
      _alignmentOffset.$2 * 200,
    );
    return Directionality(
      textDirection: _ltr ? TextDirection.ltr : TextDirection.rtl,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: <Widget>[
            Button.text(
              "Switch to ${_ltr ? 'RTL' : 'LTR'}",
              onPressed: () {
                setState(() {
                  _ltr = !_ltr;
                });
              },
            ),
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
                    GridSlider(
                      x: _menuAttachment.$1,
                      y: _menuAttachment.$2,
                      title: const Text('Menu Alignment'),
                      onChange: (double x, double y) {
                        setState(() {
                          _menuAttachment = (x, y);
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
                child: RawMenuAnchor(
                  controller: controller,
                  alignment: anchorAlignment,
                  menuAlignment: menuAlignment,
                  alignmentOffset: offset,
                  menuChildren: widget.buildChildren(
                    anchorAlignment,
                    menuAlignment,
                    offset,
                  ),
                  child: AnchorButton.small(
                    const Text("Anchor"),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
