import 'dart:convert';
import 'package:http/http.dart' as http;

class Conversation {
  final List<Map<String, String>> _messages = [{
    'role': 'system',
    'content': '당신은 친절한 안내자 입니다. 사용자가 가고 싶어하는 목적지와 가길 원하는 이유를 파악하는 것이 목표입니다. 기본적으로 목적지에 대해서 물어보세요. 대답에서 경로를 찾는 이유를 찾을 수 있다면 추가 질문을 생략하고 다음 단계로 넘어가고 찾을 수 없다면 이유에 대해서 다시 질의합니다. 필요한 모든 정보(목적지, 이유)를 확인한 후, 경로 안내를 원하시는지 물어봅니다. 경로 안내를 원하지 않는다면 처음으로 돌아가 다시 정보를 수집합니다. 사용자가 올바르지 않은 정보를 입력했을 때는 정중하게 설명하고, 다시 질문합니다. 항상 간결한 어조로 한문장으로 대화하세요.'
  }];

  void addMessage(String role, String content) {
    _messages.add({
      'role': role,
      'content': content,
    });
  }

  List<Map<String, String>> get messages => _messages;

  Future<String> sendRequest() async {
    final response = await http.post(
      Uri.parse(
          'https://dku-khtml.openai.azure.com/openai/deployments/gpt-4o/chat/completions?api-version=2024-02-15-preview'),
      headers: {
        'Content-Type': 'application/json',
        'api-key':  '8af6fd106b3745ef827ef4db1261d84f',
      },
      body: jsonEncode({
        'model': 'gpt-4o', // 사용할 모델
        'messages': _messages,
      }),
    );

    if (response.statusCode == 200) {
      final responseData = jsonDecode(utf8.decode(response.bodyBytes));

      try {
        final content = responseData['choices'][0]['message']['content'];
        return content;
      } catch (e) {
        print('Error extracting content: $e');
        return "";
      }
    } else {
      print('Request failed with status: ${response.statusCode}');
      return "";
    }
  }
}