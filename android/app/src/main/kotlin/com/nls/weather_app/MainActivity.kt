package com.nls.weatherapp

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "weather_widget")
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    "updateWeatherWidget" -> {
                        @Suppress("UNCHECKED_CAST")
                        WeatherWidgetUpdater.saveFromFlutter(
                            context = applicationContext,
                            payload = call.arguments as? Map<String, Any?>
                        )
                        result.success(null)
                    }
                    else -> result.notImplemented()
                }
            }
    }
}
