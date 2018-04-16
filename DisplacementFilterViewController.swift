import UIKit

class DisplacementFilterViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {

    private let displacementFilter: Displacement
    private let minDisplacementPickerComponent = 0
    private let maxDisplacementPickerComponent = 1
    private let displacementsArray: [Int]
    private let callback: (Displacement) -> ()
    
    private var selectedMinDisplacement: Int {
        didSet {
            if (selectedMinDisplacement > selectedMaxDisplacement) {
                let row = displacementsArray.index(of: selectedMinDisplacement) ?? (displacementsArray.count - 1)
                displacementPicker.selectRow(row, inComponent: maxDisplacementPickerComponent, animated: true)
            }
        }
    }
    
    private var selectedMaxDisplacement: Int {
        didSet {
            if (selectedMaxDisplacement < selectedMinDisplacement) {
                let row = displacementsArray.index(of: selectedMaxDisplacement) ?? 0
                displacementPicker.selectRow(row, inComponent: minDisplacementPickerComponent, animated: true)
            }
        }
    }
    
    
    @IBOutlet weak var displacementPicker: UIPickerView!
    
    init(filter displacementFilter: Displacement, _ callback: @escaping (Displacement) -> ()) {
        self.displacementFilter = displacementFilter
        self.selectedMinDisplacement = Int(displacementFilter.minDisplacement.value)
        self.selectedMaxDisplacement = Int(displacementFilter.maxDisplacement.value)
        self.displacementsArray = Array(Int(displacementFilter.smallestDisplacement.value)...Int(displacementFilter.biggestDisplacement.value))
        self.callback = callback
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let minDisplacementRow = displacementsArray.index(of: selectedMinDisplacement) ?? 0
        let maxDisplacementRow = displacementsArray.index(of: selectedMaxDisplacement) ?? (displacementsArray.count - 1)
        displacementPicker.selectRow(minDisplacementRow, inComponent: minDisplacementPickerComponent, animated: true)
        displacementPicker.selectRow(maxDisplacementRow, inComponent: maxDisplacementPickerComponent, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        var newFilter = displacementFilter
        newFilter.minDisplacement = Measurement(value: Double(selectedMinDisplacement), unit: .engineCubicCentimeters)
        newFilter.maxDisplacement = Measurement(value: Double(selectedMaxDisplacement), unit: .engineCubicCentimeters)
        callback(newFilter)
        super.viewWillDisappear(animated)
    }

    // MARK: - UIPickerView Data Source
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return displacementsArray.count
    }
    
    // MARK: - UIPickerView Delegate
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return String(displacementsArray[row])
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch component {
        case minDisplacementPickerComponent:
            selectedMinDisplacement = displacementsArray[row]
        case maxDisplacementPickerComponent:
            selectedMaxDisplacement = displacementsArray[row]
        default:
            return
        }
    }
}
