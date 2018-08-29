import UIKit

class WheelbaseFilterViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    private var filter: Wheelbase
    private let minWheelbasePickerComponent = 0
    private let maxWheelbasePickerComponent = 1
    private let wheelbases: [Measurement<UnitLength>]
    private let callback: (Wheelbase) -> ()
    
    private var selectedMinWheelbase: Measurement<UnitLength> {
        didSet {
            if (selectedMinWheelbase > selectedMaxWheelbase) {
                selectedMaxWheelbase = selectedMinWheelbase
                let row = wheelbases.index(of: selectedMinWheelbase) ?? (wheelbases.count - 1)
                wheelbasePicker.selectRow(row, inComponent: maxWheelbasePickerComponent, animated: true)
            }
            updateCaptionLabel()
        }
    }
    
    private var selectedMaxWheelbase: Measurement<UnitLength> {
        didSet {
            if (selectedMaxWheelbase < selectedMinWheelbase) {
                selectedMinWheelbase = selectedMaxWheelbase
                let row = wheelbases.index(of: selectedMaxWheelbase) ?? 0
                wheelbasePicker.selectRow(row, inComponent: minWheelbasePickerComponent, animated: true)
            }
            updateCaptionLabel()
        }
    }
    
    @IBOutlet weak var wheelbasePicker: UIPickerView!
    @IBOutlet weak var captionLabel: UILabel!
    
    init(filter: Wheelbase, _ callback: @escaping (Wheelbase) -> ()) {
        self.filter = filter
        self.selectedMinWheelbase = filter.minWheelbase
        self.selectedMaxWheelbase = filter.maxWheelbase
        self.wheelbases = filter.wheelbases
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
        let minWheelbaseRow = wheelbases.index(of: selectedMinWheelbase) ?? 0
        let maxWheelbaseRow = wheelbases.index(of: selectedMaxWheelbase) ?? (wheelbases.count - 1)
        wheelbasePicker.selectRow(minWheelbaseRow, inComponent: minWheelbasePickerComponent, animated: true)
        wheelbasePicker.selectRow(maxWheelbaseRow, inComponent: maxWheelbasePickerComponent, animated: true)
        updateCaptionLabel()
    }

    override func viewWillDisappear(_ animated: Bool) {
        filter.minWheelbase = selectedMinWheelbase
        filter.maxWheelbase = selectedMaxWheelbase
        callback(filter)
        super.viewWillDisappear(animated)
    }
    
    // MARK: - UIPickerView Data Source
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return wheelbases.count
    }
    
    // MARK: - UIPickerView Delegate
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return wheelbases[row].value.descriptionWithDecimalsIfPresent
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch component {
        case minWheelbasePickerComponent:
            selectedMinWheelbase = wheelbases[row]
        case maxWheelbasePickerComponent:
            selectedMaxWheelbase = wheelbases[row]
        default:
            return
        }
    }
    
    // MARK: - Private instance methods
    
    @objc private func clearSelection() {
        selectedMinWheelbase = wheelbases.first!
        selectedMaxWheelbase = wheelbases.last!
        let minWheelbaseRow = 0
        let maxWheelbaseRow = wheelbases.count - 1
        wheelbasePicker.selectRow(minWheelbaseRow, inComponent: minWheelbasePickerComponent, animated: true)
        wheelbasePicker.selectRow(maxWheelbaseRow, inComponent: maxWheelbasePickerComponent, animated: true)
    }
    
    private func updateCaptionLabel() {
        let formatString = NSLocalizedString("Select all motorcycles with wheelbase between %@ and %@",
                                             comment: "Select all motorcycles with wheelbase between %@ and %@ (two measurements, the first has a lower value than the second)")
        captionLabel.text = String.localizedStringWithFormat(formatString,
                                                             selectedMinWheelbase.descriptionWithDecimalsIfPresent,
                                                             selectedMaxWheelbase.descriptionWithDecimalsIfPresent)
    }
}
