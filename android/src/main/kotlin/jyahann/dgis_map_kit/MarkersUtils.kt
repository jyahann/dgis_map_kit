package jyahann.dgis_map_kit

import ru.dgis.sdk.coordinates.GeoPoint
import ru.dgis.sdk.geometry.GeoPointWithElevation
import ru.dgis.sdk.map.Anchor
import ru.dgis.sdk.map.Color
import ru.dgis.sdk.map.LogicalPixel
import ru.dgis.sdk.map.Marker
import ru.dgis.sdk.map.MarkerOptions
import ru.dgis.sdk.map.SimpleClusterOptions
import ru.dgis.sdk.map.TextPlacement
import ru.dgis.sdk.map.TextStyle
import ru.dgis.sdk.map.ZIndex
import ru.dgis.sdk.map.imageFromAsset

class MarkersUtils(sdkContext: ru.dgis.sdk.Context) {
    private var sdkContext: ru.dgis.sdk.Context

    init {
        this.sdkContext = sdkContext
    }

    fun getMarkerFromDart(marker: Map<String, Any>): Marker {
        val iconOptions = marker["iconOptions"] as Map<String, Any>
        var assetLookupKey =
                io.flutter.view.FlutterMain.getLookupKeyForAsset(marker["icon"] as String)

        return Marker(
                MarkerOptions(
                        position = getPositionFromDart(marker["position"] as Map<String, Any>),
                        icon = imageFromAsset(sdkContext, assetLookupKey),
                        anchor = getAnchorFromDart(iconOptions["anchor"] as Map<String, Any>),
                        text = iconOptions["text"] as String?,
                        zIndex = ZIndex(iconOptions["zIndex"] as Int),
                        userData =
                                MapObjectUserData(
                                        type = MapObjectUserDataType.MARKER,
                                        userData = marker,
                                ),
                        iconWidth = LogicalPixel((iconOptions["size"] as Double).toFloat()),
                        textStyle =
                                getTextStyleFromDart(
                                        iconOptions["textStyle"] as Map<String, Any>,
                                )
                )
        )
    }

    fun getClusterOptionsFromDart(
            mapClusterer: Map<String, Any>,
            markers: List<Any?>
    ): SimpleClusterOptions {
        val iconOptions = mapClusterer["iconOptions"] as Map<String, Any>
        var assetLookupKey =
                io.flutter.view.FlutterMain.getLookupKeyForAsset(mapClusterer["icon"] as String)

        return SimpleClusterOptions(
                icon = imageFromAsset(sdkContext, assetLookupKey),
                anchor = getAnchorFromDart(iconOptions["anchor"] as Map<String, Any>),
                text = iconOptions["text"] as String?,
                zIndex = ZIndex(iconOptions["zIndex"] as Int),
                userData =
                        MapObjectUserData(
                                type = MapObjectUserDataType.CLUSTER,
                                userData = markers,
                        ),
                textStyle =
                    getTextStyleFromDart(
                        iconOptions["textStyle"] as Map<String, Any>,
                    ),
                iconWidth = LogicalPixel((iconOptions["size"] as Double).toFloat())
        )
    }

    fun getAnchorFromDart(anchor: Map<String, Any>): Anchor {
        return Anchor(x = (anchor["x"] as Double).toFloat(), y = (anchor["y"] as Double).toFloat())
    }

    fun getPositionFromDart(position: Map<String, Any>): GeoPointWithElevation {
        return GeoPointWithElevation(
                point =
                        GeoPoint(
                                latitude = position["lat"] as Double,
                                longitude = position["long"] as Double
                        )
        )
    }

    fun getTextStyleFromDart(textStyle: Map<String, Any>): TextStyle {
        return TextStyle(
                fontSize = LogicalPixel((textStyle["fontSize"] as Double).toFloat()),
                color = Color((textStyle["color"] as Long).toInt()),
                strokeWidth = LogicalPixel((textStyle["strokeWidth"] as Double).toFloat()),
                strokeColor = Color((textStyle["strokeColor"] as Long).toInt()),
                textPlacement = TextPlacement.valueOf(textStyle["textPlacement"] as String),
                textOffset = LogicalPixel((textStyle["textOffset"] as Double).toFloat(),),
        )
    }
}
