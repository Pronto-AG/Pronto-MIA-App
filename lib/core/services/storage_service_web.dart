import 'dart:convert';
import 'package:http/http.dart' as http;
import 'storage_service.dart';

class StorageServiceWeb extends StorageService {
  @override
  Future<int> getCounterValue() async {
    Uri uri = Uri.https('example.com', 'counter');
    http.Response response = await http.get(uri);
    String json = response.body;
    Map<String, dynamic> map = jsonDecode(json);
    int counterValue = map['counter'];
    return counterValue;
  }

  @override
  Future<void> saveCounterValue(int value) async {
    Uri uri = Uri.https('example.com', 'counter');
    Map<String, String> headers = {'Content-type': 'application/json'};
    String json = '{"counter": $value}';
    await http.post(uri, headers: headers, body: json);
  }
}