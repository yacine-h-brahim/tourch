package com.example.tourch
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.os.Bundle
import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    
    private val CHANNEL_PROXIMITY_SENSOR = "samples.flutter.dev/tourch"
    private val CHANNEL = "example_service"

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {

        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL_PROXIMITY_SENSOR)
                .setMethodCallHandler { call, result ->
                    if (call.method == "getFlashlightState") {
                        result.success(isFlashlightOn)
                    } else {
                        println("NotImplemented")
                        result.notImplemented()
                    }
                }

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler {
                call,
                result ->
            when (call.method) {
                "StartService" -> {
                    Intent(this, ProxFlashService::class.java).also { intent ->
                        intent.action = "turnOnFlashlight"
                        startService(intent)                    }
                    startService(Intent(this, ProxFlashService::class.java))
                    result.success("Started!")
                }
                "StopService" -> {
                    stopService(Intent(this, ProxFlashService::class.java))

                    result.success("Stopped!")
                }
                else -> result.notImplemented()
            }
        }
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        // instance = this
        registerReceiver(resultReceiver, IntentFilter("updateUI"))

        // registerReceiver(stopReceiver, IntentFilter("STOP_SENSOR_AND_FLASHLIGHT"))
    }

    override fun onDestroy() {
        stopService(Intent(this, ProxFlashService::class.java))
        unregisterReceiver(resultReceiver)

        super.onDestroy()
        // unregisterReceiver(stopReceiver)

    }

    private var isFlashlightOn = false

    private val resultReceiver =
            object : BroadcastReceiver() {
                override fun onReceive(context: Context?, intent: Intent?) {
                    if (intent?.action == "updateUI") {
                        isFlashlightOn = intent.getBooleanExtra("resultValue", false)

                        println(isFlashlightOn)
                        println("--------")
                        // Handle the received proximityData here
                    }
                }
            }

}
