import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:jdenticon_dart/jdenticon_dart.dart';
import 'package:pronto_mia/ui/components/form_layout.dart';
import 'package:pronto_mia/ui/views/settings/overview/settings_overview_viewmodel.dart';
import 'package:pronto_mia/ui/views/settings/view/settings_view.form.dart';
import 'package:pronto_mia/ui/views/settings/view/settings_viewmodel.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:stacked/stacked.dart';

/// A widget, representing the settings view with options to logout and change
/// the users password.
class SettingsOverviewView extends StatelessWidget with $SettingsView {
  final _formKey = GlobalKey<FormState>();
  final bool isDialog;

  /// Initializes a new instance of [DeploymentPlanEditView].
  ///
  /// Takes a [Key] to uniquely identify the widget in the widget tree and a
  /// [bool] wether to open it as a dialog or standalone as an input.
  SettingsOverviewView({Key key, this.isDialog = false}) : super(key: key);

  /// Binds [SettingsViewModel] and builds the widget.
  ///
  /// Takes the current [BuildContext] as an input.
  /// Returns the built [Widget].
  @override
  Widget build(BuildContext context) =>
      ViewModelBuilder<SettingsOverviewViewModel>.reactive(
        viewModelBuilder: () => SettingsOverviewViewModel(
          isDialog: isDialog,
        ),
        // onModelReady: (model) => listenToFormUpdated(model),
        builder: (context, model, child) {
          if (isDialog) {
            return _buildDialogLayout(context, model);
          } else {
            return _buildStandaloneLayout(context, model);
          }
        },
      );

  Widget _buildStandaloneLayout(
    BuildContext context,
    SettingsOverviewViewModel model,
  ) =>
      Scaffold(
        appBar: AppBar(title: _buildTitle()),
        body: _buildForm(context, model),
      );

  // ignore: sized_box_for_whitespace
  Widget _buildDialogLayout(
    BuildContext context,
    SettingsOverviewViewModel model,
  ) =>
      SizedBox(
        width: 500.0,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildTitle(),
            _buildForm(context, model),
          ],
        ),
      );

  Widget _buildTitle() {
    const title = 'Benutzerprofil';

    if (isDialog) {
      return Container(
        padding: const EdgeInsets.all(16.0),
        child: const Text(
          title,
          style: TextStyle(fontSize: 20.0),
        ),
      );
    } else {
      return const Text(title);
    }
  }

  List<String> _getUserInformation(SettingsOverviewViewModel model) {
    final List<String> userInformation = <String>[];
    userInformation
        .add(model.data != null ? model.data.userName : 'Hans Mustermann');
    userInformation
        .add(model.data != null ? model.data.profile.description : 'Benutzer');
    return userInformation;
  }

  Widget _buildForm(BuildContext context, SettingsOverviewViewModel model) =>
      Form(
        key: _formKey,
        child: FormLayout(
          textFields: [
            ListTile(
              contentPadding: const EdgeInsets.only(left: 8.0),
              leading: SvgPicture.string(
                Jdenticon.toSvg(_getUserInformation(model).first),
                height: 48,
                width: 48,
              ),
              title: Text(_getUserInformation(model).first),
              subtitle: Text('${_getUserInformation(model).last} - Pronto AG'),
            ),
            const Divider(
              color: Colors.black,
            )
          ],
          primaryButton: ButtonSpecification(
            title: 'Passwort ändern',
            onTap: () => model.openSettings(
              asDialog: getValueForScreenType<bool>(
                context: context,
                mobile: false,
                desktop: true,
              ),
            ),
            isBusy: model.busy(SettingsOverviewViewModel.logoutActionKey),
          ),
          secondaryButton: ButtonSpecification(
            title: 'Abmelden',
            onTap: model.logout,
            isBusy: model.busy(SettingsOverviewViewModel.logoutActionKey),
          ),
        ),
      );
}
