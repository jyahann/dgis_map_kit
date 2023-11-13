import DGis;
import Flutter;

class MarkersController {
    var layerId: String?;
    private var registrar: FlutterPluginRegistrar;
    private var sdk: DGis.Container;
    private var methodChannel: FlutterMethodChannel;
    private var map: DGis.Map;
    private var objectManager: MapObjectManager;
    private var gisMarkers: Array<Marker> = [];
    
    init(layerId: String? = nil, registrar: FlutterPluginRegistrar, map: DGis.Map, sdk: DGis.Container, methodChannel: FlutterMethodChannel, objectManager: MapObjectManager) {
        self.layerId = layerId
        self.registrar = registrar
        self.map = map
        self.sdk = sdk
        self.methodChannel = methodChannel;
        self.objectManager = objectManager;
    }
    
    func addMarkers(markers: Array<Any>) {
        var newMarkers = Array<Marker>();
        
        for marker in markers {
            _deleteMarkerIfExists(marker: marker as! Dictionary<String, Any>);
            newMarkers.append(
                MarkersUtils.getMarkerFromDart(
                    marker: marker as! Dictionary<String, Any>,
                    sdk: self.sdk,
                    registrar: self.registrar,
                    layerId: self.layerId
                )
            );
        }
        
        self.gisMarkers.append(contentsOf: newMarkers);
        self.objectManager.addObjects(objects: newMarkers);
    }
    
    func addMarker(marker: Dictionary<String, Any?>) {
        _deleteMarkerIfExists(marker: marker);
        let newMarker = MarkersUtils.getMarkerFromDart(
            marker: marker,
            sdk: self.sdk,
            registrar: self.registrar,
            layerId: self.layerId
        );
        
        self.gisMarkers.append(newMarker);
        self.objectManager.addObject(item: newMarker);
    }
    
    func getAll() -> Array<Any?> {
        return self.gisMarkers.map { ($0.userData as! MapObjectUserData).userData };
    }
    
    func getById(markerId: String) -> Marker? {
        let index = _getMarkerIndexById(markerId: markerId);
        if index == nil {
            return nil
        }
        return self.gisMarkers[index!];
    }
    
    func removeMarkerById(markerId: String) {
        let index = _getMarkerIndexById(markerId: markerId)
        if index != nil {
            self.objectManager.removeObject(item: self.gisMarkers[index!]);
            self.gisMarkers.remove(at: index!);
        } else {
            NSLog("DGis: marker with given id \(markerId) isn't exists")
        }
    }
    
    func removeAll() {
        self.objectManager.removeAll();
    }
    
    func update(markerId: String, newMarker: Dictionary<String, Any?>) {
        removeMarkerById(markerId: markerId);
        addMarker(marker: newMarker);
    }
    
    private func _deleteMarkerIfExists(marker: Dictionary<String, Any?>)  {
        let markerId = marker["id"] as? String;
        if markerId != nil {
            let index = _getMarkerIndexById(markerId: markerId!);
            if index != nil {
                self.objectManager.removeObject(item: self.gisMarkers[index!]);
                self.gisMarkers.remove(at: index!);
            }
        }
    }
    
    func _getMarkerIndexById(markerId: String) -> Int? {
        for (index, marker) in self.gisMarkers.enumerated() {
            if ((marker.userData as! MapObjectUserData).userData as! Dictionary<String, Any?>)["id"] as? String == markerId {
                return index;
            }
        }
        return nil;
    }
}
