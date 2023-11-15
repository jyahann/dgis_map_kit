import DGis
import Flutter

class MarkersUtils {
    static func getClusterOptionsFromDart(
        mapClusterer: Dictionary<String, Any?>,
        sdk: DGis.Container,
        registrar: FlutterPluginRegistrar,
        markers: Array<Any>,
        layerId: String?
    ) -> SimpleClusterOptions {
        let iconOptions = mapClusterer["iconOptions"] as! Dictionary<String, Any>;
        let assetLookupKey = registrar.lookupKey(forAsset: mapClusterer["icon"] as! String);
        let image = UIImage.loadFromFile(imagePath: assetLookupKey);
        let icon = sdk.imageFactory.make(image: image!)
        
        return SimpleClusterOptions(
            icon: icon,
            iconMapDirection: getMapDirectionFromDart(
                value: iconOptions["iconMapDirection"]
            ),
            anchor: getAnchorFromDart(
                anchor: iconOptions["anchor"] as! Dictionary<String, Any>
            ),
            text: iconOptions["text"] as? String,
            textStyle: getTextStyleFromDart(
                textStyle: iconOptions["textStyle"] as! Dictionary<String, Any>
            ),
            iconOpacity: Opacity(
                value: Float(iconOptions["iconOpacity"] as! Double)
            ),            iconWidth: LogicalPixel(
                value: Float(iconOptions["size"] as! Double)
            ),
            userData: MapObjectUserData(
                userDataType: MapObjectUserDataType.cluster,
                userData: markers,
                layerId: layerId
            ),
            zIndex: ZIndex(
                value: UInt32(iconOptions["zIndex"] as! Double)
            ),
            animatedAppearance: iconOptions["animatedAppearance"] as! Bool
        );
    }
    
    static func getLayerOptionsFromDart(
        marker: Dictionary<String, Any?>,
        sdk: DGis.Container,
        registrar: FlutterPluginRegistrar,
        layerId: String?
    ) -> SimpleClusterOptions {
        let iconOptions = marker["iconOptions"] as! Dictionary<String, Any>;
        let assetLookupKey = registrar.lookupKey(forAsset: marker["icon"] as! String);
        let image = UIImage.loadFromFile(imagePath: assetLookupKey);
        let icon = sdk.imageFactory.make(image: image!)
        
        return SimpleClusterOptions(
            icon: icon,
            iconMapDirection: getMapDirectionFromDart(
                value: iconOptions["iconMapDirection"]
            ),
            anchor: getAnchorFromDart(
                anchor: iconOptions["anchor"] as! Dictionary<String, Any>
            ),
            text: iconOptions["text"] as? String,
            textStyle: getTextStyleFromDart(
                textStyle: iconOptions["textStyle"] as! Dictionary<String, Any>
            ),
            iconOpacity: Opacity(
                value: Float(iconOptions["iconOpacity"] as! Double)
            ),            iconWidth: LogicalPixel(
                value: Float(iconOptions["size"] as! Double)
            ),
            userData: MapObjectUserData(
                userDataType: MapObjectUserDataType.marker,
                userData: marker,
                layerId: layerId
            ),
            zIndex: ZIndex(
                value: UInt32(iconOptions["zIndex"] as! Double)
            ),
            animatedAppearance: iconOptions["animatedAppearance"] as! Bool
        );
    }
    
    static func getMarkerFromDart(
        marker: Dictionary<String, Any?>,
        sdk: DGis.Container,
        registrar: FlutterPluginRegistrar,
        layerId: String?
    ) -> Marker {
        let iconOptions = marker["iconOptions"] as! Dictionary<String, Any>;
        let assetLookupKey = registrar.lookupKey(forAsset: marker["icon"] as! String);
        let image = UIImage.loadFromFile(imagePath: assetLookupKey);
        let icon = sdk.imageFactory.make(image: image!)
        
        let options = MarkerOptions(
            position: GeoPointWithElevation(
                point: CameraUtils.getGeoPointFromDart(
                    coordinates: marker["position"] as! Dictionary<String, Any>
                ),
                elevation: Elevation(marker["elevation"] as! Double)
            ),
            icon: icon,
            iconMapDirection: getMapDirectionFromDart(
                value: iconOptions["iconMapDirection"]
            ), 
            anchor: getAnchorFromDart(
                anchor: iconOptions["anchor"] as! Dictionary<String, Any>
            ),
            text: iconOptions["text"] as? String,
            textStyle: getTextStyleFromDart(
                textStyle: iconOptions["textStyle"] as! Dictionary<String, Any>
            ),
            iconOpacity: Opacity(
                value: Float(iconOptions["iconOpacity"] as! Double)
            ),
            visible: true,
            draggable: false,
            iconWidth: LogicalPixel(
                value: Float(iconOptions["size"] as! Double)
            ),
            userData: MapObjectUserData(
                userDataType: MapObjectUserDataType.marker,
                userData: marker,
                layerId: layerId
            ),
            zIndex: ZIndex(
                value: UInt32(iconOptions["zIndex"] as! Double)
            ),
            animatedAppearance: iconOptions["animatedAppearance"] as! Bool
        );
        
        return Marker(options: options);
    }
    
    static func getTextStyleFromDart(textStyle: Dictionary<String, Any>) -> TextStyle {
        return TextStyle(
            fontSize: LogicalPixel(
                value: Float(textStyle["fontSize"] as! Double)
            ),
            color: Color(
                argb: UInt32(textStyle["color"] as! Double)
            ),
            strokeWidth: LogicalPixel(
                value: Float(textStyle["strokeWidth"] as! Double)
            ),
            strokeColor: Color(
                argb: UInt32(textStyle["strokeColor"] as! Double)
            ),
            textPlacement: TextPlacement.fromString(
                value: textStyle["textPlacement"] as! String
            ),
            textOffset: LogicalPixel(
                value: Float(textStyle["textOffset"] as! Double)
            )
        );
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
