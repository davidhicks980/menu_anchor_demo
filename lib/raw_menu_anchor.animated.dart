import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart'
    hide MenuController, showMenu, MenuItemButton;
import 'package:flutter/physics.dart';
import 'package:raw_menu_anchor_web/menu_anchor.dart';
import 'package:raw_menu_anchor_web/raw_menu_anchor.dart';

class AnimatedRawMenuAnchor extends StatefulWidget {
  const AnimatedRawMenuAnchor({super.key});

  /// The [SpringDescription] used for the opening animation of a menu layer.
  static const SpringDescription _defaultForwardSpring = SpringDescription(
      mass: 1, stiffness: 32.7 * math.pi * math.pi, damping: 9.25 * math.pi);

  /// The [SpringDescription] used for the closing animation of a menu layer.
  static const SpringDescription _defaultReverseSpring = SpringDescription(
      mass: 1, stiffness: 90 * math.pi * math.pi, damping: 28.8 * math.pi);

  static const SpringDescription fastSpring =
      SpringDescription(mass: 1, stiffness: 100, damping: 10);

  @override
  State<AnimatedRawMenuAnchor> createState() => _AnimatedRawMenuAnchorState();
}

class _AnimatedRawMenuAnchorState extends State<AnimatedRawMenuAnchor>
    with MenuControllableMixin, SingleTickerProviderStateMixin {
  late final animationController = AnimationController.unbounded(vsync: this);

  static const Tolerance _springTolerance =
      Tolerance(velocity: 0.01, distance: 0.01);
  final FocusScopeNode menuScopeNode = FocusScopeNode(debugLabel: 'Menu Scope');
  final menuController = MenuController();

  @override
  MenuStatus get status => _status;
  MenuStatus _status = MenuStatus.closed;

  @override
  void initState() {
    super.initState();
    attachMenuController(menuController);
  }

  @override
  void dispose() {
    detachMenuController(menuController);
    animationController.stop();
    animationController.dispose();
    super.dispose();
  }

  // Animate the menu closed, then trigger the root menu to close the overlay.
  @override
  void onMenuClose() {
    if (_status case MenuStatus.closed || MenuStatus.closing) {
      return;
    }

    // When the animation controller finishes closing, the inner menu's onClose
    // callback will be called, thereby triggering the _handleClosed callback.
    animationController
      ..stop()
      ..animateBackWith(
        ClampedSimulation(
          xMin: 0.0,
          xMax: 1.0,
          SpringSimulation(
            AnimatedRawMenuAnchor._defaultReverseSpring,
            animationController.value,
            0.0,
            5.0,
            tolerance: _springTolerance,
          ),
        ),
      ).whenComplete(hideMenu);
    _status = MenuStatus.closing;
  }

  @override
  void onMenuOpen({ui.Offset? position}) {
    if (_status case MenuStatus.opened || MenuStatus.opening) {
      showMenu(position: position);
      return;
    }

    if (!menuController.isOpen) {
      showMenu(position: position);
    }

    animationController
      ..value = 0.0
      ..stop()
      ..animateWith(
        SpringSimulation(
          AnimatedRawMenuAnchor._defaultForwardSpring,
          animationController.value,
          1.0,
          5.0,
        ),
      ).whenComplete(_handleMenuOpened);
    _status = MenuStatus.opening;
  }

  // Sets the menu status to closed and sets the menu animation to 0.0. Does not
  // trigger the root menu to close the overlay.
  void _handleMenuClosed() {
    animationController
      ..value = 0
      ..stop();
    _status = MenuStatus.closed;
  }

  // Sets the menu status to opened and sets the menu animation to 1.0. Does not
  // trigger the root menu to open the overlay.
  void _handleMenuOpened() {
    animationController
      ..value = 1
      ..stop();
    _status = MenuStatus.opened;
  }

  @override
  Widget build(BuildContext context) {
    return RawMenuAnchor(
      controller: menuController,
      onClose: _handleMenuClosed,
      onOpen: onMenuOpen,
      alignment: Alignment.bottomCenter,
      menuAlignment: Alignment.topCenter,
      padding: const EdgeInsets.symmetric(vertical: 5),
      builder: (
        BuildContext context,
        MenuController controller,
        Widget? child,
      ) {
        return CupertinoButton(
          child: Icon(CupertinoIcons.ellipsis_circle),
          onPressed: () {
            if (controller.status
                case MenuStatus.opened || MenuStatus.opening) {
              controller.close();
            } else {
              controller.open();
            }
          },
        );
      },
      panel: FadeTransition(
        opacity: animationController.drive(
          Animatable.fromCallback((value) => ui.clampDouble(value, 0, 1)),
        ),
        child: ScaleTransition(
          alignment: Alignment.topCenter,
          scale: animationController,
          child: RawMenuPanel(
            padding: const EdgeInsets.symmetric(vertical: 5),
            menuChildren: [
              for (int index = 0; index < 4; index++)
                MenuItemButton(
                  child: Text('Menu Item $index'),
                  onPressed: () {},
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class AnimatedMenuExample extends StatelessWidget {
  const AnimatedMenuExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[AnimatedRawMenuAnchor()],
      ),
    );
  }
}

class AnimatedMenuApp extends StatelessWidget {
  const AnimatedMenuApp({super.key});

  static const ButtonStyle menuButtonStyle = ButtonStyle(
    splashFactory: InkSparkle.splashFactory,
    iconSize: WidgetStatePropertyAll<double>(17),
    overlayColor: WidgetStatePropertyAll<Color>(Color(0x0D1A1A1A)),
    padding: WidgetStatePropertyAll<EdgeInsets>(
        EdgeInsets.symmetric(horizontal: 12)),
    textStyle: WidgetStatePropertyAll<TextStyle>(TextStyle(fontSize: 14)),
    visualDensity: VisualDensity(
      horizontal: VisualDensity.minimumDensity,
      vertical: VisualDensity.minimumDensity,
    ),
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.from(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
      ).copyWith(
        menuButtonTheme: const MenuButtonThemeData(style: menuButtonStyle),
      ),
      home: const AnimatedMenuExample(),
    );
  }
}
