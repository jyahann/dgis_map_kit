package jyahann.dgis_map_kit

import io.flutter.plugin.common.MethodChannel
import ru.dgis.sdk.Duration
import ru.dgis.sdk.map.CameraAnimationType
import ru.dgis.sdk.map.CameraPosition
import ru.dgis.sdk.map.Map
import java.util.concurrent.CompletableFuture

class CameraControllerBuilder {
    var controller = CompletableFuture<CameraController>()

    fun build(
        map: Map,
        methodChannel: MethodChannel,
        initialCameraPosition: CameraPosition,
    ) {
        map.camera.move(initialCameraPosition, Duration.ZERO, CameraAnimationType.LINEAR).onResult { _ ->
            map.camera.positionChannel.connect { position ->
                methodChannel.invokeMethod(
                    "camera#onMove",
                    CameraUtils.getCameraPositionToDart(position)
                )
            }
        }


        controller.complete(CameraController(map, methodChannel))
    }
}