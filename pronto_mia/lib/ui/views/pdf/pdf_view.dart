import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:pdf_render/pdf_render_widgets.dart';

import 'package:pronto_mia/ui/views/pdf/pdf_viewmodel.dart';

class PdfView extends StatelessWidget {
  final String title;
  final String subTitle;
  final String pdfPath;

  const PdfView({
    Key key,
    @required this.title,
    @required this.subTitle,
    @required this.pdfPath,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<PdfViewModel>.reactive(
      viewModelBuilder: () => PdfViewModel(pdfPath: pdfPath),
      builder: (context, model, child) {
        if (model.isBusy) {
          return const Center(
              child: CircularProgressIndicator()
          );
        }

        if (model.hasError) {
          return Center(
            child: Text(model.errorMessage),
          );
        }

        return PdfViewer.openData(model.data.readAsBytesSync());
      }
    );
  }
}
