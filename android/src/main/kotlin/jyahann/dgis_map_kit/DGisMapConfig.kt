import jyahann.dgis_map_kit.CameraUtils
import ru.dgis.sdk.map.CameraPosition

class DGisMapConfig(creationParams: Map<String?, Any?>?) {
    var token: String
    var initialCameraPosition: CameraPosition
    var layers: List<Map<String, String?>>
    var theme: String

    init {
        this.token = creationParams?.get("token") as String
        this.initialCameraPosition = CameraUtils.getCameraPositionFromDart(creationParams?.get("initialCameraPosition") as Map<String, Any>)
        this.theme = creationParams?.get("theme") as String
        this.layers = (creationParams?.get("layers") as List<Any>).map { layer -> layer as Map<String, String?> }
    }
}
