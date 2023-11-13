import DGis;
import Flutter;

class CameraController {
    private var map: DGis.Map;
    private var methodChannel: FlutterMethodChannel;
    private var cameraMoveCancellable: Future<CameraAnimatedMoveResult>?;
    
    init(map: DGis.Map, methodChannel: FlutterMethodChannel) {
        self.map = map;
        self.methodChannel = methodChannel;
    }
    
    func moveCamera(cameraPosition position: Dictionary<String, Any>) {
        self.cameraMoveCancellable = map.camera.move(
            position: CameraUtils.getCameraPositionFromDart(
                cameraPosition: position["cameraPosition"] as! Dictionary<String, Any>
            ),
            time: TimeInterval(floatLiteral: (position["durationInMilliseconds"] as! Double) * 0.001)
        )
    }
}
