import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:pronto_mia/ui/components/data_view_layout.dart';
import 'package:pronto_mia/ui/views/pdf/pdf_viewmodel.dart';
import 'package:stacked/stacked.dart';

/// A widget, representing the pdf view.
///
class PdfView extends StatefulWidget {
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

  @override
  _PdfViewState createState() => _PdfViewState();
}

class _PdfViewState extends State<PdfView> with WidgetsBindingObserver {
  final Completer<PDFViewController> _controller =
      Completer<PDFViewController>();
  int pages = 0;
  int currentPage = 1;

  /// Binds [PdfViewModel] and builds the widget.
  ///
  /// Takes the current [BuildContext] as an input.
  /// Returns the built [Widget].
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<PdfViewModel>.reactive(
      viewModelBuilder: () => PdfViewModel(pdfFile: widget.pdfFile),
      builder: (context, model, child) => Scaffold(
        appBar: AppBar(
          title: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(widget.title),
              if (widget.subTitle != null)
                Text(widget.subTitle, style: const TextStyle(fontSize: 12.0))
            ],
          ),
        ),
        body: DataViewLayout(
          isBusy: model.isBusy,
          errorMessage: model.errorMessage,
          // childBuilder: () => PdfViewer.openData(model.data.bytes),
          childBuilder: () => PDFView(
            pdfData: model.data.bytes,
            onRender: (_pages) {
              setState(() {
                pages = _pages;
              });
            },
            onViewCreated: (PDFViewController pdfViewController) {
              _controller.complete(pdfViewController);
            },
            onPageChanged: (int page, int total) {
              setState(() {
                currentPage = page + 1;
              });
            },
          ),
        ),
        floatingActionButton: FutureBuilder<PDFViewController>(
          future: _controller.future,
          builder: (context, AsyncSnapshot<PDFViewController> snapshot) {
            if (snapshot.hasData) {
              return FloatingActionButton.extended(
                onPressed: () {},
                label: Text("$currentPage / $pages"),
              );
            }

            return Container();
          },
        ),
      ),
    );
  }
}
