package dev.flutter.example

import DGisMapConfig
import android.content.Context
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.StandardMessageCodec
import io.flutter.plugin.platform.PlatformView
import io.flutter.plugin.platform.PlatformViewFactory
import jyahann.dgis_map_kit.DGisMapController

class DGisMapViewFactory(messenger: BinaryMessenger) :
        PlatformViewFactory(StandardMessageCodec.INSTANCE) {
    private var messenger: BinaryMessenger

    init {
        this.messenger = messenger
    }

    override fun create(context: Context, viewId: Int, args: Any?): PlatformView {
        val creationParams = args as Map<String?, Any?>?

        return DGisMapController(
                context,
                viewId,
                DGisMapConfig(creationParams),
                messenger,
        )
    }
}
