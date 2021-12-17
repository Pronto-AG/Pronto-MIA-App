import 'package:html_editor_enhanced/html_editor.dart';

HtmlToolbarOptions htmlToolbarSettings() => const HtmlToolbarOptions(
      dropdownMenuMaxHeight: 300,
      defaultToolbarButtons: [
        StyleButtons(),
        FontSettingButtons(
          fontName: false,
        ),
        FontButtons(),
        ColorButtons(),
        ListButtons(listStyles: false),
        ParagraphButtons(
          caseConverter: false,
          lineHeight: false,
        ),
        InsertButtons(
          picture: false,
          video: false,
          audio: false,
          table: false,
          hr: false,
        ),
      ],
    );
