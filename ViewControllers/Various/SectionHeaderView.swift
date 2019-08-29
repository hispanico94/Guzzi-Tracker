import UIKit

class SectionHeaderView: UIView {
    private let label: UILabel = {
        let label = UILabel()
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.font = .preferredFont(forTextStyle: .headline)
        label.textAlignment = .center
        label.lineBreakMode = .byWordWrapping
        
        return label
    }()
    
    var text: String? {
        get {
            return label.text
        }
        set {
            label.text = newValue
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    private func setupView() {
        backgroundColor = .lightLegnanoGreen
        addSubview(label)
        
        directionalLayoutMargins = NSDirectionalEdgeInsets(top: 16, leading: 16, bottom: 16, trailing: 16)
        let margins = layoutMarginsGuide
        
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: margins.leadingAnchor),
            label.topAnchor.constraint(equalTo: margins.topAnchor),
            label.trailingAnchor.constraint(equalTo: margins.trailingAnchor),
            label.bottomAnchor.constraint(equalTo: margins.bottomAnchor)
        ])
    }
}
