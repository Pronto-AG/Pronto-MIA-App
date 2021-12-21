import 'package:flutter/material.dart';

/// A widget, representing the password field.
class PasswordField extends StatefulWidget {
  final TextEditingController controller;
  final VoidCallback submitForm;
  final String labelText;

  const PasswordField({
    Key key,
    this.controller,
    this.submitForm,
    this.labelText,
  }) : super(key: key);

  @override
  _PasswordState createState() => _PasswordState();
}

/// A widget, representing the password field state.
class _PasswordState extends State<PasswordField> {
  bool _isObscure = true;

  /// Builds the custom passwordfield widget.
  ///
  /// Takes the current [BuildContext] as an input.
  /// Returns the built [Widget].
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      onEditingComplete: widget.submitForm,
      obscureText: _isObscure,
      decoration: InputDecoration(
        labelText: widget.labelText,
        suffixIcon: IconButton(
          icon: Icon(
            _isObscure ? Icons.visibility : Icons.visibility_off,
          ),
          onPressed: () {
            setState(() {
              _isObscure = !_isObscure;
            });
          },
        ),
      ),
    );
  }
}
