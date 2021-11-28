// import 'package:flutter/cupertino.dart';
// import 'package:flutter/foundation.dart';
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

// enum NewsletterSubscription { yes, no }
// enum ContactVia { phone, email }

class InquiryFormState extends State<InquiryView> {
// class InquiryView extends StatelessWidget with $InquiryView {
  final _formKey = GlobalKey<FormState>();
  final _scrollController = ScrollController();
  String selectedValue;
  String newsletterSubscription;
  String contactVia;
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
        onModelReady: (model) => widget.listenToFormUpdated(model),
        builder: (context, model, child) => NavigationLayout(
          title: "Anfrage",
          body: _buildForm(model),
          actions: const [],
          actionsAppBar: const [],
        ),
      );

  Widget _buildForm(InquiryViewModel model) => Form(
        key: _formKey,
        child: kIsWeb
            ? SingleChildScrollView(
                controller: _scrollController,
                child: _buildFormular(model),
              )
            : _buildFormular(model),
      );

  Widget _buildFormular(InquiryViewModel model) => FormLayout(
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
            onChanged: model.setTitle,
          ),
          TextFormField(
            controller: widget.companyController,
            onEditingComplete: model.submitForm,
            decoration: const InputDecoration(labelText: 'Firma'),
          ),
          TextFormField(
            controller: widget.firstNameController,
            onEditingComplete: model.submitForm,
            decoration: const InputDecoration(labelText: 'Vorname*'),
          ),
          TextFormField(
            controller: widget.lastnameController,
            onEditingComplete: model.submitForm,
            decoration: const InputDecoration(labelText: 'Nachname*'),
          ),
          TextFormField(
            controller: widget.streetController,
            onEditingComplete: model.submitForm,
            decoration: const InputDecoration(labelText: 'Strasse*'),
          ),
          TextFormField(
            controller: widget.plzController,
            onEditingComplete: model.submitForm,
            decoration: const InputDecoration(labelText: 'Postleitzahl*'),
            keyboardType: TextInputType.number,
          ),
          TextFormField(
            controller: widget.locationController,
            onEditingComplete: model.submitForm,
            decoration: const InputDecoration(labelText: 'Ort*'),
          ),
          TextFormField(
            controller: widget.phoneController,
            onEditingComplete: model.submitForm,
            decoration: const InputDecoration(labelText: 'Telefonnummer*'),
            keyboardType: TextInputType.phone,
          ),
          TextFormField(
            controller: widget.mobileController,
            onEditingComplete: model.submitForm,
            decoration: const InputDecoration(labelText: 'Mobiltelefon'),
            keyboardType: TextInputType.phone,
          ),
          TextFormField(
            controller: widget.mailController,
            onEditingComplete: model.submitForm,
            decoration: const InputDecoration(labelText: 'E-Mail*'),
            keyboardType: TextInputType.emailAddress,
          ),
          const Text('Ich möchte den Newsletter abonnieren'),
          ListTile(
            title: const Text('Ja'),
            leading: Radio(
              value: 'Ja',
              groupValue: newsletterSubscription,
              onChanged: (String value) {
                setState(() {
                  newsletterSubscription = value;
                  model.setSubscription(subscription: value);
                });
              },
            ),
          ),
          ListTile(
            title: const Text('Nein'),
            leading: Radio(
              value: 'Nein',
              groupValue: newsletterSubscription,
              onChanged: (String value) {
                setState(() {
                  newsletterSubscription = value;
                  model.setSubscription(subscription: value);
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
                model.setService('Spezialreinigung');
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
                model.setService('Unterhaltsreinigung');
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
                model.setService('Facility Service');
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
                model.setService('Schädlingsbekämpfung');
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
                model.setService('Haustechnikreinigung');
              });
            },
          ),
          TextFormField(
            controller: widget.additionalInterestsController,
            onEditingComplete: model.submitForm,
            decoration: const InputDecoration(
              labelText: 'Weitere Interessen',
            ),
          ),
          const Text('Bitte kontaktieren Sie mich'),
          ListTile(
            title: const Text('per Telefon'),
            leading: Radio(
              value: 'Telefon',
              groupValue: contactVia,
              onChanged: (String value) {
                setState(() {
                  contactVia = value;
                  model.setContactVia(contactVia: value);
                });
              },
            ),
          ),
          ListTile(
            title: const Text('per Email'),
            leading: Radio(
              value: 'E-Mail',
              groupValue: contactVia,
              onChanged: (String value) {
                setState(() {
                  contactVia = value;
                  model.setContactVia(contactVia: value);
                });
              },
            ),
          ),
          TextFormField(
            controller: widget.remarksController,
            onEditingComplete: model.submitForm,
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
          onTap: () {
            model.submitForm();
            if (model.validateForm() == null) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Vielen Dank für Ihre Anfrage'),
                ),
              );
            }
          },
          isBusy: model.isBusy,
        ),
        validationMessage: model.validationMessage,
      );
}
