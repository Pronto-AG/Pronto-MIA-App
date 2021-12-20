# Pronto-MIA App

This is the repository for the app component of the Pronto-MIA application. The application is used by the Pronto AG to deliver information to it's employees and handle business processes within the company.

## Settings

All available settings for the application can be defined within four JSON files in the folder `pronto_mia/assets/cfg`.

- `app_settings.json`
  - Contains settings relevant for all contexts. Settings which do not depend on the context the application is run in are defined here.
- `app_settings_dev.json`
  - Contains settings relevant for the development context. These settings will not be loaded if the application is run in production mode.
- `app_settings_prod.json`
  - Contains settings relevant for the production context. These settings will not be loaded if the application is run in development mode.

### Available Options

| Name                              | Type   | Description                                                                                                                                                                                                                                                        |
| --------------------------------- | ------ | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| `pushMessageServerVapidPublicKey` | String | Public vapid key used to check if the sending server signed with the corresponding private key. [How to generate](https://firebase.google.com/docs/cloud-messaging/js/client#generate_a_new_key_pair)                                                              |
| `apiPath`                         | String | Path to the GraphQL endpoint of the server component                                                                                                                                                                                                               |
| `enforceValidCertificate`         | bool   | If false, enables communication with the server component without a valid TLS certificate. This option might compromise security, so please use with caution.                                                                                                      |
| `logLevel`                        | string | String representation of the log level which should be used. For example the value `info` would result in would result in `Level.INFO`and above messages being printed to console. All possible log levels are described [here](https://pub.dev/packages/logging). |

## Setup

### Development

#### Prerequisites

##### General

- [Pronto-MIA Server Development Setup](https://github.com/Pronto-AG/Pronto-MIA-Server#development-setup)
- [A Flutter compatible IDE](https://flutter.dev/docs/get-started/editor?tab=androidstudio)
- [Flutter >= 2.0.0](https://flutter.dev/docs/get-started/install)

##### iOS

- macOS >= 11 device
- [Xcode >= 11](https://flutter.dev/docs/get-started/install)
- If you want to test push notifications:
  - iOS >= 11 device
  - [CocoaPods](https://flutter.dev/docs/get-started/install/macos#deploy-to-ios-devices)

#### Installation Steps

1. Clone this repository
2. Install dependencies with `flutter pub get`
3. Create the [required settings files](#settings).
4. If you want to run on web:
   1. Create or [import](https://firebase.google.com/docs/web/setup#config-object) `pronto_mia/web/firebase-config.js`, which exposes the object `fireBaseConfig` with the following properties:
      - apiKey
      - authDomain
      - projectId
      - storageBucket
      - messagingSenderId
      - appId
   2. Run the application either through your IDE or with `flutter run -d chrome`
5. If you want to run on Android in debug mode:
   1. Create or [import](https://firebase.google.com/docs/android/setup#add-config-file) `pronto_mia/android/app/google-services.json` with the following properties:
      - `project_info`
      - `client`
      - `configuration_version`
   2. Run the application either through your IDE or alternatively build it with `flutter build apk --debug` or `flutter build appbundle --debug`
6. If you want to test Android in release mode or upload a version to the play store:
   1. Create or [import](https://firebase.google.com/docs/android/setup#add-config-file) `pronto_mia/android/app/google-services.json` with the following properties:
      - `project_info`
      - `client`
      - `configuration_version`
   2. In order to sign the release apk/appbundle you will need to create the file `pronto_mia/android/key.properties` with the following contents (see also [this](https://flutter.dev/docs/deployment/android#signing-the-app) tutorial):
   ```ini
   storePassword=<password of your upload keystore>
   keyPassword=<password of your upload key>
   keyAlias=<alias of your upload key (normally upload)>
   storeFile=<path to your keystore file>
   ```
   3. Build the application either through your IDE or with `flutter build apk` or `flutter build appbundle`
7. If you want to run on iOS in debug mode:
   1. Create or [import](https://firebase.google.com/docs/ios/setup#add-config-file) `pronto_mia/ios/Runner/GoogleService-Info.plist` with the following properties:
      - `CLIENT_ID`
      - `REVERSED_CLIENT_ID`
      - `API_KEY`
      - `GCM_SENDER_ID`
      - `PLIST_VERSION`
      - `BUNDLE_ID`
      - `PROJECT_ID`
      - `STORAGE_BUCKET`
      - `IS_ADS_ENABLED`
      - `IS_ANALYTICS_ENABLED`
      - `IS_APPINVITE_ENABLED`
      - `IS_GCM_ENABLED`
      - `IS_SIGNIN_ENABLED`
      - `GOOGLE_APP_ID`
   2. Open the runner workspace in Xcode with `open pronto_mia/ios/Runner.xcworkspace`
   3. Plug in and select your iOS device in Xcode
   4. On your iOS device choose to trust the current computer when prompted.
   5. Sign in with your Apple ID in Xcode.
   6. In `Runner.xcodeproj` under the Targets/Runner tab, navigate to `Signing & Capabilities` and choose the Pronto AG Development Team
   7. On your iOS device in `Settings/General/Device Management` choose to trust the development certificate.
   8. Run the application either through your IDE, Xcode or with `flutter run`.

## Special Dependencies

When updating one of the following dependencies, additional steps are required:

- `firebase_messaging`
  - Update sections `Firebase Cloud Messaging` in `pronto_mia/web/index.html` as described [here](https://firebase.flutter.dev/docs/messaging/overview/#5-web-only-add-the-sdk)
