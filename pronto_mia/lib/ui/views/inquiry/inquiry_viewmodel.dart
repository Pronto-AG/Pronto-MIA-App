import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'package:pronto_mia/app/service_locator.dart';
import 'package:pronto_mia/core/services/error_service.dart';
import 'package:stacked/stacked.dart';

/// A view model, providing functionality for [InquiryView].
class InquiryViewModel extends FormViewModel {
  static String contextIdentifier = "InquiryViewModel";

  ErrorService get _errorService => locator.get<ErrorService>();

  String get errorMessage => _errorMessage;
  String _errorMessage;

  /// Initializes a new instance of [InquiryViewModel].
  InquiryViewModel();

  //String _validateForm() {
  //  if (titleValue == null || titleValue.isEmpty) {
  //    return 'Bitte Titel eingeben.';
  //  }
//
  //  return null;
  //}

  /// Validates the form and either creates or updates a [ExternalNews].
  ///
  /// After the form has been submitted successfully, it closes the dialog in
  /// case it was opened as a dialog or navigates to the previous view if
  /// opened as standalone.
  Future<void> submitForm() async {
    String sendActionKey;
    //final validationMessage = _validateForm();
    //if (validationMessage != null) {
    //  setValidationMessage(validationMessage);
    //  notifyListeners();
    //  return;
    //}

    try {
      await sendEmail();
    } on MailerException catch (e) {
      sendActionKey = e.problems.first.code;
    }

    _completeFormAction(sendActionKey);
  }

  Future<void> _completeFormAction(String actionKey) async {
    if (hasErrorForKey(actionKey)) {
      await _errorService.handleError(
        InquiryViewModel.contextIdentifier,
        error(actionKey),
      );
      final errorMessage = _errorService.getErrorMessage(error(actionKey));
      setValidationMessage(errorMessage);
      notifyListeners();
    }
  }

  Future<void> sendEmail() async {
    const String recipient = 'app@pronto-ag.ch';
    final smtpServer = SmtpServer(
      'smtp.pronto-ag.ch',
      username: 'app@pronto-ag.ch',
      password: '!Kilimandscharo1889',
      port: 465,
      ssl: true,
      ignoreBadCertificate: true,
    );

    final message = Message()
      ..from = const Address('noreply@pronto-ag.ch', 'Kontaktanfrage App')
      ..recipients.add(recipient)
      ..subject = 'Test Email'
      ..text = 'Test';

    try {
      final sendReport = await send(message, smtpServer);
      print('Message sent: $sendReport');
    } on MailerException catch (e) {
      print('Message not sent.');
      for (var p in e.problems) {
        print('Problem: ${p.code}: ${p.msg}');
      }
    }
  }

  /// Resets errors and messages, as soon as form fields update.
  @override
  void setFormStatus() {
    clearErrors();
  }
}
