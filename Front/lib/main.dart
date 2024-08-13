import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:untitled/screens/in_bus.dart';
import 'package:untitled/screens/in_walk.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: RouteRequestScreen(),
    );
  }
}

class RouteRequestScreen extends StatefulWidget {
  @override
  _RouteRequestScreenState createState() => _RouteRequestScreenState();
}

class _RouteRequestScreenState extends State<RouteRequestScreen> {
  Map<String, dynamic>? data;

  @override
  void initState() {
    super.initState();
    _fetchCurrentLocationAndRequestAPI();
  }

  Future<void> _fetchCurrentLocationAndRequestAPI() async {
    try {
      // 현재 위치 가져오기
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      double startX = position.longitude;
      double startY = position.latitude;

      // 경희대학교 위치 (고정된 값)
      double endX = 127.053176; // 경희대학교 경도
      double endY = 37.595898;  // 경희대학교 위도

      // API 요청 보내기
      String response = await _sendAPIRequest(startX, startY, endX, endY);

      setState(() {
        data = jsonDecode(utf8.decode(response.codeUnits));
      });

      // 콘솔에 출력 (한국어 깨짐 방지)
      print(utf8.decode(response.codeUnits));
    } catch (e) {
      print("Error: $e");
    }
  }

  Future<String> _sendAPIRequest(double startX, double startY, double endX, double endY) async {
    const String url = 'https://apis.openapi.sk.com/transit/routes';
    const String appKey = 'kPCSlwhXnb27HE1RN6dNC76vJnICEaGv1JeZP1Ck';

    Map<String, String> headers = {
      'accept': 'application/json',
      'appKey': appKey,
      'content-type': 'application/json',
    };

    Map<String, dynamic> body = {
      'startX': startX.toString(),
      'startY': startY.toString(),
      'endX': endX.toString(),
      'endY': endY.toString(),
      'count': 1,
      'lang': 0,
      'format': 'json',
    };

    http.Response response = await http.post(
      Uri.parse(url),
      headers: headers,
      body: jsonEncode(body),
    );

    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('Failed to load data');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (data != null) {
      return RouteScreen(data: data!);
    } else {
      return Scaffold(
        appBar: AppBar(
          title: Center(
            child: Text(
              '일상이상',
              style: TextStyle(
                fontWeight: FontWeight.bold, // 글씨를 볼드체로
              ),
            ),
          ), // 제목을 중간 정렬 및 볼드체로
        ),
        backgroundColor: Colors.white, // 배경색 흰색으로 설정
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
  }
}

class RouteScreen extends StatelessWidget {
  final Map<String, dynamic> data;

  RouteScreen({required this.data});

  @override
  Widget build(BuildContext context) {
    final itineraries = data['metaData']['plan']['itineraries'];
    if (itineraries == null || itineraries.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: Center(
            child: Text(
              '일상이상',
              style: TextStyle(
                fontWeight: FontWeight.bold, // 글씨를 볼드체로
              ),
            ),
          ), // 제목을 중간 정렬 및 볼드체로
        ),
        backgroundColor: Colors.white, // 배경색 흰색으로 설정
        body: Center(
          child: Text(
            'No itineraries found.',
            style: TextStyle(
              fontWeight: FontWeight.bold, // 글씨를 볼드체로
            ),
          ),
        ),
      );
    }

    List<dynamic> legs = itineraries[0]['legs'];
    if (legs == null || legs.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: Center(
            child: Text(
              '일상이상',
              style: TextStyle(
                fontWeight: FontWeight.bold, // 글씨를 볼드체로
              ),
            ),
          ), // 제목을 중간 정렬 및 볼드체로
        ),
        backgroundColor: Colors.white, // 배경색 흰색으로 설정
        body: Center(
          child: Text(
            'No legs found.',
            style: TextStyle(
              fontWeight: FontWeight.bold, // 글씨를 볼드체로
            ),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            '일상이상',
            style: TextStyle(
              fontWeight: FontWeight.bold, // 글씨를 볼드체로
            ),
          ),
        ), // 제목을 중간 정렬 및 볼드체로
      ),
      backgroundColor: Colors.white, // 배경색 흰색으로 설정
      body: ListView.builder(
        itemCount: legs.length,
        itemBuilder: (context, index) {
          String mode = legs[index]['mode'];
          return Container(
            margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black, width: 2), // 버튼 테두리를 검정색으로 설정
              borderRadius: BorderRadius.circular(8),
            ),
            child: ListTile(
              title: Text(
                mode == 'WALK'
                    ? '걷기' // mode가 WALK인 경우 "걷기"로 표시
                    : mode == 'BUS'
                    ? '버스 타기' // mode가 BUS인 경우 "버스 타기"로 표시
                    : 'Mode: $mode',
                style: TextStyle(
                  fontWeight: FontWeight.bold, // 글씨를 볼드체로
                ),
              ),
              onTap: () {
                if (mode == 'WALK') {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => InWalk(
                        steps: legs[index]['steps'],
                      ),
                    ),
                  );
                } else if (mode == 'BUS' || mode == 'SUBWAY') {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => InBus(
                        stationList: legs[index]['passStopList']['stationList'],
                      ),
                    ),
                  );
                }
              },
            ),
          );
        },
      ),
    );
  }
}
