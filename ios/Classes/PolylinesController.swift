import DGis;
import Flutter;

class PolylinesController {
    let layerId: String?;
    private let sdk: DGis.Container;
    private let methodChannel: FlutterMethodChannel;
    private let map: DGis.Map;
    private let objectManager: MapObjectManager;
    
    private var polylinesWithId: Dictionary<String, Polyline> = [:];
    private var polylinesWithNoId: Array<Polyline> = [];
    
    init(layerId: String? = nil, map: DGis.Map, sdk: DGis.Container, methodChannel: FlutterMethodChannel, objectManager: MapObjectManager) {
        self.layerId = layerId
        self.map = map
        self.sdk = sdk
        self.methodChannel = methodChannel;
        self.objectManager = objectManager;
    }
    
    func getAllPolylines() -> Array<Polyline> {
        return self.polylinesWithNoId + self.polylinesWithId.map{ $0.value };
    }
    
    func addPolylines(polylines: Array<Any>) {
        var newPolylines = Array<Polyline>();
        
        for polyline in polylines {
            newPolylines.append(
                _processNewPolyline(polyline: polyline)
            );
        }
        
        NSLog("Adding polylines on \(layerId ?? "")")
        
        self.objectManager.addObjects(objects: newPolylines);
    }
    
    private func _processNewPolyline(polyline: Any) -> Polyline {
        let polylineId = (polyline as! Dictionary<String, Any?>)["id"] as? String;
        let polyline = PolylinesUtils.getPolylineFromDart(
            polyline: polyline as! Dictionary<String, Any?>,
            sdk: self.sdk,
            layerId: self.layerId
        );
        if (polylineId != nil) {
            let oldPolyline = getById(polylineId: polylineId!)
            if (oldPolyline != nil) {
                self.objectManager.removeObject(item: oldPolyline!)
            }
            polylinesWithId[polylineId!] = polyline
        } else {
            polylinesWithNoId.append(polyline)
        }
        return polyline
    }
    
    func addPolyline(polyline: Dictionary<String, Any?>) {
        self.objectManager.addObject(item: _processNewPolyline(polyline: polyline));
    }
    
    func getAll() -> Array<Any?> {
        return self.getAllPolylines().map { ($0.userData as! MapObjectUserData).userData };
    }
    
    func getById(polylineId: String) -> Polyline? {
        return self.polylinesWithId[polylineId];
    }
    
    func removePolylineById(polylineId: String) {
        let polyline = getById(polylineId: polylineId)
        if polyline != nil {
            self.objectManager.removeObject(item: polyline!);
            self.polylinesWithId.removeValue(forKey: polylineId);
        } else {
            NSLog("DGis: polyline with given id \(polylineId) isn't exists");
        }
    }
    
    func removeAll() {
        self.objectManager.removeAll();
        self.polylinesWithId = [:];
        self.polylinesWithNoId = [];
    }
    
    func update(polylineId: String, newPolyline: Dictionary<String, Any?>) {
        removePolylineById(polylineId: polylineId);
        addPolyline(polyline: newPolyline);
    }
}
