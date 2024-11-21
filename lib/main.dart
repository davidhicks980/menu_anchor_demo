import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:raw_menu_anchor_web/aliased_border.dart';
import 'package:raw_menu_anchor_web/raw_menu_anchor.0.dart';
import 'package:raw_menu_anchor_web/raw_menu_anchor.1.dart';
import 'package:raw_menu_anchor_web/raw_menu_anchor.2.dart';
import 'package:raw_menu_anchor_web/raw_menu_anchor.3.dart';

import 'dropdown_menu.0.dart';
import 'menu_anchor.0.dart';
import 'menu_anchor.padding.dart';
import 'raw_menu_anchor.alignment.dart';
import 'raw_menu_anchor.padding.dart';

/// Flutter code sample for [NavigationDrawer].

void main() => runApp(const NavigationDrawerApp());

const _kLightBorderColor = Color.fromARGB(255, 121, 121, 121);
const _kDarkBorderColor = Color.fromARGB(255, 76, 76, 76);

enum Destination {
  simpleMenu(
    "Simple Menu",
    icon: Icon(Icons.list_outlined),
    selectedIcon: Icon(Icons.list_rounded),
  ),
  contextMenu(
    "Context Menu",
    icon: Icon(Icons.mouse_outlined),
    selectedIcon: Icon(Icons.mouse_rounded),
  ),
  overlayBuilder(
    "Overlay Builder",
    icon: Icon(Icons.settings_outlined),
    selectedIcon: Icon(Icons.settings),
  ),
  nodeMenu(
    "Node",
    icon: Icon(Icons.fluorescent_outlined),
    selectedIcon: Icon(Icons.fluorescent_rounded),
  ),
  alignment(
    "Alignment",
    icon: Icon(Icons.align_horizontal_center_outlined),
    selectedIcon: Icon(Icons.align_horizontal_center_rounded),
    isDevelopment: true,
  ),
  padding(
    "Padding",
    icon: Icon(Icons.padding_outlined),
    selectedIcon: Icon(Icons.padding_rounded),
    isDevelopment: true,
  ),
  menuAnchor(
    "Menu Anchor",
    icon: Icon(Icons.anchor_outlined),
    selectedIcon: Icon(Icons.anchor_rounded),
    isDevelopment: true,
  ),
  menuAnchorPaddingBug(
    "Menu Anchor Padding Bug",
    icon: Icon(Icons.anchor_outlined),
    selectedIcon: Icon(Icons.anchor_rounded),
    isDevelopment: true,
  ),
  dropdownMenu(
    "Dropdown Menu",
    icon: Icon(Icons.arrow_drop_down_circle_outlined),
    selectedIcon: Icon(Icons.arrow_drop_down_circle_rounded),
    isDevelopment: true,
  );

  const Destination(
    this.label, {
    required this.icon,
    required this.selectedIcon,
    this.isDevelopment = false,
  });

  final String label;
  final Widget icon;
  final Widget selectedIcon;
  final bool isDevelopment;
  String get route =>
      "/${label.toLowerCase().replaceAll(r'\W', "").replaceAll(' ', '_')}";
  static Destination? findByRoute(String route) {
    for (final value in Destination.values) {
      if (value.route == route) {
        return value;
      }
    }
    return null;
  }
}

class NavigationDrawerApp extends StatefulWidget {
  const NavigationDrawerApp({super.key});

  @override
  State<NavigationDrawerApp> createState() => _NavigationDrawerAppState();
}

class _NavigationDrawerAppState extends State<NavigationDrawerApp> {
  bool _isRTL = false;
  bool _isDarkMode = false;
  double _textScaleFactor = 1.0;
  TextDirection get _textDirection =>
      _isRTL ? TextDirection.rtl : TextDirection.ltr;
  Brightness get _brightness =>
      _isDarkMode ? Brightness.dark : Brightness.light;

  Widget Function(BuildContext) _page(Widget child) {
    return (context) {
      return Directionality(
        textDirection: _textDirection,
        child: NavigationDrawerExample(
          settings: Settings(
            isRTL: _isRTL,
            setRTL: (value) {
              setState(() {
                _isRTL = value;
              });
            },
            isDarkMode: _isDarkMode,
            setDarkMode: (value) {
              setState(() {
                _isDarkMode = value;
              });
            },
            textScaleFactor: _textScaleFactor,
            setTextScaleFactor: (value) {
              setState(() {
                _textScaleFactor = value;
              });
            },
          ),
          child: child,
        ),
      );
    };
  }

  @override
  Widget build(BuildContext context) {
    final app = Directionality(
        textDirection: _textDirection,
        child: MaterialApp(
          theme: ThemeData(
            fontFamily: "Inter",
            dividerTheme: DividerThemeData(
              thickness: 1 / (MediaQuery.maybeDevicePixelRatioOf(context) ?? 1),
              color: _isDarkMode ? _kDarkBorderColor : _kLightBorderColor,
            ),
            pageTransitionsTheme: PageTransitionsTheme(
              builders: Map.fromEntries(TargetPlatform.values.map(
                (TargetPlatform platform) {
                  return MapEntry(platform, DisabledPageTransition());
                },
              ).toList()),
            ),
            colorScheme: ColorScheme.fromSeed(
              seedColor: const Color.fromARGB(255, 0, 119, 255),
              brightness: _brightness,
            ),
            splashFactory: InkSparkle.splashFactory,
            navigationDrawerTheme: NavigationDrawerThemeData(tileHeight: 36),
          ),
          routes: {
            Destination.simpleMenu.route: _page(const SimpleMenuExample()),
            Destination.contextMenu.route: _page(const ContextMenuExample()),
            Destination.overlayBuilder.route:
                _page(const MenuOverlayBuilderApp()),
            Destination.nodeMenu.route: _page(const MenuNodeExample()),
            Destination.alignment.route: _page(const AlignmentExample()),
            Destination.padding.route: _page(const PaddingExample()),
            Destination.menuAnchor.route: _page(const MenuAnchorExample()),
            Destination.menuAnchorPaddingBug.route:
                _page(const MenuAnchorPaddingBugExample()),
            Destination.dropdownMenu.route: _page(const DropdownMenuExample()),
          },
          home: _page(SimpleMenuExample())(context),
        ));
    return Builder(builder: (context) {
      return MediaQuery(
        data: MediaQuery.of(context).copyWith(
          textScaler: TextScaler.linear(_textScaleFactor),
          platformBrightness: _brightness,
        ),
        child: app,
      );
    });
  }
}

class NavigationDrawerExample extends StatefulWidget {
  const NavigationDrawerExample({
    super.key,
    required this.child,
    required this.settings,
  });

  final Widget child;
  final Widget settings;

  @override
  State<NavigationDrawerExample> createState() =>
      _NavigationDrawerExampleState();
}

class _NavigationDrawerExampleState extends State<NavigationDrawerExample>
    with SingleTickerProviderStateMixin {
  bool showNavigationDrawer = true;
  bool disposeNavigationDrawer = false;

  int get _selectedIndex => Destination.values.indexOf(
      Destination.findByRoute(ModalRoute.of(context)!.settings.name ?? "") ??
          Destination.simpleMenu);

  void handleScreenChanged(int selectedScreen) {
    Navigator.pushReplacementNamed(
        context, Destination.values[selectedScreen].route);
  }

  void toggleDrawer() {
    setState(() {
      showNavigationDrawer = !showNavigationDrawer;
    });
  }

  @override
  Widget build(BuildContext context) {
    final dividerTheme = DividerTheme.of(context);
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Stack(
            fit: StackFit.expand,
            children: [
              Builder(builder: (context) {
                final size = MediaQuery.sizeOf(context);
                final offset = showNavigationDrawer ? 250.0 : 50.0;
                return AnimatedPositioned(
                  duration: const Duration(milliseconds: 800),
                  left: offset,
                  width: size.width - offset,
                  top: 0,
                  bottom: 0,
                  curve: Curves.easeOutQuint,
                  child: Stack(
                    alignment: Alignment.center,
                    children: <Widget>[
                      widget.child,
                    ],
                  ),
                );
              }),
              AnimatedPositioned(
                left: showNavigationDrawer ? -50 : -250,
                width: 300,
                top: 0,
                bottom: 0,
                duration: const Duration(milliseconds: 800),
                curve: Curves.easeOutQuint,
                child: TapRegion(
                  onTapOutside: (event) {
                    if (showNavigationDrawer &&
                        (defaultTargetPlatform == TargetPlatform.android ||
                            defaultTargetPlatform == TargetPlatform.iOS)) {
                      toggleDrawer();
                    }
                  },
                  child: DecoratedBox(
                    position: DecorationPosition.foreground,
                    decoration: BoxDecoration(
                      border: AliasedBorder(
                        right: BorderSide(
                          color: dividerTheme.color!,
                          width: dividerTheme.thickness ?? 0.5,
                        ),
                      ),
                    ),
                    child: ClipRect(
                      child: OverflowBox(
                        alignment: AlignmentDirectional.topStart,
                        fit: OverflowBoxFit.deferToChild,
                        maxWidth: 300,
                        minWidth: 0,
                        child: Stack(
                          children: [
                            Positioned(
                              top: 0,
                              bottom: 0,
                              left: 0,
                              child: AnimatedOpacity(
                                duration: const Duration(milliseconds: 800),
                                curve: Curves.easeOutQuint,
                                opacity: showNavigationDrawer ? 1 : 0,
                                child: FocusTraversalGroup(
                                  descendantsAreTraversable:
                                      showNavigationDrawer,
                                  descendantsAreFocusable: showNavigationDrawer,
                                  child: _Drawer(
                                    onDestinationSelected: handleScreenChanged,
                                    selectedIndex: _selectedIndex,
                                    settings: widget.settings,
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              top: 2,
                              height: 50,
                              width: 50,
                              right: 0,
                              child: Center(
                                child: MenuButton(
                                  isOpen: showNavigationDrawer,
                                  onPressed: toggleDrawer,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Drawer extends StatelessWidget {
  const _Drawer({
    required this.onDestinationSelected,
    required this.selectedIndex,
    this.settings,
  });
  final void Function(int) onDestinationSelected;
  final int selectedIndex;
  final Widget? settings;

  @override
  Widget build(BuildContext context) {
    final dividerTheme = DividerTheme.of(context);
    return MediaQuery.withNoTextScaling(
      child: DefaultTextStyle.merge(
        child: ColoredBox(
          color: Theme.of(context).navigationDrawerTheme.backgroundColor ??
              Theme.of(context).colorScheme.surfaceContainer,
          child: NavigationDrawer(
            onDestinationSelected: onDestinationSelected,
            selectedIndex: selectedIndex,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(64, 16, 16, 10),
                child: Text(
                  'Examples',
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge!
                      .copyWith(fontWeight: FontWeight.w800, fontSize: 24),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(64, 16, 16, 10),
                child: Text(
                  'Documentation',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
              ),
              for (final destination in Destination.values
                  .where((destination) => !destination.isDevelopment))
                NavigationDrawerDestination(
                  backgroundColor: Colors.transparent,
                  label: Text(destination.label),
                  icon: Padding(
                    padding: const EdgeInsets.only(left: 36),
                    child: destination.icon,
                  ),
                  selectedIcon: Padding(
                    padding: const EdgeInsets.only(left: 36),
                    child: destination.selectedIcon,
                  ),
                ),
              Padding(
                padding: const EdgeInsets.fromLTRB(64, 16, 16, 10),
                child: Text(
                  'Development',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
              ),
              for (final destination in Destination.values
                  .where((destination) => destination.isDevelopment))
                NavigationDrawerDestination(
                  backgroundColor: Colors.transparent,
                  label: Text(destination.label),
                  icon: Padding(
                    padding: const EdgeInsets.only(left: 36),
                    child: destination.icon,
                  ),
                  selectedIcon: Padding(
                    padding: const EdgeInsets.only(left: 36),
                    child: destination.selectedIcon,
                  ),
                ),
              Padding(
                padding: EdgeInsets.fromLTRB(70, 16, 28, 10),
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    border: AliasedBorder(
                      bottom: BorderSide(
                        color: dividerTheme.color!,
                        width: dividerTheme.thickness ?? 0.5,
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(68, 16, 28, 10),
                child: settings!,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MenuButton extends StatelessWidget {
  const MenuButton({super.key, required this.isOpen, required this.onPressed});

  final bool isOpen;
  final void Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: IconButton(
        iconSize: 24,
        constraints: BoxConstraints.tight(const Size(56, 56)),
        onPressed: onPressed,
        visualDensity: VisualDensity.compact,
        splashColor: Colors.transparent,
        color: Colors.transparent,
        icon: Icon(
          isOpen ? Icons.menu_open_rounded : Icons.menu_rounded,
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }
}

class DisabledPageTransition extends PageTransitionsBuilder {
  /// Constructs a page transition animation that matches the iOS transition.
  const DisabledPageTransition();

  @override
  Widget buildTransitions<T>(
    PageRoute<T> route,
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return child;
  }
}

class Settings extends StatelessWidget {
  const Settings({
    super.key,
    required this.isRTL,
    required this.setRTL,
    required this.isDarkMode,
    required this.setDarkMode,
    required this.textScaleFactor,
    required this.setTextScaleFactor,
  });
  final bool isRTL;
  final ValueSetter<bool> setRTL;

  final bool isDarkMode;
  final ValueSetter<bool> setDarkMode;

  final double textScaleFactor;
  final ValueSetter<double> setTextScaleFactor;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHigh,
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: DefaultTextStyle.merge(
        style: TextStyle(
          fontFamily: "Inter",
          letterSpacing: -0.21,
          fontWeight: FontWeight.w500,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            GestureDetector(
              onTap: () {
                setDarkMode(!isDarkMode);
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Dark mode'),
                  Switch(
                    value: isDarkMode,
                    onChanged: setDarkMode,
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTap: () {
                setRTL(!isRTL);
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('RTL'),
                  Switch(
                    value: isRTL,
                    onChanged: setRTL,
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Text scale'),
                Flexible(
                  child: Slider(
                    value: textScaleFactor,
                    onChanged: setTextScaleFactor,
                    min: 0,
                    max: 3,
                  ),
                ),
              ],
            ),
            Text(
              "Text scale: ${textScaleFactor.toStringAsFixed(2)}",
              style: Theme.of(context)
                  .textTheme
                  .bodySmall!
                  .copyWith(letterSpacing: -0.21, color: Colors.grey.shade600),
            ),
          ],
        ),
      ),
    );
  }
}
