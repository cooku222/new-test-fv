package com.example.yourapp

import android.content.Context
import io.flutter.plugin.platform.PlatformView
import net.daum.mf.map.api.MapView

class KakaoMapView(context: Context) : PlatformView {
    private val mapView = MapView(context)

    override fun getView(): View {
        return mapView
    }

    override fun dispose() {
        // Cleanup if necessary
    }
}

val marker = MapPOIItem()
marker.itemName = "Current Location"
marker.mapPoint = MapPoint.mapPointWithGeoCoord(latitude, longitude)
mapView.addPOIItem(marker)

