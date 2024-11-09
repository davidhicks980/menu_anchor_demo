import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:raw_menu_anchor_web/aliased_border.dart';

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
      'Messages', Icon(Icons.widgets_outlined), Icon(Icons.widgets)),
  ExampleDestination(
      'Profile', Icon(Icons.format_paint_outlined), Icon(Icons.format_paint)),
  ExampleDestination(
      'Settings', Icon(Icons.settings_outlined), Icon(Icons.settings)),
];

class NavigationDrawerApp extends StatelessWidget {
  const NavigationDrawerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      themeMode: ThemeMode.dark,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 0, 119, 255),
        ),
        splashFactory: InkSparkle.splashFactory,
        navigationBarTheme: NavigationBarThemeData(elevation: 0),
        visualDensity: VisualDensity(
          vertical: VisualDensity.minimumDensity,
          horizontal: VisualDensity.minimumDensity,
        ),
        useMaterial3: false,
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

class _NavigationDrawerExampleState extends State<NavigationDrawerExample> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  int screenIndex = 0;
  bool showNavigationDrawer = false;
  bool disposeNavigationDrawer = false;
  static const borderColor = Color(0xFF9A9A9A);

  void handleScreenChanged(int selectedScreen) {
    setState(() {
      screenIndex = selectedScreen;
    });
  }

  void toggleDrawer() {
    setState(() {
      showNavigationDrawer = !showNavigationDrawer;
    });
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
              AnimatedPositioned(
                left: showNavigationDrawer ? 0 : -100,
                width: showNavigationDrawer ? 304 : 0,
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
                      maxWidth: 304,
                      minWidth: 0,
                      child: NavigationDrawer(
                        elevation: 0,
                        onDestinationSelected: handleScreenChanged,
                        selectedIndex: screenIndex,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.fromLTRB(28, 16, 16, 10),
                            child: Text(
                              'Examples',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                          ),
                          ...destinations.map(
                            (ExampleDestination destination) {
                              return NavigationDrawerDestination(
                                label: Text(destination.label),
                                icon: destination.icon,
                                selectedIcon: destination.selectedIcon,
                              );
                            },
                          ),
                          const Padding(
                            padding: EdgeInsets.fromLTRB(28, 16, 28, 10),
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
                ),
              ),
              Builder(builder: (context) {
                final width = MediaQuery.sizeOf(context).width;
                final offset = showNavigationDrawer ? 304.0 : 0.0;
                return AnimatedPositioned(
                  duration: const Duration(milliseconds: 800),
                  left: offset,
                  width: width - offset,
                  curve: Curves.easeOutQuint,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Text('Page Index = $screenIndex'),
                      ElevatedButton(
                        onPressed: toggleDrawer,
                        child: const Text('Open Drawer'),
                      ),
                    ],
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}

class AliasedLine extends StatelessWidget {
  const AliasedLine({
    super.key,
    required this.border,
    required this.begin,
    required this.end,
    required this.overlayColor,
    this.antiAlias = false,
    this.offset = Offset.zero,
  });

  final BorderSide border;
  final Alignment begin;
  final Alignment end;
  final Color overlayColor;
  final bool antiAlias;
  final Offset offset;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _AliasedLinePainter(
        border: border,
        begin: begin,
        end: end,
        overlayColor: overlayColor,
        antiAlias: antiAlias,
        offset: offset,
      ),
    );
  }
}

class _AliasedLinePainter extends CustomPainter {
  const _AliasedLinePainter({
    required this.border,
    required this.begin,
    required this.end,
    required this.overlayColor,
    this.antiAlias = false,
    this.offset = Offset.zero,
  });

  final BorderSide border;
  final Alignment begin;
  final Alignment end;
  final Color overlayColor;
  final bool antiAlias;
  final Offset offset;

  @override
  void paint(Canvas canvas, Size size) {
    final Offset p1 = begin.alongSize(size) + offset;
    final Offset p2 = end.alongSize(size) + offset;

    // BlendMode.overlay is not supported on the web.
    if (!kIsWeb) {
      final Paint overlayPainter = border.toPaint()
        ..color = overlayColor
        ..isAntiAlias = antiAlias
        ..blendMode = BlendMode.overlay;
      canvas.drawLine(p1, p2, overlayPainter);
    }

    final Paint colorPainter = border.toPaint()..isAntiAlias = antiAlias;
    canvas.drawLine(p1, p2, colorPainter);
  }

  @override
  bool shouldRepaint(_AliasedLinePainter oldDelegate) {
    return end != oldDelegate.end ||
        begin != oldDelegate.begin ||
        border != oldDelegate.border ||
        offset != oldDelegate.offset ||
        antiAlias != oldDelegate.antiAlias ||
        overlayColor != oldDelegate.overlayColor;
  }
}
