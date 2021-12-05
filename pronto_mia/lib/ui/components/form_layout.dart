import 'package:flutter/material.dart';
import 'package:pronto_mia/ui/components/destructive_button/destructive_button.dart';
import 'package:pronto_mia/ui/shared/custom_colors.dart';

/// A widget, representing the layout for a form.
class FormLayout extends StatelessWidget {
  final List<Widget> textFields;
  final String validationMessage;
  final ButtonSpecification primaryButton;
  final ButtonSpecification secondaryButton;
  final ButtonSpecification cancelButton;

  /// Initializes a new instance of [FormLayout].
  ///
  /// Takes a [List] of text fields to add into the form, a [String] validation
  /// message to show form errors, a [ButtonSpecification] primary form action
  /// and a [ButtonSpecification] secondary form action as an input.
  const FormLayout({
    @required this.textFields,
    this.validationMessage,
    @required this.primaryButton,
    this.secondaryButton,
    this.cancelButton,
  });

  /// Builds the widget.
  ///
  /// Takes the current [BuildContext] as an input.
  /// Returns the built [Widget].
  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          shrinkWrap: true,
          children: _buildForm(),
        ),
      );

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

    if (cancelButton != null) {
      form.add(const SizedBox(height: 8.0));
      form.add(
        _buildButton(
          button: cancelButton,
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(Colors.grey),
          ),
        ),
      );
    }

    if (validationMessage != null) {
      form.add(const SizedBox(height: 8.0));
      form.add(
        Text(
          validationMessage,
          style: const TextStyle(color: CustomColors.danger),
        ),
      );
    }

    return form;
  }

  Widget _buildButton({
    @required ButtonSpecification button,
    ButtonStyle style,
  }) =>
      SizedBox(
        width: double.infinity,
        height: 48.0,
        child: !button.isDestructive
            ? ElevatedButton(
                onPressed: button.onTap,
                style: style ?? style,
                child: _buildButtonChild(button: button),
              )
            : DestructiveButton(
                onPressed: button.onTap,
                child: _buildButtonChild(button: button),
              ),
      );

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

/// A representation of a button.
///
/// It contains properties for buttons regardless of which button type it will
/// be used in.
class ButtonSpecification {
  final String title;
  final void Function() onTap;
  final bool isBusy;
  final bool isDestructive;

  /// Initializes a new instance of [ButtonSpecification].
  ///
  /// It takes a [String] button text, a [Function] executed on button press,
  /// a [bool] wether it should show as busy and a [bool] wether it should
  /// show as a destructive button as input.
  ButtonSpecification({
    @required this.title,
    @required this.onTap,
    @required this.isBusy,
    this.isDestructive = false,
  });
}
