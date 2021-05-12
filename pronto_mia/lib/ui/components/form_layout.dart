import 'package:flutter/material.dart';

import 'package:pronto_mia/ui/shared/custom_colors.dart';
import 'package:pronto_mia/ui/components/destructive_button/destructive_button.dart';

class FormLayout extends StatelessWidget {
  final List<Widget> textFields;
  final String validationMessage;
  final ButtonSpecification primaryButton;
  final ButtonSpecification secondaryButton;

  const FormLayout({
    @required this.textFields,
    @required this.validationMessage,
    @required this.primaryButton,
    this.secondaryButton,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: ListView(
        shrinkWrap: true,
        children: _buildForm(),
      ),
    );
  }

  List<Widget> _buildForm() {
    final List<Widget> form = [const SizedBox(height: 2.0)];

    for (final textField in textFields) {
      form.add(textField);
      if (textField != textFields.last) {
        form.add(const SizedBox(height: 16.0));
      }
    }

    form.add(const SizedBox(height: 16.0));
    form.add(_buildButton(button: primaryButton));

    if (secondaryButton != null) {
      form.add(const SizedBox(height: 8.0));
      form.add(_buildButton(button: secondaryButton));
    }

    if (validationMessage != null) {
      form.add(const SizedBox(height: 8.0));
      form.add(Text(
        validationMessage,
        style: const TextStyle(color: CustomColors.danger),
      ));
    }

    return form;
  }

  Widget _buildButton({@required ButtonSpecification button}) {
    return SizedBox(
      width: double.infinity,
      height: 48.0,
      child: !button.isDestructive
          ? ElevatedButton(
            onPressed: button.onTap,
            child: _buildButtonChild(button: button),
          )
          : DestructiveButton(
            onPressed: button.onTap,
            child: _buildButtonChild(button: button),
          ),
    );
  }

  Widget _buildButtonChild({@required ButtonSpecification button}) {
    if (button.isBusy) {
      return const SizedBox(
        width: 16.0,
        height: 16.0,
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation(CustomColors.negativeText),
          strokeWidth: 3,
        ),
      );
    }

    return Text(button.title);
  }
}

class ButtonSpecification {
  final String title;
  final void Function() onTap;
  final bool isBusy;
  final bool isDestructive;

  ButtonSpecification({
    @required this.title,
    @required this.onTap,
    @required this.isBusy,
    this.isDestructive = false,
  });
}
