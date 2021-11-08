import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pronto_mia/core/models/external_news.dart';
import 'package:pronto_mia/ui/components/data_view_layout.dart';
import 'package:pronto_mia/ui/components/navigation_layout.dart';
import 'package:pronto_mia/ui/shared/custom_colors.dart';
import 'package:pronto_mia/ui/views/external_news/view/external_news_viewmodel.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:stacked/stacked.dart';

/// A widget, representing the news.
class ExternalNewsView extends StatelessWidget {
  final bool adminModeEnabled;
  final ExternalNews externalNews;

  /// Initializes a new instance of [ExternalNewsView].
  ///
  /// Takes a [Key] to uniquely identify the widget in the widget tree and a
  /// [bool] wether to show admin level functionality as an input.
  const ExternalNewsView({
    Key key,
    this.externalNews,
    this.adminModeEnabled = false,
  }) : super(key: key);

  /// Binds [ExternalNewsView] and builds the widget.
  ///
  /// Takes the current [BuildContext] as an input.
  /// Returns the built [Widget].
  @override
  Widget build(BuildContext context) =>
      ViewModelBuilder<ExternalNewsViewModel>.reactive(
        viewModelBuilder: () =>
            ExternalNewsViewModel(externalNews: externalNews),
        builder: (context, model, child) {
          return _buildDataView(model);
        },
      );

  Widget _buildDataView(
    ExternalNewsViewModel model,
  ) =>
      Scaffold(
        appBar: AppBar(title: _buildTitle()),
        body: _buildForm(model),
      );

  Widget _buildTitle() {
    if (externalNews != null) {
      return Container(
        padding: const EdgeInsets.all(16.0),
        child: Text(
          externalNews.title,
          style: const TextStyle(fontSize: 20.0),
        ),
      );
    } else {
      return Text(externalNews.title);
    }
  }

  Widget _buildForm(
    ExternalNewsViewModel model,
  ) =>
      Column(
        children: [
          Row(
            children: [
              Expanded(
                child: FutureBuilder(
                  future: model.getExternalNewsImage(externalNews),
                  builder: (BuildContext context, AsyncSnapshot<Image> image) {
                    if (image.hasData) {
                      return image.data; // image is ready
                    } else {
                      return Image.asset(
                        'assets/images/pronto_icon.png',
                      ); // placeholder
                    }
                  },
                ),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(child: Text(externalNews.description)),
            ],
          ),
        ],
      );
}
