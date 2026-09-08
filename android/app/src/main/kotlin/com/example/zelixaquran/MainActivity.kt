package com.zelixa.zelixaquran

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val widgetChannel = "com.zelixa.zelixaquran/widget"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, widgetChannel).setMethodCallHandler { call, result ->
            if (call.method == "updateWidgetData") {
                @Suppress("UNCHECKED_CAST")
                val data = call.arguments as? Map<String, String>
                if (data != null) {
                    JadwalShalatWidget.updateAllWidgets(applicationContext, data)
                    result.success(true)
                } else {
                    result.error("INVALID_ARGS", "Widget data is null", null)
                }
            } else {
                result.notImplemented()
            }
        }
    }
}
