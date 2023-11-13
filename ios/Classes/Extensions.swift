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
        case "NO_LABEL":
            return DGis.TextPlacement.noLabel;
        case "BOTTOM_CENTER":
            return DGis.TextPlacement.bottomCenter;
        case "BOTTOM_RIGHT":
            return DGis.TextPlacement.bottomRight;
        case "BOTTOM_LEFT":
            return DGis.TextPlacement.bottomLeft;
        case "CIRCLE_BOTTOM_RIGHT":
            return DGis.TextPlacement.circleBottomRight;
        case "RIGHT_BOTTOM":
            return DGis.TextPlacement.rightBottom;
        case "RIGHT_CENTER":
            return DGis.TextPlacement.rightCenter;
        case "RIGHT_TOP":
            return DGis.TextPlacement.rightTop;
        case "CIRCLE_TOP_RIGHT":
            return DGis.TextPlacement.circleTopRight;
        case "TOP_CENTER":
            return DGis.TextPlacement.topCenter;
        case "TOP_RIGHT":
            return DGis.TextPlacement.topRight;
        case "TOP_LEFT":
            return DGis.TextPlacement.topLeft;
        case "CIRCLE_TOP_LEFT":
            return DGis.TextPlacement.circleTopLeft;
        case "LEFT_TOP":
            return DGis.TextPlacement.leftTop;
        case "LEFT_CENTER":
            return DGis.TextPlacement.leftCenter;
        case "LEFT_BOTTOM":
            return DGis.TextPlacement.leftBottom;
        case "CIRCLE_BOTTOM_LEFT":
            return DGis.TextPlacement.circleBottomLeft;
        case "CENTER_CENTER":
            return DGis.TextPlacement.centerCenter;
        default:
            return DGis.TextPlacement.noLabel;
        }
    }
}
