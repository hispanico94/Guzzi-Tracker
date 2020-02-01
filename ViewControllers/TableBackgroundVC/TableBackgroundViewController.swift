import UIKit

class TableBackgroundViewController: UIViewController {

    let text: String
    
    @IBOutlet weak var label: UILabel!
    
    init(text: String) {
        self.text = text
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        label.text = text
    }
}
