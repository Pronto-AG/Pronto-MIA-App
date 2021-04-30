import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
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
        body: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16.0),
              child: Image.asset(
                'assets/images/pronto_logo.png',
                height: 200,
              ),
            ),
            FormLayout(
              textFields: [
                TextField(
                  controller: userNameController,
                  decoration: const InputDecoration(
                    labelText: 'Benutzername*',
                    hintText: 'Geben Sie hier Ihren Benutzernamen ein.',
                  ),
                ),
                TextField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'Passwort*',
                    hintText: 'Geben Sie hier Ihr Passwort ein.',
                  ),
                ),
              ],
              primaryButton: ButtonSpecification(
                title: 'Anmelden',
                onTap: model.submitForm,
                isBusy: model.isBusy,
              ),
              validationMessage: model.validationMessage,
            ),
          ],
        ),
      ),
    );
  }
}
