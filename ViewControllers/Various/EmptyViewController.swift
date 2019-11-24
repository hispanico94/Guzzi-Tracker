import UIKit

class EmptyViewController: UIViewController {
    private let standardSideToCornerRadiusRatio: CGFloat = 6.4
    
    @IBOutlet weak var iconImageView: UIImageView! {
        didSet {
            if let image = iconImageView.image {
                let radius = image.size.width / standardSideToCornerRadiusRatio
                
                iconImageView.layer.cornerRadius = radius
                iconImageView.clipsToBounds = true
            }
        }
    }
    
}
