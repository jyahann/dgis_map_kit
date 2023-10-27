package jyahann.dgis_map_kit

import io.flutter.plugin.common.MethodChannel
import ru.dgis.sdk.map.MapObjectManager
import ru.dgis.sdk.map.Marker

class MarkersController(
    sdkContext: ru.dgis.sdk.Context,
    mapObjectManager: MapObjectManager,
    methodChannel: MethodChannel,
) {
    private var sdkContext: ru.dgis.sdk.Context
    private var mapObjectManager: MapObjectManager
    private var methodChannel: MethodChannel

    init {
        this.sdkContext = sdkContext
        this.methodChannel = methodChannel
        this.mapObjectManager = mapObjectManager
    }

    fun addMarkers(markers: List<Any>) {
        val gisMarkers: MutableList<Marker> = ArrayList()

        for (marker in markers) {
            gisMarkers.add(MarkersUtils.getMarkerFromDart(marker as Map<String, Any>, this.sdkContext))
        }

        mapObjectManager.addObjects(gisMarkers)
    }

    fun addMarker(marker: Map<String, Any>) {
        var marker = MarkersUtils.getMarkerFromDart(marker, this.sdkContext)

        mapObjectManager.addObject(marker)
    }
}
