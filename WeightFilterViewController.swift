import UIKit

class WeightFilterViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {

    private var filter: Weight
    private let minWeightPickerComponent = 0
    private let maxWeightPickerComponent = 1
    private let weights: [Measurement<UnitMass>]
    private let callback: (Weight) -> ()
    
    private var selectedMinWeight: Measurement<UnitMass> {
        didSet {
            let lastIndex = weights.count - 1
            guard let row = weights.index(of: selectedMinWeight) else {
                clearSelection()
                return
            }
            
            if row == lastIndex {
                
                selectedMaxWeight = weights[row]
                weightPicker.selectRow(row, inComponent: maxWeightPickerComponent, animated: true)
                
                selectedMinWeight = weights[row - 1]
                weightPicker.selectRow(row - 1, inComponent: minWeightPickerComponent, animated: true)
                
            } else if selectedMinWeight >= selectedMaxWeight {
                
                selectedMaxWeight = weights[row + 1]
                weightPicker.selectRow(row + 1, inComponent: maxWeightPickerComponent, animated: true)
            }
            
            updateCaptionLabel()
        }
    }
    
    private var selectedMaxWeight: Measurement<UnitMass> {
        didSet {
            let firstIndex = 0
            guard let row = weights.index(of: selectedMaxWeight) else {
                clearSelection()
                return
            }
            
            if row == firstIndex {
                
                selectedMinWeight = weights[row]
                weightPicker.selectRow(row, inComponent: minWeightPickerComponent, animated: true)
                
                selectedMaxWeight = weights[row + 1]
                weightPicker.selectRow(row + 1 , inComponent: maxWeightPickerComponent, animated: true)
                
            } else if selectedMaxWeight <= selectedMinWeight {
                
                selectedMinWeight = weights[row - 1]
                weightPicker.selectRow(row - 1, inComponent: minWeightPickerComponent, animated: true)
            }
            
            updateCaptionLabel()
        }
    }
    
    @IBOutlet weak var weightPicker: UIPickerView!
    @IBOutlet weak var captionLabel: UILabel!
    
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
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "Clear", style: .plain, target: self, action: #selector(clearSelection))
        let minWeightRow = weights.index(of: selectedMinWeight) ?? 0
        let maxWeightRow = weights.index(of: selectedMaxWeight) ?? (weights.count - 1)
        weightPicker.selectRow(minWeightRow, inComponent: minWeightPickerComponent, animated: true)
        weightPicker.selectRow(maxWeightRow, inComponent: maxWeightPickerComponent, animated: true)
        updateCaptionLabel()
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
    
    // MARK: - Private instance methods
    
    @objc private func clearSelection() {
        selectedMinWeight = weights.first!
        selectedMaxWeight = weights.last!
        let minWeightRow = 0
        let maxWeightRow = weights.count - 1
        weightPicker.selectRow(minWeightRow, inComponent: minWeightPickerComponent, animated: true)
        weightPicker.selectRow(maxWeightRow, inComponent: maxWeightPickerComponent, animated: true)
    }
    
    private func updateCaptionLabel() {
        captionLabel.text = "Filter all motorcycles with weight between \(selectedMinWeight.descriptionWithDecimalsIfPresent) and \(selectedMaxWeight.descriptionWithDecimalsIfPresent)"
    }
}
