import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'package:pronto_mia/app/service_locator.dart';
import 'package:pronto_mia/core/services/error_service.dart';
import 'package:pronto_mia/core/services/inquiry_service.dart';
import 'package:pronto_mia/ui/views/inquiry/inquiry_view.dart';
import 'package:pronto_mia/ui/views/inquiry/inquiry_view.form.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

/// A view model, providing functionality for [InquiryView].
class InquiryViewModel extends FormViewModel {
  static String contextIdentifier = "InquiryViewModel";

  InquiryService get _inquiryService => locator.get<InquiryService>();
  NavigationService get _navigationService => locator.get<NavigationService>();
  ErrorService get _errorService => locator.get<ErrorService>();

  String get errorMessage => _errorMessage;
  String _errorMessage;

  String _title = "";
  String _newsletterSubscription = "";
  String _contactVia = "";
  final List<String> _services = [];

  /// Resets errors and messages, as soon as form fields update.
  @override
  void setFormStatus() {
    clearErrors();
  }

  /// Validates the form and either creates or updates a [Inquiry].
  ///
  /// After the form has been submitted successfully, it closes the dialog in
  /// case it was opened as a dialog or navigates to the previous view if
  /// opened as standalone.
  Future<void> submitForm() async {
    String sendActionKey;
    final validationMessage = validateForm();
    if (validationMessage != null) {
      setValidationMessage(validationMessage);
      notifyListeners();
      return;
    }

    try {
      await sendEmail();
    } on MailerException catch (e) {
      sendActionKey = e.problems.first.code;
    }

    _completeFormAction(sendActionKey);
  }

  String validateForm() {
    final mailRegex = RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
    );
    final phoneRegex = RegExp(r"^[+]?[0-9]*$");

    final plzRegex = RegExp(r"^[0-9]*$");

    if (firstNamneValue == null || firstNamneValue.isEmpty) {
      return 'Bitte Vornamen angeben';
    }

    if (lastnameValue == null || lastnameValue.isEmpty) {
      return 'Bitte Nachnamen angeben';
    }

    if (streetValue == null || streetValue.isEmpty) {
      return 'Bitte Strasse angeben';
    }

    if (plzValue == null || plzValue.isEmpty) {
      return 'Bitte Postleitzahl angeben';
    }

    if (!plzRegex.hasMatch(plzValue)) {
      return 'Postleitzahl nicht korrekt';
    }

    if (locationValue == null || locationValue.isEmpty) {
      return 'Bitte Ort angeben';
    }

    if (phoneValue == null || phoneValue.isEmpty) {
      return 'Bitte Telefonnummer angeben';
    }

    if (!phoneRegex.hasMatch(phoneValue)) {
      return 'Telefonnummer nicht korrekt';
    }

    if (mailValue == null || mailValue.isEmpty) {
      return 'Bitte E-Mail angeben';
    }

    if (!mailRegex.hasMatch(mailValue)) {
      return 'E-Mail Adresse nicht korrekt';
    }

    return null;
  }

  void setTitle(String title) {
    _title = title;
    notifyListeners();
  }

  void setSubscription({String subscription = ""}) {
    _newsletterSubscription = subscription;
    notifyListeners();
  }

  void setService(String service) {
    if (_services.contains(service)) {
      _services.remove(service);
    } else {
      _services.add(service);
    }
    notifyListeners();
  }

  void setContactVia({String contactVia = ""}) {
    _contactVia = contactVia;
    notifyListeners();
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

  Future<SmtpServer> createSmtpServer() async =>
      _inquiryService.createSmtpServer();

  Future<String> getRecipient() async => _inquiryService.getRecipient();

  Message generateMessage(String recipient) {
    return Message()
      ..from = const Address('noreply@pronto-ag.ch', 'Kontaktanfrage App')
      ..recipients.add(recipient)
      ..subject = 'Anfrage von $firstNamneValue $lastnameValue'
      ..html =
          '<table><tr><td>Name</td><td>$_title $firstNamneValue $lastnameValue</td></tr><tr><td>Firma</td><td>$companyValue</td></tr><tr><td>Adresse</td><td>$streetValue</td></tr><tr><td>Ort</td><td>$plzValue $locationValue</td></tr><tr><td>Telefonnummer</td><td>$phoneValue</td></tr><tr><td>Mobiltelefon</td><td>$mobileValue</td></tr></td></tr><tr><td>Newsletter erwünscht</td><td>$_newsletterSubscription</td></tr></td></tr><tr><td>Dienstleistungen</td><td>${_services.join(", ")}</td></tr></tr><tr><td>Zusätzliches Interesse an</td><td>$additionalInterestsValue</td></tr><tr><td>Kontaktieren via</td><td>$_contactVia</td></tr><tr><td>Bemerkungen</td><td>$remarksValue</td></tr></table>';
  }

  Future<SendReport> sendMailToSmtpServer(
    Message message,
    SmtpServer smtpServer,
  ) async =>
      _inquiryService.sendMailToSmtpServer(message, smtpServer);

  Future<void> sendEmail() async {
    final smtpServer = await createSmtpServer();
    final message = generateMessage(await getRecipient());
    try {
      await sendMailToSmtpServer(message, smtpServer);
    } finally {
      _navigationService.replaceWithTransition(
        InquiryView(),
        transition: NavigationTransition.UpToDown,
      );
    }
  }
}
