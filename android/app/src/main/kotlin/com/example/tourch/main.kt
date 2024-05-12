// package com.example.tourch
// import android.content.Context
// import android.hardware.Sensor
// import android.hardware.SensorEvent
// import android.hardware.SensorEventListener
// import android.hardware.SensorManager
// import android.hardware.camera2.CameraCharacteristics
// import android.hardware.camera2.CameraManager
// import io.flutter.embedding.android.FlutterActivity
// import io.flutter.embedding.engine.FlutterEngine
// import io.flutter.plugin.common.MethodChannel



// class MainActivity: FlutterActivity() {  
//     private val CHANNEL = "samples.flutter.dev/torch"
// private lateinit var torchController: TorchController
// private lateinit var sensorManager: SensorManager
// private var lightSensor: Sensor? = null
// private lateinit var lightEventListener: SensorEventListener

// override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
//     super.configureFlutterEngine(flutterEngine)

//     torchController = TorchController(applicationContext)
//     MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
//         if (call.method == "turnOn") {
//             torchController.turnOn()
//             result.success("ok")
//         } else if (call.method == "turnOff") {
//             torchController.turnOff()
//             result.success("ok")
//         } else {
            
//             result.notImplemented()
//         }
//     }

//     sensorManager = getSystemService(Context.SENSOR_SERVICE) as SensorManager
//     lightSensor = sensorManager.getDefaultSensor(Sensor.TYPE_LIGHT)
//      var isTorchOn = false // Add this line to track the torch state

//     lightEventListener = object : SensorEventListener {
//         override fun onAccuracyChanged(sensor: Sensor?, accuracy: Int) {
//         }

//         override fun onSensorChanged(event: SensorEvent?) {
//             event?.let {
//                 if (it.values[0] < 10) { // Adjust this value based on your needs.
//                     if (!isTorchOn) {
//                         torchController.turnOn()
//                         isTorchOn = true
//                     } else {
//                         torchController.turnOff()
//                         isTorchOn = false
//                     }
//                 }
//             }
//         }
//     }

//     lightSensor?.let {
//         sensorManager.registerListener(lightEventListener, it, SensorManager.SENSOR_DELAY_NORMAL)
//     }
// }

// override fun onDestroy() {
//     super.onDestroy()
//     sensorManager.unregisterListener(lightEventListener)
// }


// inner class TorchController(context: Context) {
//         private val cameraManager = context.getSystemService(Context.CAMERA_SERVICE) as CameraManager
//         private var cameraId: String? = null
    
//         init {
//             cameraId = getCameraId()
//         }
    
//         fun turnOn() {
//             cameraId?.let {
//                 cameraManager.setTorchMode(it, true)
//             }
//         }
    
//         fun turnOff() {
//             cameraId?.let {
//                 cameraManager.setTorchMode(it, false)
//             }
//         }
    
//         private fun getCameraId(): String? {
//             for (id in cameraManager.cameraIdList) {
//                 val characteristics = cameraManager.getCameraCharacteristics(id)
//                 val facing = characteristics.get(CameraCharacteristics.LENS_FACING)
//                 val flashAvailable = characteristics.get(CameraCharacteristics.FLASH_INFO_AVAILABLE)
//                 if (facing == CameraCharacteristics.LENS_FACING_BACK && flashAvailable == true) {
//                     return id
//                 }
//             }
//             return null
//         }
//     }
// }
