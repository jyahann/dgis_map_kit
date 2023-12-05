import Flutter;
import DGis;

class DGisMapController : NSObject, FlutterPlatformView {
    private var withFrame: CGRect;
    private var viewId: Int64;
    private var registrar: FlutterPluginRegistrar;
    private var mapConfig: DGisMapConfig;
    private var mapFactory: IMapFactory?;
    private var map: DGis.Map;
    private var mapView: DGis.IMapView;
    private static var sdk: DGis.Container?;
    private var methodChannel: FlutterMethodChannel;
    private var markersControllers: Array<MarkersController> = [];
    private var cameraController: CameraController;
    private var cameraStateCancellable: Cancellable?;
    private var renderedObjectsCancellable: Cancellable?;
    
    init(
        withFrame frame: CGRect,
        viewIdentifier viewId: Int64,
        withRegistrar registrar: FlutterPluginRegistrar,
        mapConfig cnfg: DGisMapConfig
    ) {
        self.withFrame = frame;
        self.viewId = viewId;
        self.registrar = registrar;
        self.mapConfig = cnfg;
        
        //        let filePath = NSHomeDirectory() + "dgismaptoken.key"
        //        if let data = self.mapConfig.token.data(using: .utf8) {
        //            FileManager.default.createFile(atPath: filePath, contents: data, attributes: nil)
        //        }
        
        //var apiKeyOptions = ApiKeyOptions(apiKeyFile: File(path: filePath));
        if DGisMapController.sdk == nil {
            let apiKeys = APIKeys(directory: "dir", map: self.mapConfig.token);
            DGisMapController.sdk = DGis.Container(apiKeys: apiKeys!)
        }
        
        var mapOptions = MapOptions.default;
        //mapOptions.devicePPI = DevicePpi(value: 460.0);
        mapOptions.appearance = .universal(self.mapConfig.theme == "LIGHT" ? "day" : "night");
        mapOptions.position = self.mapConfig.initialCameraPosition;
        do {
            try self.mapFactory = DGisMapController.sdk!.makeMapFactory(options: mapOptions);
        } catch {
            NSLog("Error on declaring DGis map factory");
        }
        
        self.methodChannel = FlutterMethodChannel(
            name: "plugins.jyahann/dgis_map_\(viewId)",
            binaryMessenger: registrar.messenger()
        )
        self.map = self.mapFactory!.map;
        self.mapView = self.mapFactory!.mapView;
        self.cameraController = CameraController(map: self.map, methodChannel: self.methodChannel);
        
        super.init();
        
        self.cameraStateCancellable = self.map.camera.stateChannel.sink { state in
            DispatchQueue.main.async {
                self.methodChannel.invokeMethod(
                    "camera#onMove",
                    arguments: CameraUtils.getCameraPositionToDart(
                        cameraPosition: self.map.camera.position
                    )
                );
            }
        }
        
        let singleTapGesture = UITapGestureRecognizer(target: self, action: #selector(self.singleTap(_:)))
        singleTapGesture.numberOfTapsRequired = 1;
        self.mapView.addGestureRecognizer(singleTapGesture);
        
        let doubleTapGesture = UITapGestureRecognizer(target: self, action: #selector(doubleTap(_:)))
        doubleTapGesture.numberOfTapsRequired = 2
        self.mapView.addGestureRecognizer(doubleTapGesture)

        singleTapGesture.require(toFail: doubleTapGesture)
        
        
        for layer in self.mapConfig.layers {
            if layer["isClusterer"] as! Bool {
                addLayerWithClustering(layerConfig: layer["layer"] as! Dictionary<String, Any?>);
            } else {
                addLayer(layerId: (layer["layer"] as! Dictionary<String, String?>)["layerId"] as? String);
            }
        }
        
        self.methodChannel
            .setMethodCallHandler {
                [weak self] in self?.onMethodCall(methodCall: $0, result: $1)
            }
        self.methodChannel.invokeMethod("map#isReady", arguments: nil);
        
    }
    
    @objc func singleTap(_ sender: UITapGestureRecognizer? = nil) {
        let location = sender?.location(in: self.mapView);
        
        if location != nil {
            self.tap(location: location!);
        }
    }
    
    @objc func doubleTap(_ sender: UITapGestureRecognizer? = nil) {
        // not implemented
    }
    
    func mapOnTap(point:ScreenPoint) {
        DispatchQueue.main.async {
            let geoPoint = self.map.camera.projection.screenToMap(point: point);
            self.methodChannel.invokeMethod(
                "map#onTap",
                arguments: CameraUtils.getPositionToDart(geoPoint: geoPoint!)
            );
        }
    }
    
    func tap(location: CGPoint) {
        let scale = UIScreen.main.nativeScale
        let point = ScreenPoint(x: Float(location.x * scale), y: Float(location.y * scale))
        let cancel = self.map.getRenderedObjects(centerPoint: point).sink(
            receiveValue: {
                infos in                // Первый объект в массиве - самый близкий к координатам.
                guard let info = infos.first else {
                    self.mapOnTap(point: point);
                    return;
                };
                
                let userData = info.item.item.userData as? MapObjectUserData;
                if userData == nil {
                    self.mapOnTap(point: point);
                    return;
                }
                let method: String?;
                
                switch userData!.type {
                case .marker:
                    method = "markers#onTap";
                    break;
                case .cluster:
                    method = "cluster#onTap";
                    break;
                }
                
                DispatchQueue.main.async {
                    self.methodChannel.invokeMethod(
                        method!,
                        arguments: [
                            "layerId": userData!.layerId,
                            "data": userData!.userData
                        ]
                    );
                }
            },
            failure: { error in
                NSLog("DGis: error on getting map objects \(error)");
            }
        )
        self.renderedObjectsCancellable = cancel;
    }
    
    
    func addLayer(layerId: String? = nil) {
        self.markersControllers.append(
            MarkersController(
                layerId: layerId,
                registrar: self.registrar,
                map: self.map,
                sdk: DGisMapController.sdk!,
                methodChannel: self.methodChannel,
                objectManager: MapObjectManager.withClustering(
                    map: map,
                    logicalPixel: LogicalPixel(value: 0.5),
                    maxZoom: Zoom(value: 0.0),
                    clusterRenderer: LayerRenderer(
                        methodChannel: self.methodChannel,
                        registrar: self.registrar,
                        sdk: DGisMapController.sdk!,
                        layerId: layerId
                    ),
                    layerId: layerId
                )
            )
        );
    }
    
    func addLayerWithClustering(layerConfig: Dictionary<String, Any?>) {
        let layerId = layerConfig["layerId"] as? String;
        self.markersControllers.append(
            MarkersController(
                layerId: layerId,
                registrar: self.registrar,
                map: self.map,
                sdk: DGisMapController.sdk!,
                methodChannel: self.methodChannel,
                objectManager: MapObjectManager.withClustering(
                    map: map,
                    logicalPixel: LogicalPixel(
                        value: Float(layerConfig["minDistance"] as! Double)
                    ),
                    maxZoom: Zoom(
                        value: Float(layerConfig["maxZoom"] as! Double)
                    ),
                    clusterRenderer: ClusterRenderer(
                        methodChannel: self.methodChannel,
                        registrar: self.registrar,
                        sdk: DGisMapController.sdk!,
                        layerId: layerId
                    ),
                    layerId: layerId
                )
            )
        );
    }
    
    
    func removeLayer(layerId: String?) {
        for (index, controller) in self.markersControllers.enumerated() {
            if controller.layerId == layerId {
                self.markersControllers.remove(at: index);
            }
        }
    }
    
    func getMarkersController(layerId: String?, onExists: @escaping (MarkersController) -> Void) {
        for controller in self.markersControllers {
            if controller.layerId == layerId {
                onExists(controller);
            }
        }
    }
    
    func getMethodArgument<T>(args: Any, argName: String) -> T? {
        return (args as! Dictionary<String, Any?>)[argName] as? T;
    }
    
    func view() -> UIView {
        return self.mapView;
    }
    
    func onMethodCall(methodCall: FlutterMethodCall, result: @escaping FlutterResult) {
        let args = methodCall.arguments;
        var isSuccess = true;
        
        switch methodCall.method {
        case "map#addLayer":
            addLayer(layerId: getMethodArgument(args: args!, argName: "layerId"));
            break;
        case "map#addLayerWithClustering":
            addLayerWithClustering(layerConfig: args as! Dictionary<String, Any?>);
            break;
        case "map#removeLayer":
            removeLayer(layerId: getMethodArgument(args: args!, argName: "layerId"));
            break;
        case "map#setTheme":
            let theme: String? = getMethodArgument(args: args!, argName: "theme");
            self.mapView.appearance = .universal(theme == "LIGHT" ? "day" : "night");
            break;
        case "camera#move":
            self.cameraController.moveCamera(cameraPosition: args as! Dictionary<String, Any>)
            break;
        case "markers#addMarkers":
            let layerId: String? = getMethodArgument(args: args!, argName: "layerId");
            let markers: Array<Any> = getMethodArgument(args: args!, argName: "markers")!;
            getMarkersController(
                layerId: layerId,
                onExists: { $0.addMarkers(markers: markers) }
            );
            break;
        case "markers#addMarker":
            let layerId: String? = getMethodArgument(args: args!, argName: "layerId");
            let marker: Dictionary<String, Any?> = getMethodArgument(args: args!, argName: "marker")!;
            getMarkersController(
                layerId: layerId,
                onExists: { $0.addMarker(marker: marker) }
            );
            break;
        case "getAll":
            let layerId: String? = getMethodArgument(args: args!, argName: "layerId");
            getMarkersController(layerId: layerId, onExists: { result($0.getAll()) })
            break;
        case "markers#getById":
            let layerId: String? = getMethodArgument(args: args!, argName: "layerId");
            let markerId: String = getMethodArgument(args: args!, argName: "markerId")!;
            getMarkersController(layerId: layerId, onExists: { result($0.getById(markerId: markerId)) });
            break;
        case "markers#removeById":
            let layerId: String? = getMethodArgument(args: args!, argName: "layerId");
            let markerId: String = getMethodArgument(args: args!, argName: "markerId")!;
            getMarkersController(layerId: layerId, onExists: { $0.removeMarkerById(markerId: markerId) });
            break;
        case "markers#removeAll":
            let layerId: String? = getMethodArgument(args: args!, argName: "layerId");
            getMarkersController(layerId: layerId, onExists: { $0.removeAll() });
            break;
        case "markers#update":
            let layerId: String? = getMethodArgument(args: args!, argName: "layerId");
            let markerId: String = getMethodArgument(args: args!, argName: "markerId")!;
            let marker: Dictionary<String, Any?> = getMethodArgument(args: args!, argName: "newMarker")!;
            getMarkersController(layerId: layerId, onExists: { $0.update(markerId: markerId, newMarker: marker) });
            break;
        default:
            result(FlutterMethodNotImplemented);
            isSuccess = false;
        }
        if isSuccess {
            result(nil);
        }
    }
}
