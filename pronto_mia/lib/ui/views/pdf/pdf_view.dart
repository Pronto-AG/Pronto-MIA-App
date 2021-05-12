import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:stacked/stacked.dart';

import 'package:pronto_mia/ui/views/pdf/pdf_viewmodel.dart';
import 'package:pronto_mia/ui/components/data_view_layout.dart';

class PdfView extends StatelessWidget {
  final String title;
  final String subTitle;
  final Object pdfFile;

  const PdfView({
    Key key,
    @required this.title,
    this.subTitle,
    @required this.pdfFile,
  }) : super(key: key);

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
