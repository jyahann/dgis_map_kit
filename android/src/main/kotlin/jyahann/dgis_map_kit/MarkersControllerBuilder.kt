package jyahann.dgis_map_kit

import ru.dgis.sdk.map.LogicalPixel
import ru.dgis.sdk.map.MapObjectManager
import ru.dgis.sdk.map.MapView
import ru.dgis.sdk.map.Zoom
import java.util.concurrent.CompletableFuture
import io.flutter.plugin.common.MethodChannel
import io.flutter.Log

class MarkersControllerBuilder(
    gisView: MapView,
    sdkContext: ru.dgis.sdk.Context,
    methodChannel: MethodChannel,
    isClustererEnabled: Boolean,
) {
    public var controller = CompletableFuture<MarkersController>()

    init {
        gisView.getMapAsync { map ->
            val mapObjectManager: MapObjectManager?
            var markersUtils = MarkersUtils(sdkContext)

            if (!isClustererEnabled) {
                mapObjectManager = MapObjectManager(map)
            } else {
                mapObjectManager = MapObjectManager.withClustering(
                    map,
                    LogicalPixel(80.0f),
                    Zoom(18.0f),
                    ClusterRenderer(methodChannel, markersUtils),
                )
            }

            gisView.setTouchEventsObserver(MarkersTouchEventObserver(map, methodChannel))

            controller.complete(MarkersController(mapObjectManager, markersUtils, methodChannel))
        }
    }
}