import UIKit

struct FilterButton {
    
    let button: UIButton
    
    init() {
        button = UIButton()
        button.setTitleColor(.guzziRed, for: .normal)
        button.setTitleColor(.gray, for: .disabled)
        button.setTitle(NSLocalizedString("No results", comment: "No results"), for: .disabled)
    }
    
    func addTarget(_ target: Any?, action: Selector, for controlEvents: UIControl.Event) {
        button.addTarget(target, action: action, for: controlEvents)
    }
    
    func setTitle(withValue value: Int?) {
        guard let unwrap = value else { return }
        
        switch unwrap {
        case 0:
            button.isEnabled = false
        default:
            let formatString = NSLocalizedString("View %d results", comment: "View %d results (%d >= 1)")
            let buttonCaption = String.localizedStringWithFormat(formatString, unwrap)
            button.setTitle(buttonCaption, for: .normal)
            button.isEnabled = true
        }
    }
}
