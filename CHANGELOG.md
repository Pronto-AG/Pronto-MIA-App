# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.0] - 2021-12-22
### Fixed
- Disable back button on logout
- Appointment creation without selected date bug

## [0.6.0] - 2021-12-17
### Added
- Cancel Button ability
- HTML editor and view
- Ability to create, edit and delete educational contents
- Ability to create, edit and delete internal news
- Ability to create, edit and delete appointments
- Ability to handle videos

### Changed
- Hide Deployment Plan when updating pdf file

### Fixed
- Mail sending bug
- Department manager can update own content bug

## [0.5.0] - 2021-11-30
### Added
- Ability to view page number in PDF viewer
- Ability to send inquiry request to Pronto AG via mail
- Ability to see contact details from Pronto AG
- Ability to filter different views
- Ability to select entries for deletion
- Ability to delete entry with swiping

### Changed
- Deployment Plan default end date is set to 14 days
- User can have multiple departments
- Change style of External News overview
- Actions can appear in appbar or as floating button

## [0.4.2] - 2021-11-30
This release was created by mistake
see Release 0.5.0 for information

## [0.4.1] - 2021-11-08
### Added
- Ability to create, edit and delete external news
- Ability to handle images
- Ability to view password in clear text

### Changed
- User can view External News without a login
- Start Page of app is External News
- Change Style of Settings page

## [0.4.0] - 2021-10-28
### Changed
- Updated dependencies and removed deprecetad commands

## [0.3.0] - 2021-06-09

### Added
- Ability to create, edit and delete departments
- Ability to create, edit and delete users
- Ability for users to logout
- Ability for users to change their password
- Authorization that limits what users can do and view

### Changed
- Improved error handling

### Removed
- Items in the navigation that are not yet implemented

### Fixed
- Several bugs

## [0.2.0] - 2021-05-18

### Added
- Ability to view deployment plans as a list
- Ability to create, submit and delete deployment plans
- Ability to publish deployment plans with push notifications
- Platform specific pdf handling on web
- Runnable on iOS
- Logging that correlates to server logs

### Changed
- Redesign of pdf view on mobile
- Redesign of the login page
- Redesign of push notification handling
- Improvement of the global error handling
- Improvement of token storage security

### Removed
- Ability to download and view a standalone PDF from the server
- Ability to upload a standalone PDF to the server
- Ability to navigate via web urls

### Fixed
- Several UI bugs
- Several platform specific bugs
- A cache related bug
- A timezone related bug

## [0.1.0] - 2021-04-07

### Added
- Simple authorization through a login page
- Ability to upload a PDF to the server
- Ability to download and view a PDF from the server
- Ability to receive push notifications
- Runnable on Android and Web
