package jyahann.dgis_map_kit

import ru.dgis.sdk.coordinates.GeoPoint
import ru.dgis.sdk.geometry.GeoPointWithElevation
import ru.dgis.sdk.map.Anchor
import ru.dgis.sdk.map.Image
import ru.dgis.sdk.map.LogicalPixel
import ru.dgis.sdk.map.MapObjectManager
import ru.dgis.sdk.map.MapView
import ru.dgis.sdk.map.Marker
import ru.dgis.sdk.map.MarkerOptions
import ru.dgis.sdk.map.ZIndex
import ru.dgis.sdk.map.imageFromAsset

class MarkersController(gisView: MapView, sdkContext: ru.dgis.sdk.Context) {
    private var gisView: MapView;
    private var sdkContext: ru.dgis.sdk.Context
    private var mapObjectManager: MapObjectManager? = null

    init {
        this.gisView = gisView
        this.sdkContext = sdkContext
    }

    private fun getObjectManagerAsync(callback: (objectManager: MapObjectManager) -> Unit) {
        if (mapObjectManager != null) {
            callback(mapObjectManager as MapObjectManager)
        }

        gisView.getMapAsync { map ->
            mapObjectManager = MapObjectManager(map)
            callback(mapObjectManager as MapObjectManager)
        }
    }

    fun addMarkers(markers: List<Any>) {
        for (marker in markers) {
            addMarker(marker as Map<String, Any>)
        }
    }

    fun addMarker(marker: Map<String, Any>) {
        getObjectManagerAsync {objectManager ->
            val iconOptions = marker["iconOptions"] as Map<String, Any>
            var assetLookupKey = io.flutter.view.FlutterMain.getLookupKeyForAsset(marker["icon"] as String)

            objectManager.addObject(
                Marker(
                    MarkerOptions(
                        position = getPositionFromDart(marker["position"] as Map<String, Any>),
                        icon = imageFromAsset(sdkContext,  assetLookupKey),
                        anchor = getAnchorFromDart(iconOptions["anchor"] as Map<String, Any>),
                        text = iconOptions["text"] as String?,
                        zIndex = ZIndex(iconOptions["zIndex"] as Int),
                        userData = marker["data"],
                        iconWidth = LogicalPixel((iconOptions["size"] as Double).toFloat())
                    )
                )
            )
        }
    }

    private fun getAnchorFromDart(anchor: Map<String, Any>) : Anchor {
        return Anchor(
            x = (anchor["x"] as Double).toFloat(),
            y = (anchor["y"] as Double).toFloat()
        )
    }

    private fun getPositionFromDart(position: Map<String, Any>) : GeoPointWithElevation {
        return GeoPointWithElevation(
            point = GeoPoint(
                latitude = position["lat"] as Double,
                longitude = position["long"] as Double
            )
        )
    }
}