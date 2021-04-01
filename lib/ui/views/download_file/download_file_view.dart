import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:pdf_render/pdf_render.dart';
import 'package:stacked/stacked.dart';
import 'package:pdf_render/pdf_render_widgets.dart';

import 'package:informbob_app/ui/views/download_file/download_file_viewmodel.dart';

class DownloadFileView extends StatelessWidget {
  const DownloadFileView({Key key}): super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<DownloadFileViewModel>.reactive(
      viewModelBuilder: () => DownloadFileViewModel(),
      onModelReady: (model) => model.downloadFile(),
      builder: (context, model, child) => Scaffold(
        body: Center(
          child: (() {
            if (model.file != null) {
              return PdfViewer.openData(model.file.readAsBytesSync());
            } else {
              return const Text('PDF wird geladen...');
            }
          })(),
        ),
      ),
    );
  }
}