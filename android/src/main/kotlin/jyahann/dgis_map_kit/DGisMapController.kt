package jyahann.dgis_map_kit

import DGisMapConfig
import android.content.Context
import android.view.View
import io.flutter.Log
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

        markersControllerBuilder =
            MarkersControllerBuilder(
                        gisView,
                        sdkContext,
                        methodChannel,
                        mapConfig.isClusteringEnabled,
                )
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "map#addMarkers" -> {
                val args = call.arguments

                markersControllerBuilder.controller.get().addMarkers(args as List<Any>)
            }
        }
    }
}
