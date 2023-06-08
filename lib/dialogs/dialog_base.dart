import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/material.dart';

enum DialogResult {
  ok,
  canceled,
  error,
}

const _fontMode = false;

class BaseDialogRoute<T> extends ModalRoute<T> {
  BaseDialogRoute()
      : super(
          filter: _fontMode
              ? null
              : ImageFilter.blur(
                  sigmaX: 3,
                  sigmaY: 3,
                ),
        );

  final _keyboardNotifier = ValueNotifier<bool>(false);

  @override
  Duration get transitionDuration => const Duration(milliseconds: 300);

  @override
  bool get opaque => false;

  @override
  bool get barrierDismissible => true;

  @override
  Color get barrierColor => Colors.black.withOpacity(_fontMode ? 0 : 0.5);

  @override
  String get barrierLabel => '';

  @override
  bool get maintainState => true;

  bool isDarkMode(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark;
  }

  @override
  Widget buildPage(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
  ) {
    final titleNotifier = ValueNotifier<String>(dialogTitle());
    final screenSize = MediaQuery.of(context).size;

    final contents = Container(
      constraints: BoxConstraints(
        maxHeight: screenSize.height * 0.9,
        maxWidth: screenSize.width * 0.9,
      ),
      width: math.min(screenSize.width * 0.9, width()),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: const BorderRadius.all(Radius.circular(22)),
        border: Border.fromBorderSide(
          BorderSide(
            color: Colors.black,
            width: isDarkMode(context) ? 1 : 0,
          ),
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: Material(
        type: MaterialType.transparency,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _DialogHeader(
              titleNotifier: titleNotifier,
              titleButton: titleButton(context),
            ),
            Flexible(
              child: AnimatedSize(
                duration: const Duration(milliseconds: 200),
                child: dialogWidget(
                  context,
                  _keyboardNotifier,
                  titleNotifier,
                ),
              ),
            ),
          ],
        ),
      ),
    );

    if (centered()) {
      return Center(child: contents);
    }

    return Align(alignment: Alignment.bottomLeft, child: contents);
  }

  // override
  Widget dialogWidget(
    BuildContext context,
    ValueNotifier<bool> keyboardNotifier,
    ValueNotifier<String> titleNotifier,
  ) {
    return const Text('must override');
  }

  // override
  String dialogTitle() {
    return '';
  }

  // override to replace the close button
  Widget titleButton(BuildContext context) {
    return IconButton(
      tooltip: 'Close',
      iconSize: 30,
      onPressed: () {
        Navigator.of(context).pop();
      },
      icon: const Icon(Icons.clear),
    );
  }

  // override, override to null to remove the X button
  Color titleButtonColor(BuildContext context) {
    return Colors.white;
  }

  // override
  double width() {
    return 600;
  }

  // override
  bool centered() {
    return true;
  }

  @override
  Widget buildTransitions(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    final curvedValue = Curves.easeOut.transform(animation.value) - 1.0;

    return Transform(
      transform: Matrix4.translationValues(0, -curvedValue * 200, 0),
      child: Opacity(
        opacity: animation.value,
        child: child,
      ),
    );
  }
}

// ==========================================================
//      final title = dialogTitle();

class _DialogHeader extends StatelessWidget {
  const _DialogHeader({
    required this.titleNotifier,
    required this.titleButton,
  });

  final ValueNotifier<String> titleNotifier;
  final Widget titleButton;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ValueListenableBuilder(
      valueListenable: titleNotifier,
      builder: (context, value, child) {
        if (value.isNotEmpty) {
          return Theme(
            data: theme.copyWith(
              iconTheme: theme.iconTheme.copyWith(
                color: Colors.white,
              ),
            ),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black,
                // should work without this, but seeing some slight bleed
                // on the corners over the border
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(22),
                  topRight: Radius.circular(22),
                ),
              ),
              padding:
                  const EdgeInsets.only(left: 20, right: 14, top: 4, bottom: 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Text(
                      value,
                    ),
                  ),
                  titleButton,
                ],
              ),
            ),
          );
        }

        return const SizedBox();
      },
    );
  }
}
