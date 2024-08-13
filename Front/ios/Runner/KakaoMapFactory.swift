import Flutter
import UIKit

class KakaoMapFactory: NSObject, FlutterPlatformViewFactory {
    private var messenger: FlutterBinaryMessenger

    init(messenger: FlutterBinaryMessenger) {
        self.messenger = messenger
    }

    func create(
        withFrame frame: CGRect,
        viewIdentifier viewId: Int64,
        arguments args: Any?
    ) -> FlutterPlatformView {
        return KakaoMapView(frame: frame)
    }
}

let marker = MTMapPOIItem()
marker.itemName = "Current Location"
marker.mapPoint = MTMapPoint(geoCoord: MTMapPointGeo(latitude: latitude, longitude: longitude))
mapView.addPOIItem(marker)
