import 'package:pronto_mia/app/service_locator.dart';
import 'package:pronto_mia/core/models/educational_content.dart';
import 'package:pronto_mia/core/services/educational_content_service.dart';
import 'package:pronto_mia/core/services/error_service.dart';
import 'package:stacked/stacked.dart';

/// A view model, providing functionality for [EducationalContentView].
class EducationalContentViewModel extends FutureViewModel<EducationalContent> {
  static String contextIdentifier = "EducationalContentViewModel";
  EducationalContent educationalContent;

  EducationalContentService get _educationalContentService =>
      locator.get<EducationalContentService>();
  ErrorService get _errorService => locator.get<ErrorService>();

  final bool adminModeEnabled;
  String get errorMessage => _errorMessage;
  String _errorMessage;

  /// Initializes a new instance of [EducationalContentViewModel].
  ///
  /// Takes a [bool] wether to execute admin level functionality as an input.
  EducationalContentViewModel(
      {this.educationalContent, this.adminModeEnabled = false}) {
    _educationalContentService.addListener(_notifyDataChanged);
  }

  /// Gets educational content and stores them into [data].
  ///
  /// Returns the fetched [List] of educational content.
  @override
  Future<EducationalContent> futureToRun() async {
    return _getEducationalContentById(educationalContent.id);
  }

  /// Handles incoming error and sets [errorMessage] accordingly.
  ///
  /// Takes the thrown dynamic error object as an input.
  @override
  Future<void> onError(dynamic error) async {
    super.onError(error);
    await _errorService.handleError(
      EducationalContentViewModel.contextIdentifier,
      error,
    );
    _errorMessage = _errorService.getErrorMessage(error);
    notifyListeners();
  }

  // Future<Video> getEducationalContentImage(
  //     EducationalContent educationalContent) async {
  //   return _educationalContentService
  //       .getEducationalContentVideo(educationalContent);
  // }

  /// Generates a title for an educational content
  ///
  /// Takes the [EducationalContent] to generate the title for as an input.
  /// Returns the generated [String] title.
  String getEducationalContentTitle(EducationalContent educationalContent) {
    return _educationalContentService
        .getEducationalContentTitle(educationalContent);
  }

  Future<EducationalContent> _getEducationalContentById(int id) async {
    return _educationalContentService.getEducationalContentById(id);
  }

  /// Refetches the [List] of deployment plans.
  void _notifyDataChanged() {
    initialise();
  }

  /// Removes the listener on [EducationalContentService].
  @override
  void dispose() {
    _educationalContentService.removeListener(_notifyDataChanged);
    super.dispose();
  }

  void openEducationalContent(EducationalContent educationalContent) {}
}
