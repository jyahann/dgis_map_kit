package jyahann.dgis_map_kit

import android.content.Context
import android.view.View
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.platform.PlatformView
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import ru.dgis.sdk.map.MapObjectManager
import ru.dgis.sdk.map.MapView

class DGisMapController(
    context: Context,
    id: Int,
    token: String,
    binaryMessenger: BinaryMessenger
) : PlatformView,
    MethodChannel.MethodCallHandler {

    private var gisView: MapView
    private var sdkContext: ru.dgis.sdk.Context
    private var methodChannel: MethodChannel
    private var markersController: MarkersController

    override fun getView(): View {
        return gisView
    }

    override fun dispose() {}

    init {
        sdkContext = initializeDGis(context, token)
        gisView = MapView(context)
        methodChannel = MethodChannel(binaryMessenger, "plugins.jyahann/dgis_map_$id")
        methodChannel.setMethodCallHandler(this)
        markersController = MarkersController(gisView, sdkContext)
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "map#addMarkers" -> {
                val args = call.arguments
                markersController.addMarkers(args as List<Any>)
            }
        }
    }
}