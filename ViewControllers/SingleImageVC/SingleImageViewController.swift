import UIKit
//import AlamofireImage

class SingleImageViewController: UIViewController {
    
    // MARK: - Properties
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    private let image: UIImage
    
    private var didSetImage = false
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var imageView: UIImageView! {
        didSet {
            imageView.image = image
            imageView.sizeToFit()
            didSetImage = true
        }
    }
    
    @IBOutlet weak var imageViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var imageViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var imageViewLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var imageViewTrailingConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var closeButton: UIButton!
    
    // MARK: - Initialization
    
    init(imageToBeDisplayed image: UIImage) {
        self.image = image
        super.init(nibName: "SingleImageViewController", bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setButton()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        updateMinZoomScale(forSize: view.bounds.size)
    }
    
    private func setButton() {
        closeButton.setTitle(NSLocalizedString("Close", comment: "Close"), for: .normal)
        
        let blurEffect = UIBlurEffect(style: .regular)
        let visualEffectView = UIVisualEffectView(effect: blurEffect)
        visualEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        visualEffectView.isUserInteractionEnabled = false
        visualEffectView.frame = closeButton.bounds
        visualEffectView.layer.cornerRadius = visualEffectView.frame.size.height / 2
        visualEffectView.clipsToBounds = true
        
        closeButton.insertSubview(visualEffectView, at: 0)
    }
    
    private func updateMinZoomScale(forSize size: CGSize) {
        let widthScale = size.width / image.size.width
        let heightScale = size.height / image.size.height
        let minZoomScale = min(widthScale, heightScale)
        
        scrollView.minimumZoomScale = minZoomScale
        scrollView.zoomScale = minZoomScale
    }
    
    fileprivate func updateConstraints(forSize size: CGSize) {

        let yOffset = max(0, (size.height - imageView.frame.height) / 2)
        imageViewTopConstraint.constant = yOffset
        imageViewBottomConstraint.constant = yOffset

        let xOffset = max(0, (size.width - imageView.frame.width) / 2)
        imageViewLeadingConstraint.constant = xOffset
        imageViewTrailingConstraint.constant = xOffset

        view.layoutIfNeeded()
    }
    
    @IBAction func didTapCloseButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}

// MARK: - Scroll View Delegate
extension SingleImageViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        guard didSetImage else { return }
        updateConstraints(forSize: scrollView.bounds.size)
    }
}
