package jyahann.dgis_map_kit

import ru.dgis.sdk.map.LogicalPixel
import ru.dgis.sdk.map.MapObjectManager
import ru.dgis.sdk.map.Zoom
import java.util.concurrent.CompletableFuture
import io.flutter.plugin.common.MethodChannel
import ru.dgis.sdk.map.Map

class MarkersControllerBuilder(layerId: String? = null) {
    var controller = CompletableFuture<MarkersController>()
    var layerId: String?;

    init {
        this.layerId = layerId
    }

    fun build(
        map: Map,
        sdkContext: ru.dgis.sdk.Context,
        methodChannel: MethodChannel,
        isClustererEnabled: Boolean,
    )  {
        val mapObjectManager: MapObjectManager?

        if (!isClustererEnabled) {
            mapObjectManager = MapObjectManager(map,)
        } else {
            mapObjectManager = MapObjectManager.withClustering(
                map,
                LogicalPixel(80.0f),
                Zoom(18.0f),
                ClusterRenderer(methodChannel,sdkContext),
            )
        }

        controller.complete(MarkersController(sdkContext, mapObjectManager, methodChannel, layerId))
    }

    fun close() {
        controller.get().close()
    }
}