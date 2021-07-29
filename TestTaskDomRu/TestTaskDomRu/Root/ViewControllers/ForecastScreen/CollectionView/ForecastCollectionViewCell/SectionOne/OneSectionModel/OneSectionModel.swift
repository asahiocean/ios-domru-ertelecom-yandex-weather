import Foundation
import UIKit.UIImage

/// The model for displaying cells in the first section (not null)
struct OneSectionModel {
    let time: String
    let image: UIImage
    let temp: String
    
    internal init(time: String, image: UIImage, temp: String) {
        self.time = time
        self.image = image
        self.temp = temp
    }
}
