package jyahann.dgis_map_kit

import android.annotation.TargetApi
import android.os.Build
import android.os.Handler
import android.os.Looper
import io.flutter.Log
import io.flutter.plugin.common.MethodChannel
import ru.dgis.sdk.map.SimpleClusterObject
import ru.dgis.sdk.map.SimpleClusterOptions
import ru.dgis.sdk.map.SimpleClusterRenderer
import java.util.concurrent.CompletableFuture

class ClusterRenderer(methodChannel: MethodChannel, markersUtils: MarkersUtils) :
        SimpleClusterRenderer {
    private var methodChannel: MethodChannel
    private var markersUtils: MarkersUtils

    init {
        this.methodChannel = methodChannel
        this.markersUtils = markersUtils
    }

    override fun renderCluster(cluster: SimpleClusterObject): SimpleClusterOptions {
        val markers: MutableList<Any?> = ArrayList()
        for (dgisObject in cluster.objects) {
            var mapUserData = dgisObject.userData as MapObjectUserData

            markers.add(mapUserData.userData)
        }

        var result = ClusterRenderResult(markersUtils, markers)

        Handler(Looper.getMainLooper()).post {
            methodChannel.invokeMethod("cluster#render", markers, result)
        }

        return result.completableClusterOptions.get()
    }
}

@TargetApi(Build.VERSION_CODES.N)
class ClusterRenderResult(markersUtils: MarkersUtils, markers: List<Any?>) : MethodChannel.Result {
    var completableClusterOptions = CompletableFuture<SimpleClusterOptions>()

    private var markersUtils: MarkersUtils
    private var markers: List<Any?>

    init {
        this.markersUtils = markersUtils
        this.markers = markers
    }

    override fun error(errorCode: String, errorMessage: String?, errorDetails: Any?): Unit {}

    override fun success(result: Any?): Unit {
        completableClusterOptions.complete(
                markersUtils.getClusterOptionsFromDart(
                        result as Map<String, Any>,
                        markers,
                )
        )
    }

    override fun notImplemented(): Unit {}
}
