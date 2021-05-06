import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked/stacked_annotations.dart';

import 'package:pronto_mia/ui/views/login/login_view.form.dart';
import 'package:pronto_mia/ui/views/login/login_viewmodel.dart';
import 'package:pronto_mia/ui/components/form_layout.dart';

@FormView(fields: [
  FormTextField(name: 'userName'),
  FormTextField(name: 'password'),
])
class LoginView extends StatelessWidget with $LoginView {
  LoginView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<LoginViewModel>.reactive(
      viewModelBuilder: () => LoginViewModel(),
      onModelReady: (model) => listenToFormUpdated(model),
      builder: (context, model, child) => Scaffold(
        body: Center(
          child: SingleChildScrollView(
            child: ScreenTypeLayout(
              mobile: _buildBaseLayout(model),
              tablet: _buildCardLayout(model, width: 584.0, padding: 8.0),
              desktop: _buildCardLayout(model, width: 500.0, padding: 16.0),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBaseLayout(LoginViewModel model) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildLogo(),
        Container(
          padding: const EdgeInsets.only(left: 16.0, right: 16.0),
          child: const Divider(),
        ),
        _buildForm(model),
      ],
    );
  }

  Widget _buildCardLayout(
    LoginViewModel model,
    {
      @required double width,
      @required double padding,
    }
  ) {
    return Container(
      width: width,
      padding: EdgeInsets.all(padding),
      child: Card(
        child: _buildBaseLayout(model),
      ),
    );
  }

  Widget _buildLogo() {
    return Container(
      height: 120.0,
      padding: const EdgeInsets.all(16.0),
      child: Image.asset(
        'assets/images/pronto_logo.png',
      ),
    );
  }
  
  Widget _buildForm(LoginViewModel model) {
    return FormLayout(
      textFields: [
        TextField(
          controller: userNameController,
          decoration: const InputDecoration(
            labelText: 'Benutzername *',
          ),
        ),
        TextField(
          controller: passwordController,
          obscureText: true,
          decoration: const InputDecoration(
            labelText: 'Passwort *',
          ),
        ),
      ],
      primaryButton: ButtonSpecification(
        title: 'Anmelden',
        onTap: model.submitForm,
        isBusy: model.isBusy,
      ),
      validationMessage: model.validationMessage,
    );
  }
}
