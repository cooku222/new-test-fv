package com.example.untitled;

import io.flutter.embedding.android.FlutterActivity;
import net.daum.mf.map.api.MapView

public class MainActivity extends FlutterActivity {
}

package com.example.yourapp

import android.os.Bundle
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.embedding.android.FlutterActivity

class MainActivity : FlutterActivity() {

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        flutterEngine
                .platformViewsController
                .registry
                .registerViewFactory("kakao_map_view", KakaoMapFactory())
    }
}
