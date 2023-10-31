package jyahann.dgis_map_kit

import android.os.Handler
import android.os.Looper
import io.flutter.plugin.common.MethodChannel
import ru.dgis.sdk.map.SimpleClusterObject
import ru.dgis.sdk.map.SimpleClusterOptions
import ru.dgis.sdk.map.SimpleClusterRenderer
import java.util.concurrent.CompletableFuture

class ClusterRenderer(methodChannel: MethodChannel, sdkContext: ru.dgis.sdk.Context, layerId: String?) :
        SimpleClusterRenderer {
    private var methodChannel: MethodChannel
    private var sdkContext: ru.dgis.sdk.Context
    private var layerId: String?

    init {
        this.methodChannel = methodChannel
        this.sdkContext = sdkContext
        this.layerId = layerId;
    }

    override fun renderCluster(cluster: SimpleClusterObject): SimpleClusterOptions {
        val markers: MutableList<Any?> = ArrayList()
        for (dgisObject in cluster.objects) {
            var mapUserData = dgisObject.userData as MapObjectUserData

            markers.add(mapUserData.userData)
        }

        var result = ClusterRenderResult(sdkContext, markers, layerId)

        Handler(Looper.getMainLooper()).post {
            methodChannel.invokeMethod(
                "cluster#render",
                mapOf<String, Any?>(
                    "layerId" to layerId,
                    "data" to markers
                ),
                result
            )
        }

        return result.completableClusterOptions.get()
    }
}

class ClusterRenderResult(sdkContext: ru.dgis.sdk.Context, markers: List<Any?>, layerId: String?) : MethodChannel.Result {
    var completableClusterOptions = CompletableFuture<SimpleClusterOptions>()

    private var sdkContext: ru.dgis.sdk.Context
    private var markers: List<Any?>
    private var layerId: String?

    init {
        this.sdkContext = sdkContext
        this.markers = markers
        this.layerId = layerId
    }

    override fun error(errorCode: String, errorMessage: String?, errorDetails: Any?): Unit {}

    override fun success(result: Any?): Unit {
        completableClusterOptions.complete(
                MarkersUtils.getClusterOptionsFromDart(
                        result as Map<String, Any>,
                        markers,
                        sdkContext,
                        layerId
                )
        )
    }

    override fun notImplemented(): Unit {}
}
