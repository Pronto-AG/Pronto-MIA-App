import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:pronto_mia/ui/components/data_view_layout.dart';
import 'package:pronto_mia/ui/views/pdf/pdf_viewmodel.dart';
import 'package:stacked/stacked.dart';

/// A widget, representing the pdf view.
class PdfView extends StatelessWidget {
  final String title;
  final String subTitle;
  final Object pdfFile;

  /// Initializes a new instance of [PdfView].
  ///
  /// Takes a [Key] to uniquely identify the widget in the widget tree, a
  /// [String] title and optional subtitle to display and the [Object] pdf file
  /// to render.
  const PdfView({
    Key key,
    @required this.title,
    this.subTitle,
    @required this.pdfFile,
  }) : super(key: key);

  /// Binds [PdfViewModel] and builds the widget.
  ///
  /// Takes the current [BuildContext] as an input.
  /// Returns the built [Widget].
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<PdfViewModel>.reactive(
      viewModelBuilder: () => PdfViewModel(pdfFile: pdfFile),
      builder: (context, model, child) => Scaffold(
        appBar: AppBar(
            title: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(title),
            if (subTitle != null)
              Text(subTitle, style: const TextStyle(fontSize: 12.0))
          ],
        )),
        body: DataViewLayout(
          isBusy: model.isBusy,
          errorMessage: model.errorMessage,
          // childBuilder: () => PdfViewer.openData(model.data.bytes),
          childBuilder: () => PDFView(
            pdfData: model.data.bytes,
          ),
        ),
      ),
    );
  }
}
