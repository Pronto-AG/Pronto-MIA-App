import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:pronto_mia/core/models/internal_news.dart';
import 'package:pronto_mia/ui/views/internal_news/view/internal_news_viewmodel.dart';
import 'package:stacked/stacked.dart';
import 'package:url_launcher/url_launcher.dart';

/// A widget, representing the news.
class InternalNewsView extends StatefulWidget {
  final bool adminModeEnabled;
  final InternalNews internalNews;

  /// Initializes a new instance of [InternalNewsView].
  ///
  /// Takes a [Key] to uniquely identify the widget in the widget tree and a
  /// [bool] wether to show admin level functionality as an input.
  const InternalNewsView({
    Key key,
    this.internalNews,
    this.adminModeEnabled = false,
  }) : super(key: key);

  @override
  InternalNewsViewState createState() => InternalNewsViewState();
}

class InternalNewsViewState extends State<InternalNewsView> {
  final _scrollController = ScrollController();

  /// Binds [InternalNewsView] and builds the widget.
  ///
  /// Takes the current [BuildContext] as an input.
  /// Returns the built [Widget].
  @override
  Widget build(BuildContext context) =>
      ViewModelBuilder<InternalNewsViewModel>.reactive(
        viewModelBuilder: () =>
            InternalNewsViewModel(internalNews: widget.internalNews),
        builder: (context, model, child) {
          return _buildDataView(model);
        },
      );

  Widget _buildDataView(
    InternalNewsViewModel model,
  ) =>
      Scaffold(
        appBar: AppBar(title: _buildTitle()),
        body: _buildForm(model),
      );

  Widget _buildTitle() {
    if (widget.internalNews != null) {
      return Container(
        padding: const EdgeInsets.all(16.0),
        child: Text(
          widget.internalNews.title,
          style: const TextStyle(fontSize: 20.0),
        ),
      );
    } else {
      return Text(widget.internalNews.title);
    }
  }

  Widget _buildForm(
    InternalNewsViewModel model,
  ) =>
      Column(
        children: [
          Expanded(
            flex: 5,
            child: FutureBuilder(
              future: model.getInternalNewsImage(widget.internalNews),
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
                model.getInternalNewsDate(widget.internalNews),
                style: const TextStyle(fontStyle: FontStyle.italic),
              ),
            ),
          ),
          Expanded(
            flex: 4,
            child: SingleChildScrollView(
              controller: _scrollController,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16.0, 0, 16.0, 16.0),
                child: Html(
                  data: widget.internalNews.description,
                  onLinkTap: (url, context, attributes, element) => launch(url),
                ),
              ),
            ),
          ),
        ],
      );
}
