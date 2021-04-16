import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked/stacked_annotations.dart';

import 'package:pronto_mia/ui/views/login/login_view.form.dart';
import 'package:pronto_mia/ui/views/login/login_viewmodel.dart';

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
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
                padding: const EdgeInsets.all(32.0),
                child: Image.asset(
                  'assets/images/pronto_logo.png',
                  width: 300,
                )
            ),

            Padding(
              padding:
              const EdgeInsets.only(left: 16.0, top: 16.0, right: 16.0),
              child: TextField(
                controller: userNameController,
                decoration: const InputDecoration(
                  labelText: 'Benutzername',
                ),
              ),
            ),

            Padding(
              padding:
              const EdgeInsets.only(left: 16.0, top: 8.0, right: 16.0),
              child: TextField(
                controller: passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Passwort',
                ),
              ),
            ),

            Padding(
              padding:
              const EdgeInsets.only(left: 16.0, top: 32.0, right: 16.0),
              child: SizedBox(
                width: double.infinity,
                height: 40.0,
                child: ElevatedButton(
                  onPressed: model.login,
                  child: const Text('Anmelden'),
                ),
              ),
            ),

            if (model.validationMessage != null)
              Padding(
                padding:
                const EdgeInsets.only(left: 16.0, top: 8.0, right: 16.0),
                child: Text(model.validationMessage,
                  style: const TextStyle(color: Colors.red),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
