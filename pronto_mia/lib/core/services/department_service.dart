import 'package:pronto_mia/app/service_locator.dart';
import 'package:pronto_mia/core/models/department.dart';
import 'package:pronto_mia/core/queries/department_queries.dart';
import 'package:pronto_mia/core/services/graphql_service.dart';

/// A service, responsible for accessing departments.
///
/// Contains methods to modify and access department information.
class DepartmentService {
  Future<GraphQLService> get _graphQLService =>
      locator.getAsync<GraphQLService>();

  /// Gets the list of all departments.
  ///
  /// Returns a [List] list of departments.
  Future<List<Department>> getDepartments() async {
    final data =
        await (await _graphQLService).query(DepartmentQueries.departments);
    final dtoList = data['departments'] as List<Object>;
    final departmentList = dtoList
        .map((dto) => Department.fromJson(dto as Map<String, dynamic>))
        .toList();

    return departmentList;
  }

  /// Creates a new department.
  ///
  /// Takes the [String] departments name as an input.
  Future<void> createDepartment(String name) async {
    final queryVariables = {'name': name};
    await (await _graphQLService)
        .mutate(DepartmentQueries.createDepartment, variables: queryVariables);
  }

  /// Updates an existing department.
  ///
  /// Takes the [int] id of the department to be updated, alongside its new
  /// [String] name as an input.
  Future<void> updateDepartment(int id, {String name}) async {
    final queryVariables = {'id': id, 'name': name};
    await (await _graphQLService).mutate(
      DepartmentQueries.updateDepartment,
      variables: queryVariables,
    );
  }

  /// Removes an existing department.
  ///
  /// Takes the [int] id of the department to be removed as an input.
  Future<void> removeDepartment(int id) async {
    final queryVariables = {'id': id};
    await (await _graphQLService).mutate(
      DepartmentQueries.removeDepartment,
      variables: queryVariables,
    );
  }
}
