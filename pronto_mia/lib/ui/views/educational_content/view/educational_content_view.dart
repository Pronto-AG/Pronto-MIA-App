import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:pronto_mia/core/models/educational_content.dart';
import 'package:pronto_mia/ui/views/educational_content/view/educational_content_viewmodel.dart';
import 'package:stacked/stacked.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:video_player/video_player.dart';

/// A widget, representing the news.
class EducationalContentView extends StatefulWidget {
  final bool adminModeEnabled;
  final EducationalContent educationalContent;

  /// Initializes a new instance of [EducationalContentView].
  ///
  /// Takes a [Key] to uniquely identify the widget in the widget tree and a
  /// [bool] wether to show admin level functionality as an input.
  const EducationalContentView({
    Key key,
    this.educationalContent,
    this.adminModeEnabled = false,
  }) : super(key: key);

  @override
  _EducationalContentViewState createState() => _EducationalContentViewState();
}

class _EducationalContentViewState extends State<EducationalContentView> {
  VideoPlayerController _controller;
  ChewieController chewieController;
  Future<void> _initializeVideoPlayerFuture;
  final _scrollController = ScrollController();

  @override
  void initState() {
    _controller = VideoPlayerController.network(
      widget.educationalContent.link,
    );

    _initializeVideoPlayerFuture = _controller.initialize();

    chewieController = ChewieController(
      videoPlayerController: _controller,
    );

    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    chewieController.dispose();

    super.dispose();
  }

  /// Binds [EducationalContentView] and builds the widget.
  ///
  /// Takes the current [BuildContext] as an input.
  /// Returns the built [Widget].
  @override
  Widget build(BuildContext context) =>
      ViewModelBuilder<EducationalContentViewModel>.reactive(
        viewModelBuilder: () => EducationalContentViewModel(
          educationalContent: widget.educationalContent,
        ),
        builder: (context, model, child) {
          return _buildDataView(model);
        },
      );

  Widget _buildDataView(
    EducationalContentViewModel model,
  ) =>
      Scaffold(
        appBar: AppBar(title: _buildTitle()),
        body: _buildForm(model),
      );

  Widget _buildTitle() {
    if (widget.educationalContent != null) {
      return Container(
        padding: const EdgeInsets.all(16.0),
        child: Text(
          widget.educationalContent.title,
          style: const TextStyle(fontSize: 20.0),
        ),
      );
    } else {
      return Text(widget.educationalContent.title);
    }
  }

  Widget _buildForm(
    EducationalContentViewModel model,
  ) =>
      Column(
        children: [
          Expanded(
            flex: 5,
            child: FutureBuilder(
              future: _initializeVideoPlayerFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return Chewie(
                    controller: chewieController,
                  );
                } else {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
              },
            ),
          ),
          Expanded(
            flex: 4,
            child: SingleChildScrollView(
              controller: _scrollController,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Html(
                  data: widget.educationalContent.description,
                  onLinkTap: (url, context, attributes, element) => launch(url),
                ),
              ),
            ),
          ),
        ],
      );
}
