package jyahann.dgis_map_kit

enum class MapObjectUserDataType {
    MARKER,
    CLUSTER
}

class MapObjectUserData(type: MapObjectUserDataType, userData: Any?, layerId: String?) {
    var type: MapObjectUserDataType;
    var userData: Any?;
    var layerId: String?;

    init {
        this.type = type
        this.layerId = layerId
        this.userData = userData
    }
}
