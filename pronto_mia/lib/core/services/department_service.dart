import 'package:pronto_mia/core/models/department.dart';
import 'package:pronto_mia/core/queries/department_queries.dart';
import 'package:pronto_mia/core/services/graphql_service.dart';
import 'package:pronto_mia/app/service_locator.dart';

class DepartmentService {
  Future<GraphQLService> get _graphQLService =>
      locator.getAsync<GraphQLService>();

  Future<List<Department>> getDepartments() async {
    final data =
        await (await _graphQLService).query(DepartmentQueries.departments);
    final dtoList = data['departments'] as List<Object>;
    final departmentList = dtoList
        .map((dto) => Department.fromJson(dto as Map<String, dynamic>))
        .toList();

    return departmentList;
  }

  Future<void> createDepartment(String name) async {
    final queryVariables = {'name': name};
    await (await _graphQLService)
        .mutate(DepartmentQueries.createDepartment, variables: queryVariables);
  }

  Future<void> updateDepartment(int id, {String name}) async {
    final queryVariables = {'id': id, 'name': name};
    await (await _graphQLService).mutate(
      DepartmentQueries.updateDepartment,
      variables: queryVariables,
    );
  }

  Future<void> removeDepartment(int id) async {
    final queryVariables = {'id': id};
    await (await _graphQLService).mutate(
      DepartmentQueries.removeDepartment,
      variables: queryVariables,
    );
  }
}
