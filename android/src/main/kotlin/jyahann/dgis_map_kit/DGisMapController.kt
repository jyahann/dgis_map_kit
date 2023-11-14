package jyahann.dgis_map_kit

import DGisMapConfig
import android.content.Context
import android.content.res.Resources.NotFoundException
import android.view.View
import com.example.dgis_flutter.MyLocationSource
import io.flutter.Log
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.platform.PlatformView
import ru.dgis.sdk.map.MapView
import ru.dgis.sdk.navigation.NavigationManager
import java.util.concurrent.CompletableFuture

class DGisMapController(
        context: Context,
        id: Int,
        mapConfig: DGisMapConfig,
        binaryMessenger: BinaryMessenger
) : PlatformView, MethodChannel.MethodCallHandler {

    private var gisView: MapView
    private var map: CompletableFuture<ru.dgis.sdk.map.Map>
    private var sdkContext: ru.dgis.sdk.Context
    private var mapConfig: DGisMapConfig
    private var methodChannel: MethodChannel
    private var markersControllerBuilders: MutableList<MarkersControllerBuilder>
    private var cameraControllerBuilder: CameraControllerBuilder

    override fun getView(): View {
        return gisView
    }

    override fun dispose() {}

    init {
        this.sdkContext = initializeDGis(context, mapConfig.token)
        this.gisView = MapView(context)
        if (mapConfig.theme == "LIGHT") {
            gisView.setTheme("day")
        }

        this.map = CompletableFuture<ru.dgis.sdk.map.Map>()
        this.mapConfig = mapConfig
        this.markersControllerBuilders = ArrayList()
        this.cameraControllerBuilder = CameraControllerBuilder()
        this.methodChannel =
                MethodChannel(
                        binaryMessenger,
                        "plugins.jyahann/dgis_map_$id",
                )
        if (mapConfig.enableMyLocation) {
            registerPlatformLocationSource(sdkContext, MyLocationSource(context, methodChannel))
        }

        methodChannel.setMethodCallHandler(this)
        gisView.getMapAsync(::onMapReady)
    }

    fun onMapReady(map: ru.dgis.sdk.map.Map) {
        this.map.complete(map)

        var controller = createSmoothMyLocationController()
        gisView.setTouchEventsObserver(
            DGisMapTouchEventObserver(map, methodChannel)
        )

        cameraControllerBuilder.build(
            map = map,
            methodChannel = methodChannel,
            initialCameraPosition = mapConfig.initialCameraPosition,
        )

        for (layer in mapConfig.layers) {
            if (layer["isClusterer"] as Boolean) {
                addLayerWithClustering(layer["layer"] as Map<String, Any?>)
            } else {
                addLayer((layer["layer"] as Map<String, String?>)["layerId"])
            }
        }

        methodChannel.invokeMethod("map#isReady", null);
    }

    fun addLayer(layerId: String? = null) {
        var markersControllerBuilder = MarkersControllerBuilder(layerId)
        map.whenComplete { map, _ ->
            markersControllerBuilder.build(
                map = map,
                sdkContext = this.sdkContext,
                methodChannel = this.methodChannel,
            )
        }
        markersControllerBuilders.add(markersControllerBuilder)
    }

    fun addLayerWithClustering(layerConfig: Map<String, Any?>) {
        var markersControllerBuilder = MarkersControllerBuilder(
            getMethodArgument(layerConfig, "layerId")
        )
        map.whenComplete { map, _ ->
            markersControllerBuilder.buildWithClustering(
                map = map,
                sdkContext = this.sdkContext,
                methodChannel = this.methodChannel,
                layerConfig = layerConfig
            )
        }
        markersControllerBuilders.add(markersControllerBuilder)
    }

    fun removeLayer(layerId: String?) {
        val iterator: MutableIterator<MarkersControllerBuilder> = markersControllerBuilders.iterator()
        while (iterator.hasNext()) {
            val value = iterator.next()
            if (value.layerId == layerId) {
                value.close()
                iterator.remove()
            }
        }
    }

    fun getMarkersControllerBuilder(layerId: String? = null) : MarkersControllerBuilder {
        for (markersControllerBuilder in markersControllerBuilders) {
            if (markersControllerBuilder.layerId == layerId) {
                return markersControllerBuilder
            }
        }

        throw NotFoundException()
    }

    fun <T> getMethodArgument(args: Any, argName: String) : T {
        return (args as Map<String, Any?>)[argName] as T
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        val args = call.arguments
        try {
            when (call.method) {
                "map#addLayer" -> {
                    addLayer(getMethodArgument(args, "layerId"))
                    result.success(null)
                }
                "map#addLayerWithClustering" -> {
                    addLayerWithClustering(args as Map<String, Any?>)
                    result.success(null)
                }
                "map#removeLayer" -> {
                    removeLayer(getMethodArgument(args, "layerId"))
                    result.success(null)
                }
                "camera#move" -> {
                    cameraControllerBuilder.controller.get()
                        .moveCamera(call.arguments as Map<String, Any>)
                    result.success(null)
                }
                "markers#addMarkers" -> {
                    var layerId = getMethodArgument<String?>(args, "layerId")
                    var markers = getMethodArgument<List<Any>>(args, "markers")
                    getMarkersControllerBuilder(layerId).controller.get()
                        .addMarkers(markers)
                    result.success(null)
                }
                "markers#addMarker" -> {
                    var layerId = getMethodArgument<String?>(args, "layerId")
                    var marker = getMethodArgument<Map<String, Any?>>(args, "marker")
                    getMarkersControllerBuilder(layerId).controller.get()
                        .addMarker(marker)
                    result.success(null)
                }
                "markers#getAll" -> {
                    var layerId = getMethodArgument<String?>(args, "layerId")
                    result.success(getMarkersControllerBuilder(layerId).controller.get().getAll())
                }
                "markers#getById" -> {
                    var layerId = getMethodArgument<String?>(args, "layerId")
                    var markerId = getMethodArgument<String>(args, "markerId")
                    var marker = getMarkersControllerBuilder(layerId).controller.get().getById(markerId)
                    result.success((marker?.userData as MapObjectUserData).userData)
                }
                "markers#removeAll" -> {
                    var layerId = getMethodArgument<String?>(args, "layerId")
                    getMarkersControllerBuilder(layerId).controller.get().removeAll()
                    result.success(null)
                }
                "markers#removeById" -> {
                    var layerId = getMethodArgument<String?>(args, "layerId")
                    var markerId = getMethodArgument<String>(args, "markerId")
                    getMarkersControllerBuilder(layerId).controller.get().removeMarkerById(markerId)
                    result.success(null)
                }
                "markers#update" -> {
                    var layerId = getMethodArgument<String?>(args, "layerId")
                    var markerId = getMethodArgument<String>(args, "markerId")
                    var marker = getMethodArgument<Map<String, Any?>>(args, "newMarker")
                    getMarkersControllerBuilder(layerId).controller.get().update(markerId, marker)
                    result.success(null)
                }
            }
        }
        catch (ex: Exception) {
            Log.d(
                "DGIS",
                "Error on method call: $ex ${ex.message}"
            )

            result.error(ex.toString(), ex.message, null)
        }
    }
}
