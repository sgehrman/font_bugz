import 'package:flutter/material.dart';
import 'package:font_bugz/dialogs/widget_dialog.dart';
import 'package:google_fonts/google_fonts.dart';

Future<void> showFontDialog({
  required BuildContext context,
}) {
  return widgetDialog(
    context: context,
    title: 'Choose a Font',
    builder: WidgetDialogContentBuilder(
      (keyboardNotifier, titleNotifier) => [
        const SizedBox(
          height: 1200,
          width: 900,
          child: _GoogleFontsWidget(),
        ),
      ],
    ),
  );
}

// ========================================================

class _FontObj {
  _FontObj({
    required this.name,
    required this.displayName,
    required this.fav,
    required this.firstChar,
  });

  final String name;
  final String displayName;
  final String firstChar;
  bool fav;
}

class _GoogleFontsWidget extends StatefulWidget {
  const _GoogleFontsWidget();

  @override
  _GoogleFontsWidgetState createState() => _GoogleFontsWidgetState();
}

class _GoogleFontsWidgetState extends State<_GoogleFontsWidget> {
  final ScrollController _scrollController = ScrollController();

  final _fontList = _buildFontList();

  static List<_FontObj> _buildFontList() {
    final List<String> gFonts = GoogleFonts.asMap().keys.toList();

    final result = <_FontObj>[];

    for (final f in gFonts) {
      final String fixed = f.replaceFirst('TextTheme', '');

      result.add(
        _FontObj(
          name: f,
          displayName: fixed.fromCamelCase(),
          fav: false,
          firstChar: f.toUpperCase().firstChar,
        ),
      );
    }

    return result;
  }

  Widget _contents(Color? normalColor, String currentFont) {
    return ListView.separated(
      separatorBuilder: (context, index) => const Divider(height: 2),
      controller: _scrollController,
      physics: const BouncingScrollPhysics(),
      itemCount: _fontList.length,
      itemBuilder: (context, index) {
        final fontObj = _fontList[index];

        return _FontItem(
          currentFont: currentFont,
          fontObj: fontObj,
          onPressed: () => print(fontObj),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final Color? normalColor = Theme.of(context).textTheme.bodyMedium!.color;

    return _contents(normalColor, 'Roboto');
  }
}

// ======================================================

class _FontItem extends StatelessWidget {
  const _FontItem({
    required this.fontObj,
    required this.currentFont,
    required this.onPressed,
  });

  final _FontObj fontObj;
  final String currentFont;
  final void Function() onPressed;

  TextStyle styleWithGoogleFont(String fontName, TextStyle textStyle) {
    return GoogleFonts.getFont(fontName, textStyle: textStyle);
  }

  @override
  Widget build(BuildContext context) {
    TextStyle style = Theme.of(context).textTheme.titleLarge!;

    // LOOK HERE crashes web/canvaskit
    // https://github.com/material-foundation/flutter-packages/issues/399
    style = styleWithGoogleFont(fontObj.name, style);

    if (fontObj.name == currentFont) {
      style = style.copyWith(color: Theme.of(context).primaryColor);
    }

    style = style.copyWith(fontSize: 22);

    return InkWell(
      key: Key(fontObj.name),
      onTap: () {
        print(fontObj.name);
      },
      child: Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 12),
              child: Text(
                fontObj.displayName,
                style: style,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

extension StringUtils on String {
  String get firstChar {
    if (this.isNotEmpty) {
      return substring(0, 1);
    }

    return '';
  }

  String fromCamelCase() {
    String displayName = '';
    bool lastUpper = false;
    for (final String r in characters) {
      if (r.toUpperCase() == r) {
        displayName += lastUpper ? r : ' $r';

        lastUpper = true;
      } else {
        lastUpper = false;

        if (displayName.isEmpty) {
          displayName += r.toUpperCase();
        } else {
          displayName += r;
        }
      }
    }

    return displayName;
  }
}
