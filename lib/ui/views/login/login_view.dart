import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked/stacked_annotations.dart';

import 'login_view.form.dart';
import 'login_viewmodel.dart';

@FormView(fields: [
  FormTextField(name: 'username'),
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
        body: Scaffold(
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(32.0),
                child: Center(
                  child: Image.asset('assets/images/pronto_logo.png',
                      width: MediaQuery.of(context).size.width * 0.6),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: 16.0,
                    top: 16.0,
                    right: 16.0
                ),
                child: TextField(
                  controller: usernameController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Benutzername',
                    hintText: 'Geben Sie hier Ihren Benutzernamen ein.',
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: 16.0,
                    top: 16.0,
                    right: 16.0
                ),
                child: TextField(
                  controller: passwordController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Passwort',
                    hintText: 'Geben Sie hier Ihr Passwort ein.',
                  ),
                ),
              ),
              if (model.validationMessage != null)
                Padding(
                  padding:
                  const EdgeInsets.only(left: 16.0, top: 8.0, right: 16.0),
                  child: Center(
                    child: Text(model.validationMessage,
                      style: const TextStyle(color: Colors.red)
                    ),
                  ),
                ),
              Padding(
                padding: const EdgeInsets.only(
                    left: 16.0,
                    top: 8.0,
                    right: 16.0
                ),
                child: ElevatedButton(
                  onPressed: model.login,
                  child: const Text('Anmelden'),
                )
              ),
            ],
          ),
        ),
      ),
    );
  }
}
