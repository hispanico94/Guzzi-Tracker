import UIKit

class BoreFilterViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    private let boreFilter: Bore
    private let minBorePickerComponent = 0
    private let maxBorePickerComponent = 1
    private let boresArray: [Int]
    private let callback: (Bore) -> ()
    
    private var selectedMinBore: Int {
        didSet {
            if (selectedMinBore > selectedMaxBore) {
                let row = boresArray.index(of: selectedMinBore) ?? (boresArray.count - 1)
                borePicker.selectRow(row, inComponent: maxBorePickerComponent, animated: true)
            }
        }
    }

    private var selectedMaxBore: Int {
        didSet {
            if (selectedMaxBore < selectedMinBore) {
                let row = boresArray.index(of: selectedMaxBore) ?? 0
                borePicker.selectRow(row, inComponent: minBorePickerComponent, animated: true)
            }
        }
    }
    
    @IBOutlet weak var borePicker: UIPickerView!
    
    init(filter boreFilter: Bore, _ callback: @escaping (Bore) -> ()) {
        self.boreFilter = boreFilter
        self.selectedMinBore = Int(boreFilter.minBore.value)
        self.selectedMaxBore = Int(boreFilter.maxBore.value)
        self.boresArray = Array(Int(boreFilter.smallestBore.value.rounded(.down))...Int(boreFilter.biggestBore.value.rounded(.up)))
        self.callback = callback
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let minBoreRow = boresArray.index(of: selectedMinBore) ?? 0
        let maxBoreRow = boresArray.index(of: selectedMaxBore) ?? (boresArray.count - 1)
        borePicker.selectRow(minBoreRow, inComponent: minBorePickerComponent, animated: true)
        borePicker.selectRow(maxBoreRow, inComponent: maxBorePickerComponent, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        var newFilter = boreFilter
        newFilter.minBore = Measurement(value: Double(selectedMinBore), unit: .millimeters)
        newFilter.maxBore = Measurement(value: Double(selectedMaxBore), unit: .millimeters)
        callback(newFilter)
        super.viewWillDisappear(animated)
    }
    
    // MARK: - UIPickerView Data Source
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return boresArray.count
    }
    
    // MARK: - UIPickerView Delegate
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return String(boresArray[row])
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch component {
        case minBorePickerComponent:
            selectedMinBore = boresArray[row]
        case maxBorePickerComponent:
            selectedMaxBore = boresArray[row]
        default:
            return
        }
    }
}
