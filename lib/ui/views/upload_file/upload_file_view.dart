import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import 'package:informbob_app/ui/views/upload_file/upload_file_viewmodel.dart';

class UploadFileView extends StatelessWidget {
  const UploadFileView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<UploadFileViewModel>.reactive(
      viewModelBuilder: () => UploadFileViewModel(),
      builder: (context, model, child) => Scaffold(
        body: Center(
          child: ElevatedButton(
            onPressed: model.uploadFile,
            child: const Text('Datei hochladen')
          )
        )
      ),
    );
  }
}