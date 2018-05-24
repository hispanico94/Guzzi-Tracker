import UIKit

class BoreFilterViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    private var filter: Bore
    private let minBorePickerComponent = 0
    private let maxBorePickerComponent = 1
    private let bores: [Measurement<UnitLength>]
    private let callback: (Bore) -> ()
    
    private var selectedMinBore: Measurement<UnitLength> {
        didSet {
            if (selectedMinBore > selectedMaxBore) {
                selectedMaxBore = selectedMinBore
                let row = bores.index(of: selectedMinBore) ?? (bores.count - 1)
                borePicker.selectRow(row, inComponent: maxBorePickerComponent, animated: true)
            }
        }
    }

    private var selectedMaxBore: Measurement<UnitLength> {
        didSet {
            if (selectedMaxBore < selectedMinBore) {
                selectedMinBore = selectedMaxBore
                let row = bores.index(of: selectedMaxBore) ?? 0
                borePicker.selectRow(row, inComponent: minBorePickerComponent, animated: true)
            }
        }
    }
    
    @IBOutlet weak var borePicker: UIPickerView!
    
    init(filter: Bore, _ callback: @escaping (Bore) -> ()) {
        self.filter = filter
        self.selectedMinBore = filter.minBore
        self.selectedMaxBore = filter.maxBore
        self.bores = filter.bores
        self.callback = callback
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = filter.title
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "Clear", style: .plain, target: self, action: #selector(clearSelection))
        let minBoreRow = bores.index(of: selectedMinBore) ?? 0
        let maxBoreRow = bores.index(of: selectedMaxBore) ?? (bores.count - 1)
        borePicker.selectRow(minBoreRow, inComponent: minBorePickerComponent, animated: true)
        borePicker.selectRow(maxBoreRow, inComponent: maxBorePickerComponent, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        filter.minBore = selectedMinBore
        filter.maxBore = selectedMaxBore
        callback(filter)
        super.viewWillDisappear(animated)
    }
    
    // MARK: - UIPickerView Data Source
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return bores.count
    }
    
    // MARK: - UIPickerView Delegate
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return bores[row].value.descriptionWithDecimalsIfPresent
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch component {
        case minBorePickerComponent:
            selectedMinBore = bores[row]
        case maxBorePickerComponent:
            selectedMaxBore = bores[row]
        default:
            return
        }
    }
    
    @objc private func clearSelection() {
        selectedMinBore = bores.first!
        selectedMaxBore = bores.last!
        let minBoreRow = 0
        let maxBoreRow = bores.count - 1
        borePicker.selectRow(minBoreRow, inComponent: minBorePickerComponent, animated: true)
        borePicker.selectRow(maxBoreRow, inComponent: maxBorePickerComponent, animated: true)
    }
}
