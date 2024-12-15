import 'dart:ui' as ui;

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart' show Theme;
import 'package:flutter/widgets.dart';

import 'raw_menu_anchor.dart';

class Button extends StatefulWidget {
  const Button(
    this.child, {
    super.key,
    this.onPressed,
    this.focusNode,
    this.autofocus = false,
    this.submenu = false,
    this.onFocusChange,
    String? focusNodeLabel,
    BoxConstraints? constraints,
  })  : _focusNodeLabel = focusNodeLabel,
        constraints = constraints ??
            const BoxConstraints.tightFor(width: 225, height: 32);

  factory Button.text(
    String text, {
    Key? key,
    VoidCallback? onPressed,
    FocusNode? focusNode,
    bool autofocus = false,
    BoxConstraints? constraints,
    bool submenu = false,
    void Function(bool)? onFocusChange,
  }) {
    return Button(
      Text(text),
      key: key,
      onPressed: onPressed,
      focusNode: focusNode,
      autofocus: autofocus,
      constraints: constraints,
      submenu: submenu,
      onFocusChange: onFocusChange,
    );
  }

  final Widget child;
  final VoidCallback? onPressed;
  final void Function(bool)? onFocusChange;
  final FocusNode? focusNode;
  final bool autofocus;
  final BoxConstraints? constraints;
  final bool submenu;
  final String? _focusNodeLabel;

  @override
  State<Button> createState() => _ButtonState();
}

class _ButtonState extends State<Button> {
  bool _focused = false;
  bool _hovered = false;
  bool _active = false;
  FocusNode get _focusNode => widget.focusNode ?? _internalFocusNode!;
  FocusNode? _internalFocusNode;

  @override
  void initState() {
    super.initState();
    if (widget.focusNode == null) {
      _internalFocusNode = FocusNode(debugLabel: widget._focusNodeLabel);
    }
  }

  @override
  void didUpdateWidget(Button oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.focusNode != widget.focusNode) {
      if (widget.focusNode == null) {
        _internalFocusNode = FocusNode(debugLabel: widget._focusNodeLabel);
      } else {
        _internalFocusNode?.dispose();
        _internalFocusNode = null;
      }
    }
  }

  @override
  void dispose() {
    _internalFocusNode?.dispose();
    super.dispose();
  }

  void _activateOnIntent(Intent intent) {
    _handlePressed();
  }

  void _handlePressed() {
    widget.onPressed?.call();
  }

  void _handleFocusChange(bool value) {
    if (_focused != value) {
      setState(() {
        _focused = value;
      });
    }
    widget.onFocusChange?.call(value);
  }

  void _handleExit(PointerExitEvent event) {
    if (_hovered || _focused) {
      setState(() {
        _hovered = false;
      });
    }
  }

  void _handleHover(PointerHoverEvent event) {
    if (!_hovered) {
      setState(() {
        _hovered = true;
      });
    }
  }

  void _handleTapUp(TapUpDetails details) {
    if (_active) {
      setState(() {
        _active = false;
      });
    }
    _handlePressed.call();
  }

  void _handleTapCancel() {
    if (_active) {
      setState(() {
        _active = false;
      });
    }
  }

  void _handleTapDown(TapDownDetails details) {
    if (!_active) {
      setState(() {
        _active = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTextStyle.merge(
      style: _textStyle,
      child: MergeSemantics(
        child: Semantics(
          button: true,
          child: Actions(
            actions: <Type, Action<Intent>>{
              ActivateIntent: CallbackAction<ActivateIntent>(
                onInvoke: _activateOnIntent,
              ),
              ButtonActivateIntent: CallbackAction<ButtonActivateIntent>(
                onInvoke: _activateOnIntent,
              ),
            },
            child: Focus(
              debugLabel: widget._focusNodeLabel,
              onFocusChange: _handleFocusChange,
              autofocus: widget.autofocus,
              focusNode: _focusNode,
              child: MouseRegion(
                onHover: _handleHover,
                onExit: _handleExit,
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTapDown: _handleTapDown,
                  onTapCancel: _handleTapCancel,
                  onTapUp: _handleTapUp,
                  child: Container(
                    constraints: widget.constraints,
                    decoration: _decoration,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Align(
                      alignment: AlignmentDirectional.centerStart,
                      child: widget.child,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  BoxDecoration? get _decoration {
    if (_active) {
      return const BoxDecoration(color: Color(0xFF007BFF));
    } else if (_focused) {
      return switch (MediaQuery.maybePlatformBrightnessOf(context)) {
        ui.Brightness.dark => const BoxDecoration(color: Color(0x95007BFF)),
        ui.Brightness.light ||
        null =>
          const BoxDecoration(color: Color(0xFFF0F0F0))
      };
    } else if (_hovered) {
      return const BoxDecoration(color: Color(0x22BBBBBB));
    } else {
      return null;
    }
  }

  TextStyle get _textStyle {
    if (_active) {
      return const TextStyle(color: Color.fromARGB(255, 255, 255, 255));
    }
    return switch (MediaQuery.maybePlatformBrightnessOf(context)) {
      ui.Brightness.dark => const TextStyle(color: Color(0xFFFFFFFF)),
      ui.Brightness.light || null => const TextStyle(color: Color(0xFF000000))
    };
  }
}

class AnchorButton extends StatelessWidget {
  const AnchorButton(
    this.child, {
    super.key,
    this.onPressed,
    this.constraints,
    this.autofocus = false,
    this.onFocusChange,
    this.focusNode,
  });

  factory AnchorButton.small(Widget child) {
    return AnchorButton(
      child,
      constraints: BoxConstraints.tight(const Size(100, 30)),
    );
  }

  final Widget child;
  final void Function()? onPressed;
  final void Function(bool)? onFocusChange;
  final bool autofocus;
  final BoxConstraints? constraints;
  final FocusNode? focusNode;

  @override
  Widget build(BuildContext context) {
    final MenuController? controller = MenuController.maybeOf(context);
    return ColoredBox(
      color: controller?.isOpen ?? false
          ? Theme.of(context).colorScheme.secondaryContainer
          : Theme.of(context).colorScheme.primaryContainer,
      child: Button(
        child,
        onPressed: () {
          if (controller != null) {
            if (controller.isOpen) {
              controller.close();
            } else {
              controller.open();
            }
          }
          onPressed?.call();
        },
        focusNode: focusNode,
        constraints: constraints,
        autofocus: autofocus,
      ),
    );
  }
}
