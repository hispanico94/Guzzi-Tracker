import UIKit

class ImageCell: UITableViewCell {
    static let defaultIdentifier = "ImageCell"
    
    @IBOutlet weak var motorcycleImageView: UIImageView!

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    static func getCell() -> ImageCell {
        return UINib(nibName: "ImageCell", bundle: nil).instantiate(withOwner: nil, options: nil)
            .first as! ImageCell
    }
    
    func set(withImageURL url: URL) -> ImageCell {
        motorcycleImageView.kf.setImage(with: url)
        return self
    }
    
}
