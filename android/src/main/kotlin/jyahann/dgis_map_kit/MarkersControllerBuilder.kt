package jyahann.dgis_map_kit

import ru.dgis.sdk.map.LogicalPixel
import ru.dgis.sdk.map.MapObjectManager
import ru.dgis.sdk.map.Zoom
import java.util.concurrent.CompletableFuture
import io.flutter.plugin.common.MethodChannel

class MarkersControllerBuilder(layerId: String? = null) {
    var controller = CompletableFuture<MarkersController>()
    var layerId: String?;

    init {
        this.layerId = layerId
    }

    fun build(
        map: ru.dgis.sdk.map.Map,
        sdkContext: ru.dgis.sdk.Context,
        methodChannel: MethodChannel,
    )  {
        controller.complete(
            MarkersController(
                sdkContext,
                MapObjectManager(map),
                methodChannel, layerId,
                )
        )
    }

    fun buildWithClustering(
        map: ru.dgis.sdk.map.Map,
        sdkContext: ru.dgis.sdk.Context,
        methodChannel: MethodChannel,
        layerConfig: Map<String, Any?>,
    )  {
        val mapObjectManager = MapObjectManager.withClustering(
            map = map,
            logicalPixel = LogicalPixel((layerConfig["minDistance"] as Double).toFloat()),
            maxZoom = Zoom((layerConfig["maxZoom"] as Double).toFloat()),
            clusterRenderer =  ClusterRenderer(methodChannel, sdkContext, layerId),
        )

        controller.complete(
            MarkersController(
                sdkContext,
                mapObjectManager,
                methodChannel,
                layerId
            )
        )
    }

    fun close() {
        controller.get().close()
    }
}