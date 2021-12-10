import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:pronto_mia/core/models/external_news.dart';
import 'package:pronto_mia/ui/views/external_news/view/external_news_viewmodel.dart';
import 'package:stacked/stacked.dart';
import 'package:url_launcher/url_launcher.dart';

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
          Expanded(
            flex: 5,
            child: FutureBuilder(
              future: model.getExternalNewsImage(externalNews),
              builder: (BuildContext context, AsyncSnapshot<Image> image) {
                if (image.hasData) {
                  return image.data;
                } else {
                  return const SizedBox.shrink();
                }
              },
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                model.getExternalNewsDate(externalNews),
                style: const TextStyle(fontStyle: FontStyle.italic),
              ),
            ),
          ),
          Expanded(
            flex: 4,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16.0, 0, 16.0, 16.0),
              // child: Text(externalNews.description),
              child: Html(
                data: externalNews.description,
                onLinkTap: (url, context, attributes, element) => launch(url),
              ),
            ),
          ),
        ],
      );
}
