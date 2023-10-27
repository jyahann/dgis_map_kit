package jyahann.dgis_map_kit

import DGisMapConfig
import android.content.Context
import android.view.View
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.platform.PlatformView
import ru.dgis.sdk.map.MapView

class DGisMapController(
        context: Context,
        id: Int,
        mapConfig: DGisMapConfig,
        binaryMessenger: BinaryMessenger
) : PlatformView, MethodChannel.MethodCallHandler {

    private var gisView: MapView
    private var sdkContext: ru.dgis.sdk.Context
    private var methodChannel: MethodChannel
    private var markersControllerBuilder: MarkersControllerBuilder
    private var cameraControllerBuilder: CameraControllerBuilder

    override fun getView(): View {
        return gisView
    }

    override fun dispose() {}

    init {
        sdkContext = initializeDGis(context, mapConfig.token)
        gisView = MapView(context)

        methodChannel =
                MethodChannel(
                        binaryMessenger,
                        "plugins.jyahann/dgis_map_$id",
                )
        methodChannel.setMethodCallHandler(this)


        markersControllerBuilder = MarkersControllerBuilder()
        cameraControllerBuilder = CameraControllerBuilder()

        gisView.getMapAsync { map ->
            gisView.setTouchEventsObserver(
                DGisMapTouchEventObserver(map, methodChannel)
            )

            cameraControllerBuilder.build(
                map = map,
                methodChannel = methodChannel,
                initialCameraPosition = mapConfig.initialCameraPosition,
            )

            markersControllerBuilder.build(
                map = map,
                gisView = gisView,
                sdkContext = sdkContext,
                methodChannel = methodChannel,
                isClustererEnabled = mapConfig.isClusteringEnabled,
            )
        }
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "map#addMarkers" -> markersControllerBuilder.controller.get().addMarkers(call.arguments as List<Any>)
            "map#addMarker" -> markersControllerBuilder.controller.get().addMarker(call.arguments as Map<String, Any>)
            "camera#move" -> cameraControllerBuilder.controller.get().moveCamera(call.arguments as Map<String, Any>)
        }
    }
}
