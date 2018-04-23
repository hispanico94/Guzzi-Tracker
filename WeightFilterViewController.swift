import UIKit

class WeightFilterViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {

    private var filter: Weight
    private let minWeightPickerComponent = 0
    private let maxWeightPickerComponent = 1
    private let weights: [Measurement<UnitMass>]
    private let callback: (Weight) -> ()
    
    private var selectedMinWeight: Measurement<UnitMass> {
        didSet {
            if (selectedMinWeight > selectedMaxWeight) {
                selectedMaxWeight = selectedMinWeight
                let row = weights.index(of: selectedMinWeight) ?? (weights.count - 1)
                weightPicker.selectRow(row, inComponent: maxWeightPickerComponent, animated: true)
            }
        }
    }
    
    private var selectedMaxWeight: Measurement<UnitMass> {
        didSet {
            if (selectedMaxWeight < selectedMinWeight) {
                selectedMinWeight = selectedMaxWeight
                let row = weights.index(of: selectedMaxWeight) ?? 0
                weightPicker.selectRow(row, inComponent: minWeightPickerComponent, animated: true)
            }
        }
    }
    
    @IBOutlet weak var weightPicker: UIPickerView!
    
    init(filter: Weight, _ callback: @escaping (Weight) -> ()) {
        self.filter = filter
        self.selectedMinWeight = filter.minWeight
        self.selectedMaxWeight = filter.maxWeight
        self.weights = filter.weights
        self.callback = callback
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = filter.title
        let minWeightRow = weights.index(of: selectedMinWeight) ?? 0
        let maxWeightRow = weights.index(of: selectedMaxWeight) ?? (weights.count - 1)
        weightPicker.selectRow(minWeightRow, inComponent: minWeightPickerComponent, animated: true)
        weightPicker.selectRow(maxWeightRow, inComponent: maxWeightPickerComponent, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        filter.minWeight = selectedMinWeight
        filter.maxWeight = selectedMaxWeight
        callback(filter)
        super.viewWillDisappear(animated)
    }
    
    // MARK: - UIPickerView Data Source
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return weights.count
    }
    
    // MARK: - UIPickerView Delegate
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return String(format: "%.0f", weights[row].value)
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch component {
        case minWeightPickerComponent:
            selectedMinWeight = weights[row]
        case maxWeightPickerComponent:
            selectedMaxWeight = weights[row]
        default:
            return
        }
    }
}
