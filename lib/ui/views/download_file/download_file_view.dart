import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import 'package:informbob_app/ui/views/download_file/download_file_viewmodel.dart';

class DownloadFileView extends StatelessWidget {
  const DownloadFileView({Key key}): super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<DownloadFileViewModel>.reactive(
      viewModelBuilder: () => DownloadFileViewModel(),
      onModelReady: (model) => model.downloadFile(),
      builder: (context, model, child) => const Scaffold(
        body: Text('PDF'),
      )
    );
  }
}