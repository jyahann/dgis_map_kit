import Flutter;
import DGis;

class TouchObserver: UIView {
    private var map: DGis.Map?;
    private var methodChannel: FlutterMethodChannel?;
    
    init(frame: CGRect, map: DGis.Map, methodChannel: FlutterMethodChannel) {
        self.map = map;
        self.methodChannel = methodChannel;
        super.init(frame: frame);
        isMultipleTouchEnabled = true;
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder);
        isMultipleTouchEnabled = true;
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        NSLog("Map on touch");
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        NSLog("Map on touch");
        let location = touches.first?.location(in: self);
        
        if location != nil && self.map != nil && self.methodChannel != nil {
            tap(location: location!);
        }
    }
    
    func tap(location: CGPoint) {
        let scale = UIScreen.main.nativeScale
        let point = ScreenPoint(x: Float(location.x * scale), y: Float(location.y * scale))
        let cancel = map!.getRenderedObjects(centerPoint: point).sink(
            receiveValue: {
                infos in
                // Первый объект в массиве - самый близкий к координатам.
                guard let info = infos.first else {
                    self.methodChannel!.invokeMethod("map#onTap", arguments: nil);
                    return;
                };
                
                let userData = info.item.item.userData as! MapObjectUserData;
                let method: String?;
                
                switch userData.type {
                case .marker:
                    method = "markers#onTap";
                    break;
                case .cluster:
                    method = "cluster#onTap";
                    break;
                }
                
                self.methodChannel!.invokeMethod(
                    method!,
                    arguments: [
                        "layerId": userData.layerId,
                        "data": userData.userData
                    ]
                );
            },
            failure: { error in
                NSLog("DGis: error on getting map objects \(error)");
            }
        )
    }
    
}
