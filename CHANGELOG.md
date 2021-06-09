# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

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
