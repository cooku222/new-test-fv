import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class InWalk extends StatefulWidget {
  final List<dynamic> steps;

  InWalk({required this.steps});

  @override
  _InWalkState createState() => _InWalkState();
}

class _InWalkState extends State<InWalk> {
  int _currentStepIndex = 0;
  GoogleMapController? _mapController;

  List<Map<String, dynamic>> _processSteps(List<dynamic> steps) {
    return steps.map((step) {
      // linestring을 LatLng 배열로 변환
      List<LatLng> latLngList = (step['linestring'] as String)
          .split(' ')
          .map((point) {
        List<String> latLng = point.split(',');
        return LatLng(double.parse(latLng[1]), double.parse(latLng[0]));
      }).toList();

      return {
        'description': step['description'],
        'linestring': latLngList,
      };
    }).toList();
  }

  void _nextStep() {
    if (_currentStepIndex < widget.steps.length - 1) {
      setState(() {
        _currentStepIndex++;
        _moveCameraToCurrentStep();
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("You've reached the last step."),
      ));
    }
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
    _moveCameraToCurrentStep();
  }

  void _moveCameraToCurrentStep() {
    final currentStep = _processSteps(widget.steps)[_currentStepIndex];
    if (currentStep['linestring'].isNotEmpty) {
      LatLng startLocation = currentStep['linestring'][0];
      _mapController?.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: startLocation,
            zoom: 18, // 확대 수준
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // steps를 처리하여 description과 변환된 linestring만 남김
    final processedSteps = _processSteps(widget.steps);
    final currentStep = processedSteps[_currentStepIndex];

    return Scaffold(
      appBar: AppBar(
        title: Text(
          '걷기',
          style: TextStyle(
            fontWeight: FontWeight.bold, // 글씨를 볼드체로
            fontSize: 40, // 글씨 크기 40으로 설정
            color: Colors.black, // 글씨 색상을 검정으로 설정
          ),
        ),
        backgroundColor: Colors.white, // 바 색깔을 흰색으로 설정
        centerTitle: false, // 제목을 왼쪽 상단에 정렬
      ),
      backgroundColor: Colors.white, // 배경색 흰색으로 설정
      body: Stack(
        children: [
          // 지도 전체 화면
          GoogleMap(
            onMapCreated: _onMapCreated,
            initialCameraPosition: CameraPosition(
              target: currentStep['linestring'].isNotEmpty
                  ? currentStep['linestring'][0]
                  : LatLng(0, 0),
              zoom: 18, // 기본 확대 수준을 높게 설정 (16 -> 18)
            ),
            polylines: {
              Polyline(
                polylineId: PolylineId('route'),
                points: currentStep['linestring'],
                color: Colors.blue,
                width: 5,
              ),
            },
            markers: {
              if (currentStep['linestring'].isNotEmpty)
                Marker(
                  markerId: MarkerId('start'),
                  position: currentStep['linestring'][0],
                  infoWindow: InfoWindow(title: 'Start'),
                ),
              if (currentStep['linestring'].isNotEmpty)
                Marker(
                  markerId: MarkerId('end'),
                  position: currentStep['linestring'].last,
                  infoWindow: InfoWindow(title: 'End'),
                ),
            },
          ),
          // 지도 위에 글씨들 오버레이
          Positioned(
            top: 20,
            left: 20,
            right: 20,
            child: Text(
              currentStep['description'],
              style: TextStyle(
                fontSize: 40, // 글씨 크기 40으로 설정
                fontWeight: FontWeight.bold, // 글씨를 볼드체로
                color: Colors.black, // 글씨 색상 검정으로 설정
              ),
              textAlign: TextAlign.left,
            ),
          ),
          // 다음 버튼 추가
          Positioned(
            bottom: 20,
            left: 20,
            right: 20,
            child: ElevatedButton(
              onPressed: _nextStep,
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
        ],
      ),
    );
  }
}
