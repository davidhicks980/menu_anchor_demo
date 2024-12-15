import "dart:ui" as ui;

import 'package:flutter/material.dart'
    show Icons, RangeLabels, RangeSlider, RangeValues;
import 'package:flutter/widgets.dart';

import 'button.dart';
import 'grid_slider.dart';
import 'raw_menu_anchor.dart';

enum AnimatedAxis {
  x,
  y,
}

enum AnimatedProperty {
  anchorAlignment,
  anchorOffset,
  menuAlignment,

  anchorPosition,
  menuPosition;

  String get abbreviation {
    switch (this) {
      case AnimatedProperty.menuPosition:
        return 'MPos';
      case AnimatedProperty.anchorPosition:
        return 'APos';
      case AnimatedProperty.menuAlignment:
        return 'MAlign';
      case AnimatedProperty.anchorAlignment:
        return 'AAlign';
      case AnimatedProperty.anchorOffset:
        return 'AOff';
    }
  }
}

class DevelopmentTemplate extends StatefulWidget {
  const DevelopmentTemplate({
    super.key,
    required this.buildChildren,
    this.title,
  });
  final List<Widget> Function(
    BuildContext context,
    AlignmentGeometry anchorAlignment,
    AlignmentGeometry menuAlignment,
    Offset alignmentOffset,
  ) buildChildren;

  final Widget? title;

  @override
  State<DevelopmentTemplate> createState() => _DevelopmentTemplateState();
}

class _DevelopmentTemplateState extends State<DevelopmentTemplate>
    with SingleTickerProviderStateMixin {
  final FocusNode anchorFocusNode = FocusNode();
  final FocusNode anchorFocusNode2 = FocusNode();
  final FocusNode anchorFocusNode3 = FocusNode();
  ScrollController scrollController = ScrollController();
  MenuController controller = MenuController();
  MenuController axisSelectorController = MenuController();
  MenuController propertySelectorController = MenuController();
  final GlobalKey anchorKey = GlobalKey();
  AnimatedAxis animatedAxis = AnimatedAxis.x;
  AnimatedProperty animatedProperty = AnimatedProperty.anchorAlignment;
  late final animationController = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 500),
    lowerBound: -1,
    upperBound: 1,
  );

  @override
  void initState() {
    super.initState();
    animationController.addListener(() {
      setState(() {
        switch ((animatedProperty, animatedAxis)) {
          case (AnimatedProperty.anchorAlignment, AnimatedAxis.x):
            _anchorAttachment =
                (animationController.value, _anchorAttachment.$2);
          case (AnimatedProperty.anchorAlignment, AnimatedAxis.y):
            _anchorAttachment =
                (_anchorAttachment.$1, animationController.value);
          case (AnimatedProperty.anchorOffset, AnimatedAxis.x):
            _alignmentOffset = (animationController.value, _alignmentOffset.$2);
          case (AnimatedProperty.anchorOffset, AnimatedAxis.y):
            _alignmentOffset = (_alignmentOffset.$1, animationController.value);
          case (AnimatedProperty.menuAlignment, AnimatedAxis.x):
            _menuAttachment = (animationController.value, _menuAttachment.$2);
          case (AnimatedProperty.menuAlignment, AnimatedAxis.y):
            _menuAttachment = (_menuAttachment.$1, animationController.value);
          case (AnimatedProperty.anchorPosition, AnimatedAxis.x):
            _anchorPosition = (animationController.value, _anchorPosition.$2);
          case (AnimatedProperty.anchorPosition, AnimatedAxis.y):
            _anchorPosition = (_anchorPosition.$1, animationController.value);
          case (AnimatedProperty.menuPosition, AnimatedAxis.x):
            _menuPosition = (animationController.value, _menuPosition.$2);
          case (AnimatedProperty.menuPosition, AnimatedAxis.y):
            _menuPosition = (_menuPosition.$1, animationController.value);
        }
      });
    });
  }

  ui.Brightness brightness = ui.Brightness.dark;
  (double, double) _menuPosition = (0, 0);
  (double, double) _menuAttachment = (-1, 1);
  (double, double) _anchorAttachment = (1, -1);
  (double, double) _anchorPosition = (0, 0);
  (double, double) _alignmentOffset = (0, 0);

  double _maximumValue = 1;
  double _minimumValue = -1;

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
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: <Widget>[
          Flexible(
            child: UnconstrainedBox(
              clipBehavior: Clip.hardEdge,
              child: ConstrainedBox(
                  constraints: BoxConstraints.tightFor(height: 100),
                  child: AnimationControls(
                      onAnchorAlignmentChanged: _handleAnchorAlignmentChanged,
                      onAnchorOffsetChanged: _handleAnchorOffsetChanged,
                      onMenuAlignmentChanged: _handleMenuAlignmentChanged,
                      onAnchorPositionChanged: _handleAnchorPositionChanged,
                      onMenuPositionChanged: _handleMenuPositionChanged,
                      onRangeChanged: _handleRangeChanged,
                      onPressedToMinimum: _handleAnimateToMinPress,
                      onPressedToZero: _handleAnimateToZeroPress,
                      onPressedToMaximum: _handleAnimateToMaxPress,
                      onXAxisSelected: _handleXAxisSelected,
                      onYAxisSelected: _handleYAxisSelected,
                      animatedAxis: animatedAxis,
                      animatedProperty: animatedProperty,
                      maximumValue: _maximumValue,
                      minimumValue: _minimumValue,
                      onToggle: () {
                        switch (animationController.value) {
                          case < 0.25 && > -0.25:
                            if (animationController.isForwardOrCompleted) {
                              _handleAnimateToMaxPress();
                            } else {
                              _handleAnimateToMinPress();
                            }
                          case > 0:
                            animationController.animateBack(0);
                          case _:
                            _handleAnimateToZeroPress();
                        }
                      })),
            ),
          ),
          FocusTraversalGroup(
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
          Expanded(
            child: AnimatedBuilder(
              animation: animationController,
              builder: (context, child) {
                print(animationController.value);
                return Align(
                    alignment: AlignmentDirectional(
                      _anchorPosition.$1,
                      _anchorPosition.$2,
                    ),
                    child: RawMenuAnchor(
                      useRootOverlay: true,
                      controller: controller,
                      menuChildren: widget.buildChildren(
                        context,
                        anchorAlignment,
                        menuAlignment,
                        offset,
                      ),
                      child: AnchorButton.small(
                        const Text("Anchor"),
                      ),
                    ));
              },
            ),
          ),
        ],
      ),
    );
  }

  void _handleAnimateToMinPress() {
    animationController.animateTo(_minimumValue);
  }

  void _handleAnimateToZeroPress() {
    animationController.animateTo(0);
  }

  void _handleAnimateToMaxPress() {
    animationController.animateTo(_maximumValue);
  }

  void _handleYAxisSelected() {
    axisSelectorController.close();
    setState(() {
      animatedAxis = AnimatedAxis.y;
    });
  }

  void _handleXAxisSelected() {
    axisSelectorController.close();
    setState(() {
      animatedAxis = AnimatedAxis.x;
    });
  }

  void _handleMenuPositionChanged() {
    propertySelectorController.close();
    setState(() {
      animatedProperty = AnimatedProperty.menuPosition;
    });
  }

  void _handleAnchorPositionChanged() {
    propertySelectorController.close();
    setState(() {
      animatedProperty = AnimatedProperty.anchorPosition;
    });
  }

  void _handleMenuAlignmentChanged() {
    propertySelectorController.close();
    setState(() {
      animatedProperty = AnimatedProperty.menuAlignment;
    });
  }

  void _handleAnchorOffsetChanged() {
    propertySelectorController.close();
    setState(() {
      animatedProperty = AnimatedProperty.anchorOffset;
    });
  }

  void _handleAnchorAlignmentChanged() {
    propertySelectorController.close();
    setState(() {
      animatedProperty = AnimatedProperty.anchorAlignment;
    });
  }

  void _handleRangeChanged(RangeValues value) {
    setState(() {
      animationController.value =
          ui.clampDouble(animationController.value, value.start, value.end);
      _minimumValue = value.start;
      _maximumValue = value.end;
    });
  }
}

class AnimationControls extends StatelessWidget {
  const AnimationControls({
    super.key,
    required this.onAnchorAlignmentChanged,
    required this.onAnchorOffsetChanged,
    required this.onMenuAlignmentChanged,
    required this.onAnchorPositionChanged,
    required this.onMenuPositionChanged,
    required this.onRangeChanged,
    required this.onXAxisSelected,
    required this.onYAxisSelected,
    required this.animatedAxis,
    required this.animatedProperty,
    required this.onToggle,
    required this.minimumValue,
    required this.maximumValue,
    required this.onPressedToMinimum,
    required this.onPressedToZero,
    required this.onPressedToMaximum,
  });

  final AnimatedAxis animatedAxis;
  final AnimatedProperty animatedProperty;

  final double maximumValue;
  final double minimumValue;

  final VoidCallback onToggle;
  final VoidCallback onAnchorAlignmentChanged;
  final VoidCallback onAnchorOffsetChanged;
  final VoidCallback onMenuAlignmentChanged;
  final VoidCallback onAnchorPositionChanged;
  final VoidCallback onMenuPositionChanged;

  final VoidCallback onPressedToMinimum;
  final VoidCallback onPressedToZero;
  final VoidCallback onPressedToMaximum;

  final VoidCallback onXAxisSelected;
  final VoidCallback onYAxisSelected;

  final ValueChanged<RangeValues> onRangeChanged;

  @override
  Widget build(BuildContext context) {
    final axisSelectorController = MenuController();
    final propertySelectorController = MenuController();
    final minLabel = minimumValue.toStringAsPrecision(1);
    final maxLabel = maximumValue.toStringAsPrecision(1);
    return SingleChildScrollView(
      child: Row(
        spacing: 8,
        children: [
          Column(
            children: [
              Text("$minLabel to $maxLabel"),
              RangeSlider(
                labels: RangeLabels(
                  minLabel,
                  maxLabel,
                ),
                values: RangeValues(minimumValue, maximumValue),
                max: 1,
                min: -1,
                onChanged: onRangeChanged,
              ),
            ],
          ),
          RawMenuAnchor(
              controller: propertySelectorController,
              menuChildren: <Widget>[
                Button.text(
                  'Anchor Alignment',
                  onPressed: onAnchorAlignmentChanged,
                ),
                Button.text(
                  'Anchor Offset',
                  onPressed: onAnchorOffsetChanged,
                ),
                Button.text(
                  'Menu Alignment',
                  onPressed: onMenuAlignmentChanged,
                ),
                Button.text(
                  'Anchor Position',
                  onPressed: onAnchorPositionChanged,
                ),
                Button.text(
                  'Menu Position',
                  onPressed: onMenuPositionChanged,
                ),
              ],
              child: AnchorButton(
                Text(animatedProperty.abbreviation),
                constraints: BoxConstraints.tightFor(
                  width: 75,
                  height: 30,
                ),
              )),
          RawMenuAnchor(
              controller: axisSelectorController,
              menuChildren: <Widget>[
                Button.text(
                  'x',
                  onPressed: onXAxisSelected,
                ),
                Button.text(
                  'y',
                  onPressed: onYAxisSelected,
                ),
              ],
              child: AnchorButton(
                Text(animatedAxis.name),
                constraints: BoxConstraints.tightFor(width: 30, height: 30),
              )),
          Button(
            Icon(Icons.arrow_left),
            onPressed: onPressedToMinimum,
            constraints: BoxConstraints.tightFor(width: 50, height: 40),
          ),
          Button(
            Icon(Icons.compare_arrows),
            onPressed: onPressedToZero,
            constraints: BoxConstraints.tightFor(width: 50, height: 40),
          ),
          Button(
            Icon(Icons.arrow_right),
            onPressed: onPressedToMaximum,
            constraints: BoxConstraints.tightFor(width: 50, height: 40),
          ),
          Button(
            Icon(Icons.loop),
            onPressed: onToggle,
            constraints: BoxConstraints.tightFor(width: 50, height: 40),
          ),
        ],
      ),
    );
  }
}
