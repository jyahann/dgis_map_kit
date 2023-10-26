package jyahann.dgis_map_kit

import io.flutter.plugin.common.MethodChannel
import io.flutter.Log
import ru.dgis.sdk.map.LogicalPixel
import ru.dgis.sdk.map.MapObjectManager
import ru.dgis.sdk.map.MapView
import ru.dgis.sdk.map.Marker
import ru.dgis.sdk.map.Zoom
import java.util.concurrent.CompletableFuture

class MarkersController(
        mapObjectManager: MapObjectManager,
        markersUtils: MarkersUtils,
        methodChannel: MethodChannel,
) {
    private var mapObjectManager: MapObjectManager
    private var methodChannel: MethodChannel
    private var markersUtils: MarkersUtils

    init {
        this.methodChannel = methodChannel
        this.markersUtils = markersUtils
        this.mapObjectManager = mapObjectManager
    }

    fun addMarkers(markers: List<Any>) {
        val gisMarkers: MutableList<Marker> = ArrayList()

        for (marker in markers) {
            gisMarkers.add(markersUtils.getMarkerFromDart(marker as Map<String, Any>))
        }

        mapObjectManager.addObjects(gisMarkers)
    }

    fun addMarker(marker: Map<String, Any>) {
        var marker = markersUtils.getMarkerFromDart(marker)

        mapObjectManager.addObject(marker)
    }
}
