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
        body: Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/pronto_logo.png',
                fit: BoxFit.contain,
              ),

              const SizedBox(height: 32.0),
              TextField(
                controller: userNameController,
                decoration: const InputDecoration(
                  labelText: 'Benutzername',
                  hintText: 'Geben Sie hier Ihren Benutzernamen ein.',
                ),
              ),

              const SizedBox(height: 8.0),
              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Passwort',
                  hintText: 'Geben Sie hier Ihr Passwort ein.',
                ),
              ),

              const SizedBox(height: 16.0),
              SizedBox(
                width: double.infinity,
                height: 40.0,
                child: ElevatedButton(
                  onPressed: model.submitForm,
                  child: model.isBusy
                    ? const SizedBox(
                        width: 16.0,
                        height: 16.0,
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation(Colors.white),
                          backgroundColor: Colors.blue,
                          strokeWidth: 3,
                        ),
                    )
                    : const Text('Anmelden'),
                ),
              ),

              if (model.validationMessage != null)
                Text(
                  model.validationMessage,
                  style: const TextStyle(color: Colors.red),
                )
            ],
          ),
        ),
      ),
    );
  }
}
