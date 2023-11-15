import DGis;
import Flutter;

final class ClusterRenderer: SimpleClusterRenderer {
    private var methodChannel: FlutterMethodChannel;
    private var registrar: FlutterPluginRegistrar;
    private var sdk: DGis.Container;
    private var layerId: String?;
    
    init(methodChannel: FlutterMethodChannel, registrar: FlutterPluginRegistrar, sdk: DGis.Container, layerId: String? = nil) {
        self.methodChannel = methodChannel
        self.registrar = registrar
        self.sdk = sdk
        self.layerId = layerId
    }
    
    func renderCluster(cluster: SimpleClusterObject) -> SimpleClusterOptions {
        var clusterOptions: SimpleClusterOptions?;
        let semaphore = DispatchSemaphore(value: 0);
        var markers = Array<Any>();
        
        for object in cluster.objects {
            let userData = object.userData as! MapObjectUserData;
            
            markers.append(userData.userData!);
        }
        
        let args: Dictionary<String, Any?> = [
            "layerId": self.layerId,
            "data": markers
        ];
        
        DispatchQueue.main.async {
            self.methodChannel.invokeMethod(
                "cluster#render",
                arguments: args,
                result: { result in
                    clusterOptions = MarkersUtils.getClusterOptionsFromDart(
                        mapClusterer: result as! Dictionary<String, Any?>,
                        sdk: self.sdk,
                        registrar: self.registrar,
                        markers: markers,
                        layerId: self.layerId
                    )
                    semaphore.signal();
                }
            )
        }
        
        semaphore.wait();
            
        return clusterOptions!;
    }
}

