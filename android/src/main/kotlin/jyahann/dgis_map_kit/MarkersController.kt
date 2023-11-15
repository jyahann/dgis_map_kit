package jyahann.dgis_map_kit

import io.flutter.Log
import io.flutter.plugin.common.MethodChannel
import ru.dgis.sdk.map.MapObjectManager
import ru.dgis.sdk.map.Marker
import ru.dgis.sdk.map.SimpleMapObject
import java.util.Dictionary

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

    private var markersWithNoId: MutableList<Marker> = ArrayList();
    private var markersWithId: MutableMap<String, Marker> = mutableMapOf();


    init {
        this.layerId = layerId
        this.sdkContext = sdkContext
        this.methodChannel = methodChannel
        this.mapObjectManager = mapObjectManager
    }

    fun _getAllMarkers() : List<Marker> {
        return markersWithNoId.plus(markersWithNoId.map { marker -> marker });
    }

    fun addMarkers(markers: List<Any>) {
        val gisMarkers: MutableList<Marker> = ArrayList()

        for (marker in markers) {
            gisMarkers.add(_processNewMarker(marker))
        }

        mapObjectManager.addObjects(gisMarkers)
    }

    private fun _processNewMarker(marker: Any) : Marker {
        val markerId = (marker as Map<String, Any?>)["id"] as String?
        val marker = MarkersUtils.getMarkerFromDart(marker, this.sdkContext, layerId)
        if (markerId != null) {
            val oldMarker = getById(markerId)
            if (oldMarker != null) {
                mapObjectManager.removeObject(oldMarker)
            }
            markersWithId[markerId] = marker
        } else {
            markersWithNoId.add(marker)
        }
        return marker
    }

    fun addMarker(marker: Map<String, Any?>) {
        var marker = _processNewMarker(marker)

        mapObjectManager.addObject(marker)
    }


    fun getAll() : List<Any?> {
        return _getAllMarkers().map { marker -> (marker.userData as MapObjectUserData).userData }
    }

    fun getById(markerId: String) : Marker? {
        return markersWithId[markerId]
    }

    fun removeMarkerById(markerId: String) {
        val marker = getById(markerId)
        if (marker != null) {
            mapObjectManager.removeObject(marker)
            markersWithId.remove(markerId)
        } else {
            Log.d(
                "DGIS",
                "Marker on  remove: marker with given id ($markerId) isn't exists"
            )
        }
    }
    fun removeAll() {
        markersWithNoId = ArrayList()
        markersWithId = mutableMapOf()
        mapObjectManager.removeAll()
    }

    fun update(markerId: String, newMarker: Map<String, Any?>) {
        removeMarkerById(markerId)
        addMarker(newMarker)
    }

    fun close() {
        mapObjectManager.close()
    }
}
