import 'package:flutter/material.dart';
import 'package:font_bugz/dialogs/dialog_base.dart';

Future<T?> widgetDialog<T>({
  required BuildContext context,
  required String title,
  required WidgetDialogContentBuilder builder,
  double dialogWidth = 500,
  bool scrollable = true,
  List<Widget> titleButtons = const [],
  EdgeInsetsGeometry padding = const EdgeInsets.all(20),
  bool centerDialog = true,
}) {
  return Navigator.of(context).push(
    _WidgetDialogRoute<T>(
      title: title,
      dialogWidth: dialogWidth,
      builder: builder,
      scrollable: scrollable,
      titleButtons: titleButtons,
      padding: padding,
      centerDialog: centerDialog,
    ),
  );
}

class WidgetDialogContentBuilder {
  const WidgetDialogContentBuilder(this.builder);

  final List<Widget> Function(
    ValueNotifier<bool> keyboardNotifier,
    ValueNotifier<String> titleNotifier,
  ) builder;
}

// ======================================================

class _WidgetDialogWidget extends StatefulWidget {
  const _WidgetDialogWidget({
    required this.children,
    required this.scrollable,
    required this.padding,
  });

  final List<Widget> children;
  final bool scrollable;
  final EdgeInsetsGeometry padding;

  @override
  State<_WidgetDialogWidget> createState() => _WidgetDialogWidgetState();
}

class _WidgetDialogWidgetState extends State<_WidgetDialogWidget> {
  @override
  Widget build(BuildContext context) {
    final child = Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: widget.children,
    );

    if (widget.scrollable) {
      return SingleChildScrollView(
        padding: widget.padding,
        child: child,
      );
    }

    return Padding(
      padding: widget.padding,
      child: child,
    );
  }
}

// ======================================================

class _WidgetDialogRoute<T> extends BaseDialogRoute<T> {
  _WidgetDialogRoute({
    required this.title,
    required this.dialogWidth,
    required this.scrollable,
    required this.builder,
    required this.padding,
    this.titleButtons = const [],
    this.centerDialog = true,
  });

  final String title;
  final double dialogWidth;
  final WidgetDialogContentBuilder builder;
  final bool scrollable;
  final List<Widget> titleButtons;
  final bool centerDialog;
  final EdgeInsetsGeometry padding;

  @override
  Widget dialogWidget(
    BuildContext context,
    ValueNotifier<bool> keyboardNotifier,
    ValueNotifier<String> titleNotifier,
  ) {
    return _WidgetDialogWidget(
      scrollable: scrollable,
      padding: padding,
      children: builder.builder(
        keyboardNotifier,
        titleNotifier,
      ),
    );
  }

  @override
  double width() {
    return dialogWidth;
  }

  @override
  Widget titleButton(BuildContext context) {
    final closeButton = super.titleButton(context);
    final children = [...titleButtons, closeButton];

    children.addDividers(divider: const SizedBox(width: 10));

    return Row(children: children);
  }

  @override
  String dialogTitle() {
    return title;
  }

  @override
  bool centered() {
    return centerDialog;
  }
}

extension ExtendedList on List<dynamic> {
  List<Widget> addDividers({Widget divider = const Divider(height: 6)}) {
    final List<Widget> result = [];

    if (length < 2) {
      return this as List<Widget>;
    }

    for (int i = 0; i < length; i++) {
      result.add(this[i] as Widget);

      if (i < length - 1) {
        result.add(divider);
      }
    }

    return result;
  }
}
