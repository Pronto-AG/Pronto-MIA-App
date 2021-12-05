import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'package:pronto_mia/app/service_locator.dart';
import 'package:pronto_mia/core/services/configuration_service.dart';

class InquiryService {
  Future<ConfigurationService> get _configurationService =>
      locator.getAsync<ConfigurationService>();

  String _smtpRecipient;

  Future<SmtpServer> createSmtpServer() async {
    final _smtpServer =
        (await _configurationService).getValue<String>('smtpServer');
    final _smtpPassword =
        (await _configurationService).getValue<String>('password');
    final _smtpPort = (await _configurationService).getValue<int>('port');
    _smtpRecipient = (await _configurationService).getValue<String>('username');

    return SmtpServer(
      _smtpServer,
      username: _smtpRecipient,
      password: _smtpPassword,
      port: _smtpPort,
      ssl: true,
      ignoreBadCertificate: true,
    );
  }

  Future<String> getRecipient() => Future(() => _smtpRecipient);

  Future<SendReport> sendMailToSmtpServer(
    Message message,
    SmtpServer smtpServer,
  ) async =>
      send(message, smtpServer);
}
