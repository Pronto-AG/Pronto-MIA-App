import 'package:stacked/stacked.dart';

class DestructiveButtonViewModel extends BaseViewModel {
  bool get hasClickedOnce => _hasClickedOnce;
  bool _hasClickedOnce = false;

  void clickOnce() {
    _hasClickedOnce = true;
    notifyListeners();
  }
}
