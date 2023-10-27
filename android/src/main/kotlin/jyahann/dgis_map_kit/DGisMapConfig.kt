import jyahann.dgis_map_kit.CameraUtils
import ru.dgis.sdk.map.CameraPosition

class DGisMapConfig(creationParams: Map<String?, Any?>?) {
    var token: String
    var isClusteringEnabled: Boolean
    var initialCameraPosition: CameraPosition

    init {
        this.token = creationParams?.get("token") as String
        this.isClusteringEnabled = creationParams?.get("isClusteringEnabled") as Boolean
        this.initialCameraPosition = CameraUtils.getCameraPositionFromDart(creationParams?.get("initialCameraPosition") as Map<String, Any>)
    }
}
