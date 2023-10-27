package jyahann.dgis_map_kit

import io.flutter.plugin.common.MethodChannel
import ru.dgis.sdk.map.Map
import ru.dgis.sdk.map.ScreenDistance
import ru.dgis.sdk.map.ScreenPoint
import ru.dgis.sdk.map.TouchEventsObserver
import io.flutter.Log

class DGisMapTouchEventObserver(
    map: Map,
    methodChannel: MethodChannel,
) : TouchEventsObserver {
    private var map: Map
    private var methodChannel: MethodChannel

    init {
        this.map = map
        this.methodChannel = methodChannel
    }

    override fun onTap(point: ScreenPoint) {
        map.getRenderedObjects(point, ScreenDistance(1f)).onResult { renderedObjectInfos ->
            var isObject = false
            for (renderedObjectInfo in renderedObjectInfos) {
                if (renderedObjectInfo.item.item.userData != null) {
                    var mapUserData = renderedObjectInfo.item.item.userData as MapObjectUserData
                    val method: String?

                    when (mapUserData.type) {
                        MapObjectUserDataType.MARKER -> method = "markers#onTap"
                        MapObjectUserDataType.CLUSTER -> method = "cluster#onTap"
                    }

                    methodChannel.invokeMethod(
                        method,
                        mapUserData.userData
                    )

                    isObject = true
                }
            }

            var geoPoint = map.camera.projection.screenToMap(point)
            if (!isObject && geoPoint != null) {
                methodChannel.invokeMethod("map#onTap", CameraUtils.getPositionToDart(geoPoint))
            }
        }

        super.onTap(point)
    }
}
