import DGis;

class CameraUtils {
    static func getCameraPositionToDart(
        cameraPosition position: CameraPosition
    ) -> Dictionary<String, Any> {
        return [
            "position": getPositionToDart(
                geoPoint: position.point
            ),
            "zoom": position.zoom.value,
            "tilt": position.tilt.value,
            "bearing": position.bearing.value
        ];
    }
    
    static func getPositionToDart(
        geoPoint point: GeoPoint
    ) -> Dictionary<String, Any> {
        return [
            "lat": point.latitude.value,
            "long": point.longitude.value
        ];
    }
    
    static func getCameraPositionFromDart(
        cameraPosition position: Dictionary<String, Any>
    ) -> CameraPosition {
        return CameraPosition(
            point: getGeoPointFromDart(
                coordinates: position["position"] as! Dictionary<String, Any>
            ),
            zoom: Zoom(
                floatLiteral: Float(position["zoom"] as! Double)
            ),
            tilt: Tilt(
                floatLiteral: Float(position["tilt"] as! Double)
            ),
            bearing: Bearing(
                floatLiteral: position["bearing"] as! Double
            )
        );
    }
    
    static func getGeoPointFromDart(
        coordinates coords: Dictionary<String, Any>
    ) -> GeoPoint {
        return GeoPoint(
            latitude: coords["lat"] as! Double,
            longitude: coords["long"] as! Double
        );
    }
}
