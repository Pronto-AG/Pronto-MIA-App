import 'package:pronto_mia/app/service_locator.dart';
import 'package:pronto_mia/core/models/appointment.dart';
import 'package:pronto_mia/core/services/appointment_service.dart';
import 'package:pronto_mia/core/services/error_service.dart';
import 'package:pronto_mia/ui/shared/custom_dialogs.dart';
import 'package:pronto_mia/ui/views/appointment/edit/appointment_edit_view.dart';
import 'package:pronto_mia/ui/views/appointment/view/appointment_view.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

/// A view model, providing functionality for [AppointmentView].
class AppointmentViewModel extends FutureViewModel<List<Appointment>> {
  static String contextIdentifier = "AppointmentViewModel";
  Appointment appointment;

  AppointmentService get _appointmentService =>
      locator.get<AppointmentService>();
  DialogService get _dialogService => locator.get<DialogService>();
  NavigationService get _navigationService => locator.get<NavigationService>();
  ErrorService get _errorService => locator.get<ErrorService>();

  final bool adminModeEnabled;
  String get errorMessage => _errorMessage;
  String _errorMessage;

  /// Initializes a new instance of [AppointmentViewModel].
  ///
  /// Takes a [bool] wether to execute admin level functionality as an input.
  AppointmentViewModel({this.appointment, this.adminModeEnabled = false}) {
    _appointmentService.addListener(_notifyDataChanged);
  }

  /// Gets appointments and stores them into [data].
  ///
  /// Returns the fetched [List] of news.
  @override
  Future<List<Appointment>> futureToRun() async {
    return _getAppointments();
  }

  /// Handles incoming error and sets [errorMessage] accordingly.
  ///
  /// Takes the thrown dynamic error object as an input.
  @override
  Future<void> onError(dynamic error) async {
    super.onError(error);
    await _errorService.handleError(
      AppointmentViewModel.contextIdentifier,
      error,
    );
    _errorMessage = _errorService.getErrorMessage(error);
    notifyListeners();
  }

  Future<List<Appointment>> _getAppointments() async {
    return _appointmentService.getAppointments();
  }

  /// Opens the form to create or update an appointment.
  ///
  /// Takes the [Appointment] to edit and a [bool] as an input wether the
  /// view should open as a dialog or standalone as an input.
  /// If the navigation or dialog resolve to data being changed, refetches
  /// the [List] of appointments.
  Future<void> editAppointment({
    Appointment appointment,
    bool asDialog = false,
  }) async {
    bool dataHasChanged;
    if (asDialog) {
      final dialogResponse = await _dialogService.showCustomDialog(
        variant: DialogType.custom,
        // ignore: deprecated_member_use
        customData: AppointmentEditView(
          appointment: appointment,
          isDialog: true,
        ),
      );
      dataHasChanged = dialogResponse?.confirmed ?? false;
    } else {
      final navigationResponse =
          await _navigationService.navigateWithTransition(
        AppointmentEditView(appointment: appointment),
        transition: NavigationTransition.LeftToRight,
      );
      dataHasChanged = navigationResponse is bool && navigationResponse == true;
    }

    if (dataHasChanged) {
      await initialise();
    }
  }

  /// Refetches the [List] of appointments.
  void _notifyDataChanged() {
    initialise();
  }

  /// Removes the listener on [AppointmentService].
  @override
  void dispose() {
    _appointmentService.removeListener(_notifyDataChanged);
    super.dispose();
  }
}
