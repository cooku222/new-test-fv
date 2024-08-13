import 'dart:convert';
import 'package:http/http.dart' as http;

Future<Map<String, dynamic>> sendGetRequest(String url, {Map<String, String>? params}) async {
  final uri = Uri.parse(url).replace(queryParameters: params);
  final response = await http.get(uri);

  if (response.statusCode == 200) {
    return jsonDecode(response.body) as Map<String, dynamic>;
  } else {
    throw Exception('Failed to load data');
  }
}

Future<Map<String, dynamic>> sendPostRequest(String url, {Map<String, dynamic>? data}) async {
  final uri = Uri.parse(url);
  final response = await http.post(
    uri,
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode(data),
  );

  if (response.statusCode == 200 || response.statusCode == 201) {
    return jsonDecode(response.body) as Map<String, dynamic>;
  } else {
    throw Exception('Failed to post data');
  }
}

void main() async {
  final url = 'https://api.example.com/resource';

  // GET 요청 예시
  final params = {'key': 'value'};
  try {
    final getResponse = await sendGetRequest(url, params: params);
    print('GET Response: $getResponse');
  } catch (e) {
    print('GET Request failed: $e');
  }

  // POST 요청 예시
  final data = {'name': 'ChatGPT', 'type': 'AI'};
  try {
    final postResponse = await sendPostRequest(url, data: data);
    print('POST Response: $postResponse');
  } catch (e) {
    print('POST Request failed: $e');
  }
}
