enum MapObjectUserDataType {
    case marker;
    case cluster;
}

class MapObjectUserData {
    var type: MapObjectUserDataType;
    var userData: Any?;
    var layerId: String?;
    
    init(userDataType type: MapObjectUserDataType, userData data: Any? = nil, layerId id: String? = nil) {
        self.type = type;
        self.userData = data;
        self.layerId = id;
    }
}
