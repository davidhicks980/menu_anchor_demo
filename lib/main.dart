import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:raw_menu_anchor_web/aliased_border.dart';
import 'package:raw_menu_anchor_web/raw_menu_anchor.0.dart';
import 'package:raw_menu_anchor_web/raw_menu_anchor.1.dart';
import 'package:raw_menu_anchor_web/raw_menu_anchor.2.dart';
import 'package:raw_menu_anchor_web/raw_menu_anchor.3.dart';

/// Flutter code sample for [NavigationDrawer].

void main() => runApp(const NavigationDrawerApp());

class ExampleDestination {
  const ExampleDestination(this.label, this.icon, this.selectedIcon);

  final String label;
  final Widget icon;
  final Widget selectedIcon;
}

const List<ExampleDestination> destinations = <ExampleDestination>[
  ExampleDestination(
      'Simple Menu', Icon(Icons.list_rounded), Icon(Icons.list_rounded)),
  ExampleDestination(
      'Context Menu', Icon(Icons.mouse_outlined), Icon(Icons.mouse_rounded)),
  ExampleDestination(
      'Overlay Builder', Icon(Icons.settings_outlined), Icon(Icons.settings)),
  ExampleDestination('Node (MenuBar)', Icon(Icons.fluorescent_outlined),
      Icon(Icons.fluorescent_rounded)),
];

class NavigationDrawerApp extends StatelessWidget {
  const NavigationDrawerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 0, 119, 255),
        ),
        splashFactory: InkSparkle.splashFactory,
        navigationDrawerTheme: NavigationDrawerThemeData(tileHeight: 36),
        useMaterial3: true,
      ),
      home: const NavigationDrawerExample(),
    );
  }
}

class NavigationDrawerExample extends StatefulWidget {
  const NavigationDrawerExample({super.key});

  @override
  State<NavigationDrawerExample> createState() =>
      _NavigationDrawerExampleState();
}

class _NavigationDrawerExampleState extends State<NavigationDrawerExample>
    with SingleTickerProviderStateMixin {
  static const borderColor = Color.fromARGB(255, 121, 121, 121);
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  late AnimationController controller;
  late Animation<double> animation;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    if (showNavigationDrawer) {
      controller.reverse();
    } else {
      controller.forward();
    }
    animation = Tween<double>(begin: 0.0, end: 1.0).animate(controller);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  int screenIndex = 0;
  bool showNavigationDrawer = false;
  bool disposeNavigationDrawer = false;
  Widget get screen {
    return switch (screenIndex) {
      0 => SimpleMenuExample(),
      1 => ContextMenuApp(),
      2 => MenuOverlayBuilderApp(),
      3 => MenuNodeApp(),
      _ => SimpleMenuExample(),
    };
  }

  void handleScreenChanged(int selectedScreen) {
    setState(() {
      screenIndex = selectedScreen;
    });
  }

  void toggleDrawer() {
    setState(() {
      showNavigationDrawer = !showNavigationDrawer;
    });
    if (!showNavigationDrawer) {
      controller.forward();
    } else {
      controller.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      body: SafeArea(
        bottom: false,
        top: false,
        child: Center(
          child: Stack(
            fit: StackFit.expand,
            children: [
              Builder(builder: (context) {
                final width = MediaQuery.sizeOf(context).width;
                final offset = showNavigationDrawer ? 250.0 : 50.0;
                return AnimatedPositioned(
                  duration: const Duration(milliseconds: 800),
                  left: offset,
                  width: width - offset,
                  top: 0,
                  bottom: 0,
                  curve: Curves.easeOutQuint,
                  child: Stack(
                    alignment: AlignmentDirectional.topStart,
                    children: <Widget>[screen],
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
                child: DecoratedBox(
                  position: DecorationPosition.foreground,
                  decoration: BoxDecoration(
                    border: AliasedBorder(
                      right: BorderSide(
                        color: borderColor,
                        width: 0.5,
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
                              child: NavigationDrawer(
                                onDestinationSelected: handleScreenChanged,
                                selectedIndex: screenIndex,
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        64, 16, 16, 10),
                                    child: Text(
                                      'Examples',
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleLarge,
                                    ),
                                  ),
                                  ...destinations.map(
                                    (ExampleDestination destination) {
                                      return NavigationDrawerDestination(
                                        backgroundColor: Colors.transparent,
                                        label: Text(destination.label),
                                        icon: Padding(
                                          padding:
                                              const EdgeInsets.only(left: 36),
                                          child: destination.icon,
                                        ),
                                        selectedIcon: Padding(
                                            padding:
                                                const EdgeInsets.only(left: 36),
                                            child: destination.selectedIcon),
                                      );
                                    },
                                  ),
                                  const Padding(
                                    padding:
                                        EdgeInsets.fromLTRB(70, 16, 28, 10),
                                    child: DecoratedBox(
                                      decoration: BoxDecoration(
                                        border: AliasedBorder(
                                          bottom: BorderSide(
                                            color: borderColor,
                                            width: 0.5,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Positioned(
                            top: 0,
                            height: 50,
                            width: 50,
                            right: 0,
                            child: Center(
                              child: IconButton(
                                iconSize: 24,
                                constraints:
                                    BoxConstraints.tight(const Size(56, 56)),
                                onPressed: toggleDrawer,
                                visualDensity: VisualDensity.compact,
                                splashColor: Colors.transparent,
                                highlightColor: Colors.transparent,
                                hoverColor: Colors.transparent,
                                icon: Icon(
                                  showNavigationDrawer
                                      ? Icons.menu_open_rounded
                                      : Icons.menu_rounded,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onSurfaceVariant,
                                ),
                              ),
                            ),
                          ),
                        ],
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
