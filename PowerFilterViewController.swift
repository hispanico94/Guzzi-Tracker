import UIKit

class PowerFilterViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    private var filter: Power
    private let minPowerPickerComponent = 0
    private let maxPowerPickerComponent = 1
    private let powers: [Measurement<UnitPower>]
    private let callback: (Power) -> ()
    
    private var selectedMinPower: Measurement<UnitPower> {
        didSet {
            if (selectedMinPower > selectedMaxPower) {
                selectedMaxPower = selectedMinPower
                let row = powers.index(of: selectedMinPower) ?? (powers.count - 1)
                powerPicker.selectRow(row, inComponent: maxPowerPickerComponent, animated: true)
            }
        }
    }
    
    private var selectedMaxPower: Measurement<UnitPower> {
        didSet {
            if (selectedMaxPower < selectedMinPower) {
                selectedMinPower = selectedMaxPower
                let row = powers.index(of: selectedMaxPower) ?? 0
                powerPicker.selectRow(row, inComponent: minPowerPickerComponent, animated: true)
            }
        }
    }
    
    @IBOutlet weak var powerPicker: UIPickerView!
    
    init(filter: Power, _ callback: @escaping (Power) -> ()) {
        self.filter = filter
        self.selectedMinPower = filter.minPower
        self.selectedMaxPower = filter.maxPower
        self.powers = filter.powers
        self.callback = callback
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = filter.title
        let minPowerRow = powers.index(of: selectedMinPower) ?? 0
        let maxPowerRow = powers.index(of: selectedMaxPower) ?? (powers.count - 1)
        powerPicker.selectRow(minPowerRow, inComponent: minPowerPickerComponent, animated: true)
        powerPicker.selectRow(maxPowerRow, inComponent: maxPowerPickerComponent, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        filter.minPower = selectedMinPower
        filter.maxPower = selectedMaxPower
        callback(filter)
        super.viewWillDisappear(animated)
    }
    
    // MARK: - UIPickerView Data Source
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return powers.count
    }
    
    // MARK: - UIPickerView Delegate
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return powers[row].value.descriptionWithDecimalsIfPresent
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch component {
        case minPowerPickerComponent:
            selectedMinPower = powers[row]
        case maxPowerPickerComponent:
            selectedMaxPower = powers[row]
        default:
            return
        }
    }
}





