import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'package:pronto_mia/core/queries/department_queries.dart';
import 'package:pronto_mia/core/services/department_service.dart';

import '../setup/test_helpers.dart';

void main() {
  group('DepartmentService', () {
    DepartmentService departmentService;
    setUp(() {
      registerServices();
      departmentService = DepartmentService();
    });
    tearDown(() => unregisterServices());

    group('getDepartments', () {
      test('returns departments', () async {
        final graphQLService = getAndRegisterMockGraphQLService();
        when(
          graphQLService.query(
            captureAny,
            variables: captureAnyNamed('variables'),
            useCache: captureAnyNamed('useCache'),
          ),
        ).thenAnswer(
          (realInvocation) => Future.value({
            'departments': [
              {
                'id': 1,
                'name': 'test',
              }
            ]
          }),
        );

        expect(await departmentService.getDepartments(), hasLength(1));
        verify(graphQLService.query(DepartmentQueries.departments)).called(1);
      });
    });

    group('createDepartment', () {
      test('creates department', () async {
        final graphQLService = getAndRegisterMockGraphQLService();

        await departmentService.createDepartment('test');
        verify(
          graphQLService.mutate(
            DepartmentQueries.createDepartment,
            variables: {'name': 'test'},
          ),
        ).called(1);
      });
    });

    group('updateDepartment', () {
      test('updates department', () async {
        final graphQLService = getAndRegisterMockGraphQLService();

        await departmentService.updateDepartment(1, name: 'test');
        verify(
          graphQLService.mutate(
            DepartmentQueries.updateDepartment,
            variables: {'id': 1, 'name': 'test'},
          ),
        ).called(1);
      });
    });

    group('removeDepartment', () {
      test('removes department', () async {
        final graphQLService = getAndRegisterMockGraphQLService();

        await departmentService.removeDepartment(1);
        verify(
          graphQLService.mutate(
            DepartmentQueries.removeDepartment,
            variables: {'id': 1},
          ),
        ).called(1);
      });
    });
  });
}
