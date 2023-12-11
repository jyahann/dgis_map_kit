//import DGis
//import Flutter
//
//class PolylinesUtils {
//    static func getPolylineFromDart(
//        polyline: Dictionary<String, Any?>,
//        sdk: DGis.Container,
//        layerId: String?
//    ) -> Marker {
//        let options = PolylineOptions(
//            points: (polyline["points"] as? Array<Any?>)!.map { CameraUtils.getGeoPointFromDart(coordinates: $0 as! Dictionary<String, Any>) },
//            width: LogicalPixel(value: Float(polyline["width"] as! Double)),
//            color: Color(argb: UInt32(polyline["color"] as! Int)),
//            erasedPart: polyline["erasedPart"] as! Double,
//            dashedPolylineOptions: DashedPolylineOptions?,
//            gradientPolylineOptions: GradientPolylineOptions?,
//            visible: <#T##Bool#>,
//            userData: polyline,
//            zIndex: ZIndex(value: <#T##UInt32#>)
//        );
//        
//        return Marker(options: options);
//            } as! [GeoPoint]
//    
//    static func getDashedPolylineOptionsFromDart(dashedPolylineOptions: Dictionary<String, Any>) -> DashedPolylineOptions {
//        return DashedPolylineOptions(
//            dashLength: LogicalPixel(value: Float(dashedPolylineOptions["dashLength"] as! Double)),
//            dashSpaceLength: LogicalPixel(value: Float(dashedPolylineOptions["dashSpaceLength"] as! Double))
//        );
//    }
//    
//    static func getGradientPolylineOptionsFromDart(gradientPolylineOptions: Dictionary<String, Any>) -> GradientPolylineOptions {
//        let intColors = gradientPolylineOptions["colors"] as! Array<Int>;
//        let colors = intColors!.map { Color(argb: UInt32($0)) };
//        return GradientPolylineOptions(
//            borderWidth: LogicalPixel(value: Float(gradientPolylineOptions["borderWidth"] as! Double)),
//            secondBorderWidth: LogicalPixel(value: Float(gradientPolylineOptions["secondBorderWidth"] as! Double)),
//            gradientLength: LogicalPixel(value: Float(gradientPolylineOptions["gradientLength"] as! Double)),
//            borderColor: Color(argb: UInt32(gradientPolylineOptions["borderColor"] as! Int)),
//            secondBorderColor: Color(argb: UInt32(gradientPolylineOptions["secondBorderColor"] as! Int)),
//            colors: colors,
//            colorIndices: Data()
//    }
//    
//    static func getMapDirectionFromDart(value: Any?) -> MapDirection? {
//        if (value is NSNull) {
//            return nil;
//        }
//        return MapDirection(
//            value: value as! Double
//        );
//    }
//    
//    static func getAnchorFromDart(anchor: Dictionary<String, Any>) -> Anchor {
//        return Anchor(
//            x: Float(anchor["x"] as! Double),
//            y: Float(anchor["y"] as! Double)
//        )
//    }
//}
