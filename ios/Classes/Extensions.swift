extension UIImage {
    static func loadFromFile(imagePath: String) -> UIImage? {
        if let path = Bundle.main.path(forResource: imagePath, ofType: nil) {
            let imageUrl = URL(fileURLWithPath: path)
            if let imageData: Data = try? Data(contentsOf: imageUrl),
               let image = UIImage(data: imageData)
            {
                return image
            }
        }
        return nil
    }
}
import DGis;

extension DGis.TextPlacement {
    static func fromString(value val: String) -> DGis.TextPlacement {
        switch val {
        case "bottomCenter":
            return DGis.TextPlacement.bottomCenter;
        case "bottomRight":
            return DGis.TextPlacement.bottomRight;
        case "bottomLeft":
            return DGis.TextPlacement.bottomLeft;
        case "circleBottomRight":
            return DGis.TextPlacement.circleBottomRight;
        case "rightBottom":
            return DGis.TextPlacement.rightBottom;
        case "rightCenter":
            return DGis.TextPlacement.rightCenter;
        case "rightTop":
            return DGis.TextPlacement.rightTop;
        case "circleTopRight":
            return DGis.TextPlacement.circleTopRight;
        case "topCenter":
            return DGis.TextPlacement.topCenter;
        case "topRight":
            return DGis.TextPlacement.topRight;
        case "topLeft":
            return DGis.TextPlacement.topLeft;
        case "circleTopLeft":
            return DGis.TextPlacement.circleTopLeft;
        case "leftTop":
            return DGis.TextPlacement.leftTop;
        case "leftCenter":
            return DGis.TextPlacement.leftCenter;
        case "leftBottom":
            return DGis.TextPlacement.leftBottom;
        case "circleBottomLeft":
            return DGis.TextPlacement.circleBottomLeft;
        case "centerCenter":
            return DGis.TextPlacement.centerCenter;
        default:
            return DGis.TextPlacement.noLabel;
        }
    }
}

extension DGis.CameraAnimationType {
    static func fromString(value val: String) -> DGis.CameraAnimationType {
        switch val {
        case "linear":
            return DGis.CameraAnimationType.linear;
        case "showBothPositions":
            return DGis.CameraAnimationType.showBothPositions;
        default:
            return DGis.CameraAnimationType.default;
        }
    }
}

