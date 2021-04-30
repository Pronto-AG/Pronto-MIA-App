import 'package:flutter/material.dart';
import 'package:pronto_mia/core/models/file_upload.dart';
import 'package:stacked/stacked.dart';
import 'package:pdf_render/pdf_render_widgets.dart';

import 'package:pronto_mia/ui/views/pdf/pdf_viewmodel.dart';

class PdfView extends StatelessWidget {
  final String title;
  final String subTitle;
  final FileUpload pdfUpload;
  final String pdfPath;

  const PdfView({
    Key key,
    @required this.title,
    this.subTitle,
    this.pdfUpload,
    this.pdfPath,
  }) : super(key: key);

  // TODO: Review pdf lag when moving it around
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<PdfViewModel>.reactive(
      viewModelBuilder: () => PdfViewModel(
        pdfUpload: pdfUpload,
        pdfPath: pdfPath,
      ),
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
        body: (() {
          if (model.isBusy) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (model.hasError) {
            return Center(
              child: Text(model.errorMessage),
            );
          }

          if (model.data != null) {
            return PdfViewer.openData(model.data.readAsBytesSync());
          } else {
            return PdfViewer.openData(model.pdfUpload.bytes);
          }
        })(),
      ),
    );
  }
}
