import 'package:flutter/widgets.dart';

class App extends StatefulWidget {
  const App(
    this.child, {
    super.key,
    this.textDirection,
    this.alignment = Alignment.center,
  });
  final Widget child;
  final TextDirection? textDirection;
  final AlignmentGeometry alignment;

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  TextDirection? _directionality;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _directionality = Directionality.maybeOf(context);
  }

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: const Color(0xff000000),
      child: WidgetsApp(
        color: const Color(0xff000000),
        onGenerateRoute: (RouteSettings settings) {
          return PageRouteBuilder<void>(
            settings: settings,
            pageBuilder: _buildPage,
          );
        },
      ),
    );
  }

  Widget _buildPage(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
  ) {
    return Directionality(
      textDirection:
          widget.textDirection ?? _directionality ?? TextDirection.ltr,
      child: Align(
        alignment: widget.alignment,
        child: widget.child,
      ),
    );
  }
}
