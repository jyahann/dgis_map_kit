import Flutter

class MapboxMapFactory: NSObject, FlutterPlatformViewFactory {
    var registrar: FlutterPluginRegistrar
    
    init(withRegistrar registrar: FlutterPluginRegistrar) {
        self.registrar = registrar
        super.init()
    }
    
    func createArgsCodec() -> FlutterMessageCodec & NSObjectProtocol {
        return FlutterStandardMessageCodec.sharedInstance()
    }
    
    func create(
        withFrame frame: CGRect,
        viewIdentifier viewId: Int64,
        arguments args: Any?
    ) -> FlutterPlatformView {
        return DGisMapController(
            withFrame: frame,
            viewIdentifier: viewId,
            withRegistrar: registrar, 
            mapConfig: DGisMapConfig(
                arguments: args! as! Dictionary<String?, Any?>
            )
        )
    }
}
