import DGis;
import Flutter;

class MarkersController {
    var layerId: String?;
    private var registrar: FlutterPluginRegistrar;
    private var sdk: DGis.Container;
    private var methodChannel: FlutterMethodChannel;
    private var map: DGis.Map;
    private let objectManager: MapObjectManager;
    
    private var markersWithId: Dictionary<String, Marker> = [:];
    private var markersWithNoId: Array<Marker> = [];
    
    init(layerId: String? = nil, registrar: FlutterPluginRegistrar, map: DGis.Map, sdk: DGis.Container, methodChannel: FlutterMethodChannel, objectManager: MapObjectManager) {
        self.layerId = layerId
        self.registrar = registrar
        self.map = map
        self.sdk = sdk
        self.methodChannel = methodChannel;
        self.objectManager = objectManager;
    }
    
    func getAllMarkers() -> Array<Marker> {
        return self.markersWithNoId + self.markersWithId.map{ $0.value };
    }
    
    func addMarkers(markers: Array<Any>) {
        var newMarkers = Array<Marker>();
        
        for marker in markers {
            newMarkers.append(
                _processNewMarker(marker: marker)
            );
        }
        
        NSLog("Adding markers on \(layerId ?? "")")
        
        self.objectManager.addObjects(objects: newMarkers);
    }
    
    private func _processNewMarker(marker: Any) -> Marker {
        let markerId = (marker as! Dictionary<String, Any?>)["id"] as? String;
        let marker = MarkersUtils.getMarkerFromDart(
            marker: marker as! Dictionary<String, Any?>,
            sdk: self.sdk,
            registrar: self.registrar,
            layerId: self.layerId
        );
        if (markerId != nil) {
            let oldMarker = getById(markerId: markerId!)
            if (oldMarker != nil) {
                self.objectManager.removeObject(item: oldMarker!)
            }
            markersWithId[markerId!] = marker
        } else {
            markersWithNoId.append(marker)
        }
        return marker
    }
    
    func addMarker(marker: Dictionary<String, Any?>) {
        self.objectManager.addObject(item: _processNewMarker(marker: marker));
    }
    
    func getAll() -> Array<Any?> {
        return self.getAllMarkers().map { ($0.userData as! MapObjectUserData).userData };
    }
    
    func getById(markerId: String) -> Marker? {
        return self.markersWithId[markerId];
    }
    
    func removeMarkerById(markerId: String) {
        let marker = getById(markerId: markerId)
        if marker != nil {
            self.objectManager.removeObject(item: marker!);
            self.markersWithId.removeValue(forKey: markerId);
        } else {
            NSLog("DGis: marker with given id \(markerId) isn't exists");
        }
    }
    
    func removeAll() {
        self.objectManager.removeAll();
    }
    
    func update(markerId: String, newMarker: Dictionary<String, Any?>) {
        removeMarkerById(markerId: markerId);
        addMarker(marker: newMarker);
    }
}
