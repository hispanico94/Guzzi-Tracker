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
                let row = powers.firstIndex(of: selectedMinPower) ?? (powers.count - 1)
                powerPicker.selectRow(row, inComponent: maxPowerPickerComponent, animated: true)
            }
            updateCaptionLabel()
        }
    }
    
    private var selectedMaxPower: Measurement<UnitPower> {
        didSet {
            if (selectedMaxPower < selectedMinPower) {
                selectedMinPower = selectedMaxPower
                let row = powers.firstIndex(of: selectedMaxPower) ?? 0
                powerPicker.selectRow(row, inComponent: minPowerPickerComponent, animated: true)
            }
            updateCaptionLabel()
        }
    }
    
    @IBOutlet weak var powerPicker: UIPickerView!
    @IBOutlet weak var captionLabel: UILabel!
    
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
        
        let clearString = NSLocalizedString("Clear", comment: "Clear (filters, criteria, selections)")
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: clearString, style: .plain, target: self, action: #selector(clearSelection))
        let minPowerRow = powers.firstIndex(of: selectedMinPower) ?? 0
        let maxPowerRow = powers.firstIndex(of: selectedMaxPower) ?? (powers.count - 1)
        powerPicker.selectRow(minPowerRow, inComponent: minPowerPickerComponent, animated: true)
        powerPicker.selectRow(maxPowerRow, inComponent: maxPowerPickerComponent, animated: true)
        updateCaptionLabel()
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
        return powers[row].value.customLocalizedDescription
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
    
    // MARK: - Private instance methods
    
    @objc private func clearSelection() {
        selectedMinPower = powers.first!
        selectedMaxPower = powers.last!
        let minPowerRow = 0
        let maxPowerRow = powers.count - 1
        powerPicker.selectRow(minPowerRow, inComponent: minPowerPickerComponent, animated: true)
        powerPicker.selectRow(maxPowerRow, inComponent: maxPowerPickerComponent, animated: true)
    }
    
    private func updateCaptionLabel() {
        let formatString = NSLocalizedString("Select all motorcycles with power between %@ and %@",
                                             comment: "Select all motorcycles with (engine) power between %@ and %@ (two measurements, the first has a lower value than the second)")
        captionLabel.text = String.localizedStringWithFormat(formatString,
                                                             selectedMinPower.customLocalizedDescription,
                                                             selectedMaxPower.customLocalizedDescription)
    }
}





