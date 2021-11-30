import 'package:flutter/material.dart';
import 'package:pronto_mia/ui/components/navigation_layout.dart';

/// A widget, representing the contact view.
class ContactView extends StatelessWidget {
  const ContactView({Key key}) : super(key: key);

  /// Takes the current [BuildContext] as an input.
  /// Returns the built [Widget].
  @override
  Widget build(BuildContext context) => NavigationLayout(
        title: "Kontakt Pronto AG",
        body: _buildForm(),
        actions: const [],
        actionsAppBar: const [],
      );

  Widget _buildForm() => Center(
        child: Container(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Container(
                height: 120.0,
                padding: const EdgeInsets.all(16.0),
                child: Image.asset(
                  'assets/images/pronto_logo.png',
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 30, bottom: 20),
                child: Column(
                  children: const [
                    Text(
                      "Pronto AG",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                    Text("St. Josefen-Strasse 30"),
                    Text("9000 St. Gallen"),
                    Text("Schweiz"),
                    Text("+41 71 272 32 42"),
                    Text("info@pronto-ag.ch"),
                  ],
                ),
              ),
              const Divider(),
              Padding(
                padding: const EdgeInsets.only(top: 10, bottom: 10),
                child: Column(
                  children: const [
                    Text(
                      "Pronto Plus AG",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                    Text("Grundstrasse 14"),
                    Text("6343 Rotkreuz"),
                    Text("Schweiz"),
                    Text("+41 41 790 28 63"),
                    Text("plus@pronto-ag.ch"),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
}
