import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:pronto_mia/app/service_locator.dart';
import 'package:pronto_mia/core/models/appointment.dart';
import 'package:pronto_mia/core/queries/appointment_queries.dart';
import 'package:pronto_mia/core/services/graphql_service.dart';

/// A service, responsible for accessing external news.
///
/// Contains methods to modify and access external news information.
class AppointmentService with ChangeNotifier {
  Future<GraphQLService> get _graphQLService =>
      locator.getAsync<GraphQLService>();

  /// Gets the list of all appointments.
  ///
  /// Returns a [List] list of appointments.
  Future<List<Appointment>> getAppointments() async {
    final data = await (await _graphQLService).query(
      AppointmentQueries.appointments,
    );

    final dtoList = data['appointments'] as List<Object>;
    final appointmentList = dtoList
        .map((dto) => Appointment.fromJson(dto as Map<String, dynamic>))
        .toList();

    return appointmentList;
  }

  /// Creates a new appointments.
  ///
  /// Takes different attributes of an appointments as an input.
  Future<void> createAppointment({
    @required String title,
    @required String location,
    @required DateTime from,
    @required DateTime to,
    @required bool isAllDay,
    @required bool isYearly,
  }) async {
    final Map<String, dynamic> queryVariables = {
      'title': title,
      'location': location,
      'from': from.toIso8601String(),
      'to': to.toIso8601String(),
      'isAllDay': isAllDay,
      'isYearly': isYearly,
    };

    await (await _graphQLService).mutate(
      AppointmentQueries.createAppointment,
      variables: queryVariables,
    );
  }

  /// Updates an existing appointment.
  ///
  /// Takes different attributes of the appointment to be updated as an input.
  Future<void> updateAppointment(
    int id, {
    String title,
    String location,
    DateTime from,
    DateTime to,
    bool isAllDay,
    bool isYearly,
  }) async {
    final Map<String, dynamic> queryVariables = {
      'id': id,
      'title': title,
      'location': location,
      'from': from?.toIso8601String(),
      'to': to?.toIso8601String(),
      'isAllDay': isAllDay,
      'isYearly': isYearly,
    };

    await (await _graphQLService).mutate(
      AppointmentQueries.updateAppointment,
      variables: queryVariables,
    );
  }

  /// Removes an existing deployment plan.
  ///
  /// Takes the [int] id of the appointment to be removed as an input.
  Future<void> removeAppointment(int id) async {
    final queryVariables = {'id': id};
    await (await _graphQLService).mutate(
      AppointmentQueries.removeAppointment,
      variables: queryVariables,
    );
  }

  /// Notifies this objects listeners.
  void notifyDataChanged() {
    notifyListeners();
  }
}
