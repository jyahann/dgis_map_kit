package jyahann.dgis_map_kit

import dev.flutter.example.DGisMapViewFactory
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodChannel

/** DGisMapKitPlugin */
class DgisMapKitPlugin : FlutterPlugin {
  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  private lateinit var channel: MethodChannel

  override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    val messenger: BinaryMessenger = flutterPluginBinding.binaryMessenger
    flutterPluginBinding.platformViewRegistry.registerViewFactory(
        "plugins.jyahann/dgis_map",
        DGisMapViewFactory(messenger)
    )
  }

  override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {}
}
