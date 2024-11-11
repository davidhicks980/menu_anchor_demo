import 'package:flutter/material.dart'
    hide
        DropdownMenu,
        DropdownMenuEntry,
        DropdownMenuItem,
        MenuAnchor,
        MenuItemButton,
        SubmenuButton,
        MenuController;
import 'package:flutter/services.dart';

import 'menu_anchor.dart';
import 'raw_menu_anchor.dart';

/// An enhanced enum to define the available menus and their shortcuts.
///
/// Using an enum for menu definition is not required, but this illustrates how
/// they could be used for simple menu systems.
enum _MenuEntry {
  about('About'),
  showMessage(
      'Show Message', SingleActivator(LogicalKeyboardKey.keyS, control: true)),
  hideMessage(
      'Hide Message', SingleActivator(LogicalKeyboardKey.keyS, control: true)),
  colorMenu('Color Menu'),
  colorRed('Red Background',
      SingleActivator(LogicalKeyboardKey.keyR, control: true)),
  colorGreen('Green Background',
      SingleActivator(LogicalKeyboardKey.keyG, control: true)),
  colorBlue('Blue Background',
      SingleActivator(LogicalKeyboardKey.keyB, control: true));

  const _MenuEntry(this.label, [this.shortcut]);
  final String label;
  final MenuSerializableShortcut? shortcut;
}

class _MenuAnchorExample extends StatefulWidget {
  const _MenuAnchorExample({super.key, required this.message});

  final String message;

  @override
  State<_MenuAnchorExample> createState() => _MenuAnchorExampleState();
}

class _MenuAnchorExampleState extends State<_MenuAnchorExample> {
  _MenuEntry? _lastSelection;
  final FocusNode _buttonFocusNode = FocusNode(debugLabel: 'Menu Button');
  ShortcutRegistryEntry? _shortcutsEntry;

  Color get backgroundColor => _backgroundColor;
  Color _backgroundColor = Colors.red;
  set backgroundColor(Color value) {
    if (_backgroundColor != value) {
      setState(() {
        _backgroundColor = value;
      });
    }
  }

  bool get showingMessage => _showingMessage;
  bool _showingMessage = false;
  set showingMessage(bool value) {
    if (_showingMessage != value) {
      setState(() {
        _showingMessage = value;
      });
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Dispose of any previously registered shortcuts, since they are about to
    // be replaced.
    _shortcutsEntry?.dispose();
    // Collect the shortcuts from the different menu selections so that they can
    // be registered to apply to the entire app. Menus don't register their
    // shortcuts, they only display the shortcut hint text.
    final Map<ShortcutActivator, Intent> shortcuts =
        <ShortcutActivator, Intent>{
      for (final _MenuEntry item in _MenuEntry.values)
        if (item.shortcut != null)
          item.shortcut!: VoidCallbackIntent(() => _activate(item)),
    };
    // Register the shortcuts with the ShortcutRegistry so that they are
    // available to the entire application.
    _shortcutsEntry = ShortcutRegistry.of(context).addAll(shortcuts);
  }

  @override
  void dispose() {
    _shortcutsEntry?.dispose();
    _buttonFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        MenuAnchor(
          childFocusNode: _buttonFocusNode,
          menuChildren: <Widget>[
            MenuItemButton(
              child: Text(_MenuEntry.about.label),
              onPressed: () => _activate(_MenuEntry.about),
            ),
            if (_showingMessage)
              MenuItemButton(
                onPressed: () => _activate(_MenuEntry.hideMessage),
                shortcut: _MenuEntry.hideMessage.shortcut,
                child: Text(_MenuEntry.hideMessage.label),
              ),
            if (!_showingMessage)
              MenuItemButton(
                onPressed: () => _activate(_MenuEntry.showMessage),
                shortcut: _MenuEntry.showMessage.shortcut,
                child: Text(_MenuEntry.showMessage.label),
              ),
            SubmenuButton(
              menuChildren: <Widget>[
                MenuItemButton(
                  onPressed: () => _activate(_MenuEntry.colorRed),
                  shortcut: _MenuEntry.colorRed.shortcut,
                  child: Text(_MenuEntry.colorRed.label),
                ),
                MenuItemButton(
                  onPressed: () => _activate(_MenuEntry.colorGreen),
                  shortcut: _MenuEntry.colorGreen.shortcut,
                  child: Text(_MenuEntry.colorGreen.label),
                ),
                MenuItemButton(
                  onPressed: () => _activate(_MenuEntry.colorBlue),
                  shortcut: _MenuEntry.colorBlue.shortcut,
                  child: Text(_MenuEntry.colorBlue.label),
                ),
              ],
              child: const Text('Background Color'),
            ),
          ],
          builder:
              (BuildContext context, MenuController controller, Widget? child) {
            return TextButton(
              focusNode: _buttonFocusNode,
              onPressed: () {
                if (controller.isOpen) {
                  controller.close();
                } else {
                  controller.open();
                }
              },
              child: const Text('OPEN MENU'),
            );
          },
        ),
        Expanded(
          child: Container(
            alignment: Alignment.center,
            color: backgroundColor,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Text(
                    showingMessage ? widget.message : '',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                ),
                Text(_lastSelection != null
                    ? 'Last Selected: ${_lastSelection!.label}'
                    : ''),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _activate(_MenuEntry selection) {
    setState(() {
      _lastSelection = selection;
    });

    switch (selection) {
      case _MenuEntry.about:
        showAboutDialog(
          context: context,
          applicationName: 'MenuBar Sample',
          applicationVersion: '1.0.0',
        );
      case _MenuEntry.hideMessage:
      case _MenuEntry.showMessage:
        showingMessage = !showingMessage;
      case _MenuEntry.colorMenu:
        break;
      case _MenuEntry.colorRed:
        backgroundColor = Colors.red;
      case _MenuEntry.colorGreen:
        backgroundColor = Colors.green;
      case _MenuEntry.colorBlue:
        backgroundColor = Colors.blue;
    }
  }
}

class MenuAnchorExample extends StatelessWidget {
  const MenuAnchorExample({super.key});

  static const String kMessage = '"Talk less. Smile more." - A. Burr';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(child: _MenuAnchorExample(message: kMessage)));
  }
}
