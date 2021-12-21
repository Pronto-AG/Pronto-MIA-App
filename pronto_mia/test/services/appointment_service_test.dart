import 'dart:typed_data';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'package:pronto_mia/core/models/appointment.dart';
import 'package:pronto_mia/core/models/simple_file.dart';
import 'package:pronto_mia/core/queries/appointment_queries.dart';
import 'package:pronto_mia/core/services/appointment_service.dart';
import 'package:stacked_services/stacked_services.dart';

import '../setup/test_helpers.dart';

void main() {
  group('AppointmentService', () {
    AppointmentService appointmentService;
    setUp(() {
      registerServices();
      appointmentService = AppointmentService();
    });
    tearDown(() => unregisterServices());

    group('getAppointments', () {
      test('returns appointments', () async {
        final graphQLService = getAndRegisterMockGraphQLService();
        when(
          graphQLService.query(
            captureAny,
            variables: captureAnyNamed('variables'),
            useCache: captureAnyNamed('useCache'),
          ),
        ).thenAnswer(
          (realInvocation) => Future.value({
            'appointments': [
              {
                'id': 1,
                'title': 'test',
                'location': 'test',
                'from': DateTime.now().toIso8601String(),
                'to': DateTime.now()
                    .add(const Duration(hours: 2))
                    .toIso8601String(),
                'isAllDay': false,
                'isYearly': false,
              }
            ]
          }),
        );

        expect(await appointmentService.getAppointments(), hasLength(1));
        verify(
          graphQLService.query(AppointmentQueries.appointments),
        ).called(1);
      });
    });

    group('getAppointmentById', () {
      test('returns appointments', () async {
        final graphQLService = getAndRegisterMockGraphQLService();
        when(
          graphQLService.query(
            captureAny,
            variables: captureAnyNamed('variables'),
            useCache: captureAnyNamed('useCache'),
          ),
        ).thenAnswer(
          (realInvocation) => Future.value({
            'appointments': [
              {
                'id': 1,
                'title': 'test',
                'location': 'test',
                'from': DateTime.now().toIso8601String(),
                'to': DateTime.now()
                    .add(const Duration(hours: 2))
                    .toIso8601String(),
                'isAllDay': false,
                'isYearly': false,
              }
            ]
          }),
        );

        await appointmentService.getAppointmentById(1);
        verify(
            graphQLService.query(AppointmentQueries.appointments, variables: {
          'id': 1,
        })).called(1);
      });
    });

    group('getAppointmentTitle', () {
      test('returns title of appointment', () async {
        expect(
            appointmentService.getAppointmentTitle(
              Appointment(
                id: 1,
                title: 'test',
                location: 'location',
                from: DateTime.now(),
                to: DateTime.now(),
                isAllDay: false,
                isYearly: false,
              ),
            ),
            equals('test'));
      });
    });

    group('createAppointment', () {
      test('creates appointment', () async {
        final graphQLService = getAndRegisterMockGraphQLService();

        await appointmentService.createAppointment(
          title: 'test',
          location: 'test',
          from: DateTime.now(),
          to: DateTime.now().add(const Duration(hours: 2)),
          isAllDay: false,
          isYearly: false,
        );
        verify(
          graphQLService.mutate(
            AppointmentQueries.createAppointment,
            variables: {
              'title': 'test',
              'location': 'test',
              'from': anything,
              'to': anything,
              'isAllDay': false,
              'isYearly': false,
            },
          ),
        ).called(1);
      });
    });

    group('updateAppointment', () {
      test('updates appointment title', () async {
        final graphQLService = getAndRegisterMockGraphQLService();

        await appointmentService.updateAppointment(
          1,
          title: 'test',
          from: DateTime.now(),
          to: DateTime.now().add(const Duration(hours: 2)),
        );
        verify(
          graphQLService.mutate(
            AppointmentQueries.updateAppointment,
            variables: {
              'id': 1,
              'title': 'test',
              'location': null,
              'from': anything,
              'to': anything,
              'isAllDay': null,
              'isYearly': null,
            },
          ),
        ).called(1);
      });

      test('updates appointment location', () async {
        final graphQLService = getAndRegisterMockGraphQLService();

        await appointmentService.updateAppointment(
          1,
          location: 'test',
        );
        verify(
          graphQLService.mutate(
            AppointmentQueries.updateAppointment,
            variables: {
              'id': 1,
              'title': null,
              'location': 'test',
              'from': null,
              'to': null,
              'isAllDay': null,
              'isYearly': null,
            },
          ),
        ).called(1);
      });
    });

    group('removeAppointment', () {
      test('removes appointment', () async {
        final graphQLService = getAndRegisterMockGraphQLService();

        await appointmentService.removeAppointment(1);
        verify(
          graphQLService.mutate(
            AppointmentQueries.removeAppointment,
            variables: {'id': 1},
          ),
        ).called(1);
      });
    });

    group('openCalendar', () {
      test('opens calendar', () async {
        final navigationService = getAndRegisterMockNavigationService();

        await appointmentService.openAppointment(Appointment(
          id: 1,
          title: 'test',
          location: 'test',
          from: DateTime.now(),
          to: DateTime.now(),
          isAllDay: false,
          isYearly: false,
        ));
        verify(
          navigationService.navigateWithTransition(
            argThat(anything),
            transition: NavigationTransition.LeftToRight,
          ),
        ).called(1);
      });
    });
  });
}
