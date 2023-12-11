import DGis

class DGisMapConfig {
     var keyFile: String;
     var initialCameraPosition: CameraPosition;
     var layers: Array<Dictionary<String, Any?>>;
     var theme: String;

     init (
         arguments args: Dictionary<String?, Any?>
     ) {
         self.keyFile = args["keyFile"] as! String;
         self.initialCameraPosition = CameraUtils.getCameraPositionFromDart(
            cameraPosition: args["initialCameraPosition"] as! Dictionary<String, Any>
         );
         self.layers = (args["layers"] as! Array<Any>).map{$0 as! Dictionary<String, Any?>}
         self.theme = args["theme"] as! String;
     }
 }
