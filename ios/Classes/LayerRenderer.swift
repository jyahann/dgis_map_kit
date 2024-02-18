import DGis;
import Flutter;

final class LayerRenderer: SimpleClusterRenderer {
    private var methodChannel: FlutterMethodChannel;
    private var registrar: FlutterPluginRegistrar;
    private var sdk: DGis.Container;
    private var layerId: String?;
    private var imageFactory: IImageFactory
    
    init(methodChannel: FlutterMethodChannel, registrar: FlutterPluginRegistrar, sdk: DGis.Container, layerId: String? = nil, imageFactory: IImageFactory) {
        self.methodChannel = methodChannel
        self.registrar = registrar
        self.sdk = sdk
        self.layerId = layerId
        self.imageFactory = imageFactory
    }
    
    func renderCluster(cluster: SimpleClusterObject) -> SimpleClusterOptions {
        let object = cluster.objects.first;
        let userData = object!.userData as! MapObjectUserData;
        let marker = userData.userData as! Dictionary<String, Any?>;
        
        return MarkersUtils.getLayerOptionsFromDart(
            marker: marker, 
            sdk: sdk,
            registrar: registrar,
            layerId: layerId,
            imageFactory: imageFactory
        );
    }
}

