package jyahann.dgis_map_kit

import io.flutter.Log
import io.flutter.plugin.common.MethodChannel
import ru.dgis.sdk.map.MapObjectManager
import ru.dgis.sdk.map.Marker
import ru.dgis.sdk.map.SimpleMapObject

class MarkersController(
    sdkContext: ru.dgis.sdk.Context,
    mapObjectManager: MapObjectManager,
    methodChannel: MethodChannel,
    layerId: String?
) {
    private var layerId: String?
    private var sdkContext: ru.dgis.sdk.Context
    private var mapObjectManager: MapObjectManager
    private var methodChannel: MethodChannel
    private var gisMarkers: MutableList<Marker> = ArrayList()


    init {
        this.layerId = layerId
        this.sdkContext = sdkContext
        this.methodChannel = methodChannel
        this.mapObjectManager = mapObjectManager
    }

    fun addMarkers(markers: List<Any>) {
        val gisMarkers: MutableList<Marker> = ArrayList()

        for (marker in markers) {
            _deleteMarkerIfExists(marker as Map<String, Any?>)
            gisMarkers.add(MarkersUtils.getMarkerFromDart(marker, this.sdkContext, layerId))
        }

        this.gisMarkers.addAll(gisMarkers)
        mapObjectManager.addObjects(gisMarkers)
    }

    private fun _deleteMarkerIfExists(marker: Map<String, Any?>) {
        val markerId = marker["id"] as String?
        if (markerId != null) {
            val marker = getById(markerId)
            if (marker != null) {
                mapObjectManager.removeObject(marker)
                gisMarkers.remove(marker)
            }
        }
    }

    fun addMarker(marker: Map<String, Any?>) {
        _deleteMarkerIfExists(marker)
        var marker = MarkersUtils.getMarkerFromDart(marker, this.sdkContext, layerId)

        gisMarkers.add(marker)
        mapObjectManager.addObject(marker)
    }


    fun getAll() : List<Any?> {
        return gisMarkers.map { marker -> (marker.userData as MapObjectUserData).userData }
    }

    fun getById(markerId: String) : Marker? {
        return gisMarkers.firstOrNull() { marker -> ((marker.userData as MapObjectUserData).userData as Map<String, Any?>)["id"] as String? == markerId }
    }

    fun removeMarkerById(markerId: String) {
        val marker = getById(markerId)
        if (marker != null) {
            mapObjectManager.removeObject(marker)
            gisMarkers.remove(marker)
        } else {
            Log.d(
                "DGIS",
                "Marker on  remove: marker with given id ($markerId) isn't exists"
            )
        }
    }
    fun removeAll() {
        mapObjectManager.removeAll()
    }

    fun update(markerId: String, newMarker: Map<String, Any>) {
        removeMarkerById(markerId)
        addMarker(newMarker)
    }

    fun close() {
        mapObjectManager.close()
    }
}
