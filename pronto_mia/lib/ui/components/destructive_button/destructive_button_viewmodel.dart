import 'package:pronto_mia/ui/components/destructive_button/destructive_button.dart';
import 'package:stacked/stacked.dart';

/// a view model, providing functionality for [DestructiveButton].
class DestructiveButtonViewModel extends BaseViewModel {
  bool get hasClickedOnce => _hasClickedOnce;
  bool _hasClickedOnce = false;

  /// Sets that the button was clicked already, on the first click.
  void clickOnce() {
    _hasClickedOnce = true;
    notifyListeners();
  }
}
