package jyahann.dgis_map_kit

import android.content.Context
import android.graphics.Color
import android.view.View
import android.widget.TextView
import io.flutter.plugin.platform.PlatformView
import ru.dgis.sdk.map.MapView

internal class DGisMapView(context: Context, id: Int, creationParams: Map<String?, Any?>?) : PlatformView {
    private var gisView: MapView
    private var sdkContext: ru.dgis.sdk.Context

    override fun getView(): View {
        return gisView
    }

    override fun dispose() {}

    init {
        sdkContext = initializeDGis(context, creationParams?.get("token") as String)
        gisView = MapView(context)
    }
}