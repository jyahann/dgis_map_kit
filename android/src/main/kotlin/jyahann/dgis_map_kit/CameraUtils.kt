package jyahann.dgis_map_kit

import ru.dgis.sdk.coordinates.Bearing
import ru.dgis.sdk.coordinates.GeoPoint
import ru.dgis.sdk.map.CameraPosition
import ru.dgis.sdk.map.Tilt
import ru.dgis.sdk.map.Zoom

class CameraUtils {
    companion object {
        fun getCameraPositionToDart(
            cameraPosition: CameraPosition,
        ): Map<String, Any> {
            return mapOf(
                "position" to getPositionToDart(cameraPosition.point),
                "zoom" to cameraPosition.zoom.value,
                "tilt" to cameraPosition.tilt.value,
                "bearing" to cameraPosition.bearing.value,
            )
        }

        fun getPositionToDart(geoPoint: GeoPoint) : Map<String, Any> {
            return mapOf(
                "lat" to geoPoint.latitude.value,
                "long" to geoPoint.longitude.value,
            )
        }

        fun getCameraPositionFromDart(
            cameraPosition: Map<String, Any>,
        ): CameraPosition {
            return CameraPosition(
                point = getGeoPointFromDart(cameraPosition["position"] as Map<String, Any>),
                zoom = Zoom((cameraPosition["zoom"] as Double).toFloat()),
                tilt = Tilt((cameraPosition["tilt"] as Double).toFloat()),
                bearing = Bearing(cameraPosition["bearing"] as Double),
            )
        }

        fun getGeoPointFromDart(position: Map<String, Any>): GeoPoint {
            return GeoPoint(
                latitude = position["lat"] as Double,
                longitude = position["long"] as Double
            )
        }
    }
}