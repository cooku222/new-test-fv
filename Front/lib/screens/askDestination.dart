import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'Conversation.dart';
import 'openAi.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter TTS 데모',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final FlutterTts flutterTts = FlutterTts();
  // late stt.SpeechToText _speech;
  stt.SpeechToText _speech = stt.SpeechToText();
  String _text = "";

  // 초기 이미지 경로 설정
  String _imagePath = 'images/blueblue.png';
  String _textToSpeak = "";
  void setTextToSpeak(String message) async {
    _textToSpeak = await _handleUserMessage(message);
  }
  // Conversation 인스턴스
  final Conversation _conversation = Conversation();
  double _textSize = 80.0;
  double _topPosition = 100.0;
  double _leftPosition = 20.0;

  void initState() {
    super.initState();
    setTextToSpeak("");
    _speech = stt.SpeechToText();
    _speech.initialize(onStatus: (status) {});
    _speak(); // 앱 시작 시 바로 음성 출력
  }

  Future<void> _speak() async {
    await flutterTts.setLanguage("ko_KR");
    await flutterTts.setPitch(1.0);
    await flutterTts.speak(_textToSpeak);
  }

  Future<void> _listen() async {
      if (_imagePath == 'images/blueblue.png') { //
          setState(() {
              _imagePath = 'images/bluego.png'; // 버튼을 다시 눌렀을 때 원래 이미지로 변경
              _textSize = 50.0;
          });
          _speech.listen(
              onResult: (val) => setState(() {
                _text = val.recognizedWords;
                _handleUserMessage(_text);
              }),
              localeId: 'ko_KR', // 한국어 인식을 위한 locale 설정
          );
      } else {
          setState(() {
              _imagePath = 'images/blueblue.png'; // 버튼을 다시 눌렀을 때 원래 이미지로 변경
              _speech.stop();
          });
      }
  }

  Future<String> _handleUserMessage(String userMessage) async {
    // 대화에 사용자 메시지 추가
    _conversation.addMessage('user', userMessage);

    // API 요청
    final responseContent = await _conversation.sendRequest();

    // 대화에 응답 메시지 추가
    _conversation.addMessage('system', responseContent);

    // 응답 처리
    setState(() {
      _textToSpeak = responseContent;
    });
    print("$responseContent");
    return responseContent;
  }

    @override
    Widget build(BuildContext context) {
      final double screenWidth = MediaQuery.of(context).size.width;
      final double screenHeight = MediaQuery.of(context).size.height;

      return Scaffold(
        appBar: AppBar(
          title: const Text('Flutter TTS 데모'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Stack(
            children: [
              AnimatedPositioned(
                duration: const Duration(milliseconds: 300),
                top: _topPosition,
                left: _leftPosition,
                child: AnimatedDefaultTextStyle(
                  duration: const Duration(milliseconds: 300),
                  style: GoogleFonts.inter(
                    textStyle: TextStyle(
                        fontSize: _textSize,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  ),
                  child: Text(
                    _textToSpeak,
                  ),
                ),
              ),
              Positioned(
                  bottom: 200,
                  left: 80,
                  child: Container(
                    alignment: Alignment(1.0, 1.0),
                    width: screenWidth - 120,
                    child: Text(
                      _text,
                      textAlign: TextAlign.right,
                      style: GoogleFonts.inter(
                        textStyle:
                        const TextStyle(fontSize: 30.0, color: Colors.blue),
                      ),
                    ),
                  )),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton.large(
          onPressed: _listen,
          child: Image.asset(_imagePath),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      );
    }
}