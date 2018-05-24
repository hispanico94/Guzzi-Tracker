import UIKit

struct FilterButton {
    
    let button: UIButton
    
    init() {
        button = UIButton()
        button.setTitleColor(.red, for: .disabled)
        button.setTitle("No results", for: .disabled)
    }
    
    func setDefaultColor(_ color: UIColor) {
        button.setTitleColor(color, for: .normal)
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
