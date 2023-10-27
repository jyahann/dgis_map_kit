package jyahann.dgis_map_kit

import ru.dgis.sdk.map.Map
import io.flutter.plugin.common.MethodChannel
import ru.dgis.sdk.Duration
import ru.dgis.sdk.map.CameraAnimationType

class CameraController(map: Map, methodChannel: MethodChannel) {
    private var map: Map
    private var methodChannel: MethodChannel

    init {
        this.map = map
        this.methodChannel = methodChannel
    }

    fun moveCamera(params: kotlin.collections.Map<String, Any>) : Unit {
        map.camera.move(
            CameraUtils.getCameraPositionFromDart(params["cameraPosition"] as kotlin.collections.Map<String, Any>),
            Duration.ofMilliseconds((params["durationInMilliseconds"] as Int).toLong()) ,
            CameraAnimationType.valueOf(params["animationType"] as String)
        )
    }
}