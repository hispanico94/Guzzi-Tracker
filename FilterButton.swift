import UIKit

struct FilterButton {
    
    let button: UIButton
    
    init() {
        button = UIButton()
        button.setTitleColor(.guzziRed, for: .normal)
        button.setTitleColor(.gray, for: .disabled)
        button.setTitle("No results", for: .disabled)
    }
    
    func addTarget(_ target: Any?, action: Selector, for controlEvents: UIControlEvents) {
        button.addTarget(target, action: action, for: controlEvents)
    }
    
    func setTitle(withValue value: Int?) {
        guard let unwrap = value else { return }
        
        switch unwrap {
        case 0:
            button.isEnabled = false
        case 1:
            button.setTitle("View 1 result", for: .normal)
            button.isEnabled = true
        default:
            button.setTitle("View \(unwrap) results", for: .normal)
            button.isEnabled = true
        }
    }
}
