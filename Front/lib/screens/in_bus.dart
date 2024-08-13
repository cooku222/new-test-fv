import 'package:flutter/material.dart';

class InBus extends StatelessWidget {
  final List<dynamic> stationList;

  InBus({required this.stationList});

  List<String> _extractStationNames(List<dynamic> stationList) {
    return stationList.map<String>((station) => station['stationName'].toString()).toList();
  }

  @override
  Widget build(BuildContext context) {
    // stationList에서 stationName만 추출
    final stationNames = _extractStationNames(stationList);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          '버스 타기',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 40, // 글씨 크기 40으로 설정
            color: Colors.black, // 글씨 색상을 검정으로 설정
          ),
        ),
        backgroundColor: Colors.white, // 바 색깔을 흰색으로 설정
        centerTitle: false, // 제목을 왼쪽 상단에 정렬
      ),
      backgroundColor: Colors.white, // 배경색을 흰색으로 설정
      body: ListView.builder(
        itemCount: stationNames.length,
        itemBuilder: (context, index) {
          return Container(
            margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Color(0xFFEBF3FB), // 컨테이너 배경색을 #EBF3FB로 설정
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              stationNames[index],
              style: TextStyle(
                fontSize: 25, // 글씨 크기 25로 설정
                fontWeight: FontWeight.bold, // 글씨를 볼드체로
                color: Colors.black, // 글씨 색상을 검정으로 설정
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ElevatedButton(
          onPressed: () {
            // 다음 단계로 이동하는 기능을 추가할 수 있습니다.
          },
          child: Text(
            '다음',
            style: TextStyle(
              fontSize: 20, // 폰트 크기 작게 설정
              fontWeight: FontWeight.bold, // 글씨를 볼드체로
              color: Colors.black, // 폰트 색상을 검정으로 설정
            ),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white, // 버튼 배경색을 하얀색으로 설정
            padding: EdgeInsets.symmetric(vertical: 10),
          ),
        ),
      ),
    );
  }
}
