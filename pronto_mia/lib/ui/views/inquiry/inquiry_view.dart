import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pronto_mia/ui/components/form_layout.dart';
import 'package:pronto_mia/ui/components/navigation_layout.dart';
import 'package:pronto_mia/ui/views/inquiry/inquiry_view.form.dart';
import 'package:pronto_mia/ui/views/inquiry/inquiry_viewmodel.dart';
import 'package:stacked/stacked.dart';

/// A widget, representing the inquiry.
class InquiryView extends StatefulWidget with $InquiryView {
  /// Initializes a new instance of [InquiryView].
  ///
  /// Takes a [Key] to uniquely identify the widget in the widget tree and a
  /// [bool] wether to show admin level functionality as an input.
  InquiryView({Key key}) : super(key: key);

  @override
  InquiryFormState createState() {
    return InquiryFormState();
  }
}

enum NewsletterSubscription { yes, no }
enum ContactVia { phone, email }

class InquiryFormState extends State<InquiryView> {
  final _formKey = GlobalKey<FormState>();
  String selectedValue;
  NewsletterSubscription newsletterSubscription;
  ContactVia contactVia;
  bool spezialreinigung = false;
  bool unterhaltsreinigung = false;
  bool facilityService = false;
  bool schaedlingsbekaempfung = false;
  bool haustechnikreinigung = false;

  /// Binds [InquiryView] and builds the widget.
  ///
  /// Takes the current [BuildContext] as an input.
  /// Returns the built [Widget].
  @override
  Widget build(BuildContext context) =>
      ViewModelBuilder<InquiryViewModel>.reactive(
          viewModelBuilder: () => InquiryViewModel(),
          builder: (context, model, child) => NavigationLayout(
                title: "Anfrage",
                body: _buildForm(model),
                actions: const [],
                actionsAppBar: const [],
              ));

  Widget _buildForm(InquiryViewModel model) => Form(
        key: _formKey,
        child: FormLayout(
          textFields: [
            const Text(
              'Wir freuen uns auf Ihre Kontaktaufnahme und werden uns '
              'schnellstmöglich bei Ihnen melden. Falls Sie daran '
              'interessiert sind, bei Pronto zu arbeiten, finden Sie die '
              'offene Stellen auf unserer Webseite, sowie die entsprechenden '
              'Kontaktinformationen. ',
            ),
            const Text(
              'Bitte bewerben Sie sich nicht über dieses Kontaktformular.',
            ),
            DropdownButtonFormField(
              items: const [
                DropdownMenuItem(
                  value: 'Herr',
                  child: Text('Herr'),
                ),
                DropdownMenuItem(
                  value: 'Frau',
                  child: Text('Frau'),
                ),
              ],
              decoration: const InputDecoration(labelText: 'Anrede'),
              value: selectedValue,
              onChanged: (String newValue) {
                setState(() {
                  selectedValue = newValue;
                });
              },
            ),
            TextFormField(
              decoration: const InputDecoration(labelText: 'Firma'),
            ),
            TextFormField(
              decoration: const InputDecoration(labelText: 'Vorname*'),
            ),
            TextFormField(
              decoration: const InputDecoration(labelText: 'Nachname*'),
            ),
            TextFormField(
              decoration: const InputDecoration(labelText: 'Strasse*'),
            ),
            TextFormField(
              decoration: const InputDecoration(labelText: 'Postleitzahl*'),
            ),
            TextFormField(
              decoration: const InputDecoration(labelText: 'Ort*'),
            ),
            TextFormField(
              decoration: const InputDecoration(labelText: 'Telefonnummer*'),
            ),
            TextFormField(
              decoration: const InputDecoration(labelText: 'Faxnummer'),
            ),
            TextFormField(
              decoration: const InputDecoration(labelText: 'Mobiltelefon'),
            ),
            TextFormField(
              decoration: const InputDecoration(labelText: 'E-Mail*'),
            ),
            const Text('Ich möchte den Newsletter abonnieren'),
            ListTile(
              title: const Text('Ja'),
              leading: Radio(
                value: NewsletterSubscription.yes,
                groupValue: newsletterSubscription,
                onChanged: (NewsletterSubscription value) {
                  setState(() {
                    newsletterSubscription = value;
                  });
                },
              ),
            ),
            ListTile(
              title: const Text('Nein'),
              leading: Radio(
                value: NewsletterSubscription.no,
                groupValue: newsletterSubscription,
                onChanged: (NewsletterSubscription value) {
                  setState(() {
                    newsletterSubscription = value;
                  });
                },
              ),
            ),
            const Text('Ich interessiere mich für folgende Dienstleistungen'),
            CheckboxListTile(
              controlAffinity: ListTileControlAffinity.leading,
              title: const Text('Spezialreinigung'),
              value: spezialreinigung,
              onChanged: (bool value) {
                setState(() {
                  spezialreinigung = value;
                });
              },
            ),
            CheckboxListTile(
              controlAffinity: ListTileControlAffinity.leading,
              title: const Text('Unterhaltsreinigung'),
              value: unterhaltsreinigung,
              onChanged: (bool value) {
                setState(() {
                  unterhaltsreinigung = value;
                });
              },
            ),
            CheckboxListTile(
              controlAffinity: ListTileControlAffinity.leading,
              title: const Text('Facility Service'),
              value: facilityService,
              onChanged: (bool value) {
                setState(() {
                  facilityService = value;
                });
              },
            ),
            CheckboxListTile(
              controlAffinity: ListTileControlAffinity.leading,
              title: const Text('Schädlingsbekämpfung'),
              value: schaedlingsbekaempfung,
              onChanged: (bool value) {
                setState(() {
                  schaedlingsbekaempfung = value;
                });
              },
            ),
            CheckboxListTile(
              controlAffinity: ListTileControlAffinity.leading,
              title: const Text('Haustechnikreinigung'),
              value: haustechnikreinigung,
              onChanged: (bool value) {
                setState(() {
                  haustechnikreinigung = value;
                });
              },
            ),
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Weitere Interessen',
              ),
            ),
            const Text('Bitte kontaktieren Sie mich'),
            ListTile(
              title: const Text('per Telefon'),
              leading: Radio(
                value: ContactVia.phone,
                groupValue: contactVia,
                onChanged: (ContactVia value) {
                  setState(() {
                    contactVia = value;
                  });
                },
              ),
            ),
            ListTile(
              title: const Text('per Email'),
              leading: Radio(
                value: ContactVia.email,
                groupValue: contactVia,
                onChanged: (ContactVia value) {
                  setState(() {
                    contactVia = value;
                  });
                },
              ),
            ),
            TextFormField(
              keyboardType: TextInputType.multiline,
              maxLines: 15,
              minLines: 5,
              decoration: const InputDecoration(
                labelText: 'Bemerkungen',
              ),
            ),
          ],
          primaryButton: ButtonSpecification(
            title: 'Senden',
            onTap: () => model.submitForm(),
            isBusy: false,
          ),
        ),
      );
}
