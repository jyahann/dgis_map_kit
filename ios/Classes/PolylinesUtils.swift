import DGis
import Flutter

class PolylinesUtils {
    static func getPolylineFromDart(
        polyline: Dictionary<String, Any?>,
        sdk: DGis.Container,
        layerId: String?
    ) -> Polyline? {
        var dashedOptions: DashedPolylineOptions?;
        var gradientOptions: GradientPolylineOptions?;
        
        if polyline["dashedPolylineOptions"] != nil {
            dashedOptions = getDashedPolylineOptionsFromDart(dashedPolylineOptions: polyline["dashedPolylineOptions"] as! Dictionary<String, Any>)
        } else if polyline["gradientPolylineOptions"] != nil {
            gradientOptions = getGradientPolylineOptionsFromDart(gradientPolylineOptions: polyline["gradientPolylineOptions"] as! Dictionary<String, Any>)
        }
        
        
        let options = PolylineOptions(
            points: (polyline["points"] as? Array<Any?>)!.map { CameraUtils.getGeoPointFromDart(coordinates: $0 as! Dictionary<String, Any>) },
            width: LogicalPixel(value: Float(polyline["width"] as! Double)),
            color: Color(argb: UInt32(polyline["color"] as! Int)),
            erasedPart: polyline["erasedPart"] as! Double,
            dashedPolylineOptions: dashedOptions,
            gradientPolylineOptions: gradientOptions,
            visible: polyline["visible"] as! Bool,
            userData: polyline,
            zIndex: ZIndex(value: UInt32(polyline["zIndex"] as! Int))
        );
        
        do {
            return try Polyline(options: options);
        } catch {
            return nil
        }
    }
    
    static func getDashedPolylineOptionsFromDart(dashedPolylineOptions: Dictionary<String, Any>) -> DashedPolylineOptions {
        return DashedPolylineOptions(
            dashLength: LogicalPixel(value: Float(dashedPolylineOptions["dashLength"] as! Double)),
            dashSpaceLength: LogicalPixel(value: Float(dashedPolylineOptions["dashSpaceLength"] as! Double))
        );
    }
    
    static func getGradientPolylineOptionsFromDart(gradientPolylineOptions: Dictionary<String, Any>) -> GradientPolylineOptions {
        let intColors = gradientPolylineOptions["colors"] as! Array<Int>;
        let colors = intColors.map { Color(argb: UInt32($0)) };
        return GradientPolylineOptions(
            borderWidth: LogicalPixel(value: Float(gradientPolylineOptions["borderWidth"] as! Double)),
            secondBorderWidth: LogicalPixel(value: Float(gradientPolylineOptions["secondBorderWidth"] as! Double)),
            gradientLength: LogicalPixel(value: Float(gradientPolylineOptions["gradientLength"] as! Double)),
            borderColor: Color(argb: UInt32(gradientPolylineOptions["borderColor"] as! Int)),
            secondBorderColor: Color(argb: UInt32(gradientPolylineOptions["secondBorderColor"] as! Int)),
            colors: colors,
            colorIndices: getColorIndices(colorStops: gradientPolylineOptions["colorStops"] as! Array<Int>)
        )
    }
    
    static func getColorIndices(colorStops: Array<Int>) -> Data {
        var sortedKeys = colorStops.sorted()
        var count = sortedKeys.last!;
        var colorIndices = Data(count: count)
        var colorStopIndex = 0
        var indexes = Array<UInt8>()
        for index in 0...count {
            var key = sortedKeys[index]
            if colorStops[colorStopIndex] < index {
                colorIndices.append(contentsOf: indexes)
                indexes = Array<UInt8>()
                colorStopIndex += 1
            }
            indexes.append(UInt8(index))
        }
        return colorIndices
    }
    
    static func getMapDirectionFromDart(value: Any?) -> MapDirection? {
        if (value is NSNull) {
            return nil;
        }
        return MapDirection(
            value: value as! Double
        );
    }
    
    static func getAnchorFromDart(anchor: Dictionary<String, Any>) -> Anchor {
        return Anchor(
            x: Float(anchor["x"] as! Double),
            y: Float(anchor["y"] as! Double)
        )
    }
}
