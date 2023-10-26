package jyahann.dgis_map_kit

enum class MapObjectUserDataType {
    MARKER,
    CLUSTER
}

class MapObjectUserData(type: MapObjectUserDataType, userData: Any?) {
    var type: MapObjectUserDataType;
    var userData: Any?;

    init {
        this.type = type
        this.userData = userData
    }
}
