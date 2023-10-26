package jyahann.dgis_map_kit

import io.flutter.plugin.common.MethodChannel
import ru.dgis.sdk.map.Map
import ru.dgis.sdk.map.ScreenDistance
import ru.dgis.sdk.map.ScreenPoint
import ru.dgis.sdk.map.TouchEventsObserver

class MarkersTouchEventObserver(
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
                }
            }
        }
        super.onTap(point)
    }
}
