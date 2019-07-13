import UIKit
import Kingfisher

struct ImageLoadingIndicator: Indicator {
    var view: IndicatorView = ImageLoadingIndicatorView()

    func startAnimatingView() {
        (view as! ImageLoadingIndicatorView).startAnimating()
    }

    func stopAnimatingView() {
        (view as! ImageLoadingIndicatorView).stopAnimating()
    }
}

class ImageLoadingIndicatorView: UIView {
    let activityIndicator = UIActivityIndicatorView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    private func setupView() {
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.style = .gray
        
        addSubview(activityIndicator)
        
        NSLayoutConstraint.activate([
            activityIndicator.leadingAnchor.constraint(equalToSystemSpacingAfter: leadingAnchor, multiplier: 1),
            activityIndicator.topAnchor.constraint(equalToSystemSpacingBelow: topAnchor, multiplier: 1),
            trailingAnchor.constraint(equalToSystemSpacingAfter: activityIndicator.trailingAnchor, multiplier: 1),
            bottomAnchor.constraint(equalToSystemSpacingBelow: activityIndicator.bottomAnchor, multiplier: 1)
        ])
        
        activityIndicator.startAnimating()
    }
    
    func startAnimating() {
        activityIndicator.startAnimating()
        isHidden = false
    }

    func stopAnimating() {
        isHidden = true
        activityIndicator.stopAnimating()
    }
}
