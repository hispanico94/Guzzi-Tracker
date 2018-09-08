import UIKit
import AlamofireImage

class SingleImageViewController: UIViewController {
    
    // MARK: - Properties
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    private let image: UIImage
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var imageView: UIImageView! {
        didSet {
            imageView.image = image
        }
    }
    
//    @IBOutlet weak var imageViewTopConstraint: NSLayoutConstraint!
//    @IBOutlet weak var imageViewBottomConstraint: NSLayoutConstraint!
//    @IBOutlet weak var imageViewLeadingConstraint: NSLayoutConstraint!
//    @IBOutlet weak var imageViewTrailingConstraint: NSLayoutConstraint!
    
    // MARK: - Initialization
    
    init(imageToBeDisplayed image: UIImage) {
        self.image = image
        super.init(nibName: "SingleImageViewController", bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: -
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        updateMinZoomScale(forSize: view.bounds.size)
    }
    
    private func updateMinZoomScale(forSize size: CGSize) {
        let widthScale = size.width / image.size.width
        let heightScale = size.height / image.size.height
        let minScale = min(widthScale, heightScale)
        
        scrollView.minimumZoomScale = minScale
        
//        scrollView.zoomScale = minScale
    }
    
//    fileprivate func updateConstraints(forSize size: CGSize) {
//
//        let yOffset = max(0, (size.height - imageView.frame.height) / 2)
//        imageViewTopConstraint.constant = yOffset
//        imageViewBottomConstraint.constant = yOffset
//
//        let xOffset = max(0, (size.width - imageView.frame.width) / 2)
//        imageViewLeadingConstraint.constant = xOffset
//        imageViewTrailingConstraint.constant = xOffset
//
//        view.layoutIfNeeded()
//    }
    
    @IBAction func userDidTap(_ sender: UITapGestureRecognizer) {
        dismiss(animated: true, completion: nil)
    }
    
}

// MARK: - Scroll View Delegate
extension SingleImageViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
//    func scrollViewDidZoom(_ scrollView: UIScrollView) {
//        updateConstraints(forSize: view.bounds.size)
//    }
}
