package jyahann.dgis_map_kit

import ru.dgis.sdk.coordinates.GeoPoint
import ru.dgis.sdk.geometry.Elevation
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

class MarkersUtils {
    companion object {
        fun getMarkerFromDart(marker: Map<String, Any>, sdkContext: ru.dgis.sdk.Context, layerId: String?): Marker {
            val iconOptions = marker["iconOptions"] as Map<String, Any>
            var assetLookupKey =
                io.flutter.view.FlutterMain.getLookupKeyForAsset(marker["icon"] as String)

            return Marker(
                MarkerOptions(
                    position = GeoPointWithElevation(
                            CameraUtils.getGeoPointFromDart(
                                marker["position"] as Map<String, Any>
                            ),
                            elevation = Elevation((marker["elevation"] as Number).toFloat())
                        ),
                    icon = imageFromAsset(sdkContext, assetLookupKey),
                    anchor = getAnchorFromDart(iconOptions["anchor"] as Map<String, Any>),
                    text = iconOptions["text"] as String?,
                    zIndex = ZIndex((iconOptions["zIndex"] as Number).toInt()),
                    userData = MapObjectUserData(
                        type = MapObjectUserDataType.MARKER,
                        userData = marker,
                        layerId = layerId,
                    ),
                    iconWidth = LogicalPixel((iconOptions["size"] as Number).toFloat()),
                    textStyle =
                    getTextStyleFromDart(
                        iconOptions["textStyle"] as Map<String, Any>,
                    )
                )
            )
        }

        fun getClusterOptionsFromDart(
            mapClusterer: Map<String, Any>,
            markers: List<Any?>,
            sdkContext: ru.dgis.sdk.Context,
            layerId: String?
        ): SimpleClusterOptions {
            val iconOptions = mapClusterer["iconOptions"] as Map<String, Any>
            var assetLookupKey =
                io.flutter.view.FlutterMain.getLookupKeyForAsset(mapClusterer["icon"] as String)

            return SimpleClusterOptions(
                icon = imageFromAsset(sdkContext, assetLookupKey),
                anchor = getAnchorFromDart(iconOptions["anchor"] as Map<String, Any>),
                text = iconOptions["text"] as String?,
                zIndex = ZIndex((iconOptions["zIndex"] as Number).toInt()),
                userData =
                MapObjectUserData(
                    type = MapObjectUserDataType.CLUSTER,
                    userData = markers,
                    layerId = layerId,
                ),
                textStyle =
                getTextStyleFromDart(
                    iconOptions["textStyle"] as Map<String, Any>,
                ),
                iconWidth = LogicalPixel((iconOptions["size"] as Number).toFloat())
            )
        }

        fun getAnchorFromDart(anchor: Map<String, Any>): Anchor {
            return Anchor(x = (anchor["x"] as Number).toFloat(), y = (anchor["y"] as Number).toFloat())
        }

        fun getTextStyleFromDart(textStyle: Map<String, Any>): TextStyle {
            return TextStyle(
                fontSize = LogicalPixel((textStyle["fontSize"] as Number).toFloat()),
                color = Color((textStyle["color"] as Number).toInt()),
                strokeWidth = LogicalPixel((textStyle["strokeWidth"] as Number).toFloat()),
                strokeColor = Color((textStyle["strokeColor"] as Number).toInt()),
                textPlacement = TextPlacement.valueOf(textStyle["textPlacement"] as String),
                textOffset = LogicalPixel((textStyle["textOffset"] as Number).toFloat(),),
            )
        }
    }
}
