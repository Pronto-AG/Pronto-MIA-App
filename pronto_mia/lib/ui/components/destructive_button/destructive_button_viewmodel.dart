import 'package:stacked/stacked.dart';

/// A view model, providing functionality for [DestructiveButton].
class DestructiveButtonViewModel extends BaseViewModel {
  bool get hasClickedOnce => _hasClickedOnce;
  bool _hasClickedOnce = false;

  /// Sets that the button was clicked already. Called on the first click.
  void clickOnce() {
    _hasClickedOnce = true;
    notifyListeners();
  }
}
