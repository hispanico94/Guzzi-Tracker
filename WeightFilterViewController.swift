import UIKit

class WeightFilterViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {

    private let weightFilter: Weight
    private let minWeightPickerComponent = 0
    private let maxWeightPickerComponent = 1
    private let weightsArray: [Int]
    private let callback: (Weight) -> ()
    
    private var selectedMinWeight: Int {
        didSet {
            if (selectedMinWeight > selectedMaxWeight) {
                let row = weightsArray.index(of: selectedMinWeight) ?? (weightsArray.count - 1)
                weightPicker.selectRow(row, inComponent: maxWeightPickerComponent, animated: true)
            }
        }
    }
    
    private var selectedMaxWeight: Int {
        didSet {
            if (selectedMaxWeight < selectedMinWeight) {
                let row = weightsArray.index(of: selectedMaxWeight) ?? 0
                weightPicker.selectRow(row, inComponent: minWeightPickerComponent, animated: true)
            }
        }
    }
    
    @IBOutlet weak var weightPicker: UIPickerView!
    
    init(filter weightFilter: Weight, _ callback: @escaping (Weight) -> ()) {
        self.weightFilter = weightFilter
        self.selectedMinWeight = Int(weightFilter.minWeight.value)
        self.selectedMaxWeight = Int(weightFilter.maxWeight.value)
        self.weightsArray = Array(Int(weightFilter.lightestWeight.value)...Int(weightFilter.heaviestWeight.value))
        self.callback = callback
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let minWeightRow = weightsArray.index(of: selectedMinWeight) ?? 0
        let maxWeightRow = weightsArray.index(of: selectedMaxWeight) ?? (weightsArray.count - 1)
        weightPicker.selectRow(minWeightRow, inComponent: minWeightPickerComponent, animated: true)
        weightPicker.selectRow(maxWeightRow, inComponent: maxWeightPickerComponent, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        var newFilter = weightFilter
        newFilter.minWeight = Measurement(value: Double(selectedMinWeight), unit: .kilograms)
        newFilter.maxWeight = Measurement(value: Double(selectedMaxWeight), unit: .kilograms)
        callback(newFilter)
        super.viewWillDisappear(animated)
    }
    
    // MARK: - UIPickerView Data Source
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return weightsArray.count
    }
    
    // MARK: - UIPickerView Delegate
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
//        let weight = Measurement(value: Double(weightsArray[row]), unit: UnitMass.kilograms)
//        return weight.description
        return String(weightsArray[row])
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch component {
        case minWeightPickerComponent:
            selectedMinWeight = weightsArray[row]
        case maxWeightPickerComponent:
            selectedMaxWeight = weightsArray[row]
        default:
            return
        }
    }
}
