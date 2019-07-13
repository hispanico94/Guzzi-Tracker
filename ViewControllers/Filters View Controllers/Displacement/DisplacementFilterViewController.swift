import UIKit

class DisplacementFilterViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {

    private var filter: Displacement
    private let minDisplacementPickerComponent = 0
    private let maxDisplacementPickerComponent = 1
    private let displacements: [Measurement<UnitVolume>]
    private let callback: (Displacement) -> ()
    
    private var selectedMinDisplacement: Measurement<UnitVolume> {
        didSet {
            if (selectedMinDisplacement > selectedMaxDisplacement) {
                selectedMaxDisplacement = selectedMinDisplacement
                let row = displacements.firstIndex(of: selectedMinDisplacement) ?? (displacements.count - 1)
                displacementPicker.selectRow(row, inComponent: maxDisplacementPickerComponent, animated: true)
            }
            updateCaptionLabel()
        }
    }
    
    private var selectedMaxDisplacement: Measurement<UnitVolume> {
        didSet {
            if (selectedMaxDisplacement < selectedMinDisplacement) {
                selectedMinDisplacement = selectedMaxDisplacement
                let row = displacements.firstIndex(of: selectedMaxDisplacement) ?? 0
                displacementPicker.selectRow(row, inComponent: minDisplacementPickerComponent, animated: true)
            }
            updateCaptionLabel()
        }
    }
    
    
    @IBOutlet weak var displacementPicker: UIPickerView!
    @IBOutlet weak var captionLabel: UILabel!
    
    init(filter: Displacement, _ callback: @escaping (Displacement) -> ()) {
        self.filter = filter
        self.selectedMinDisplacement = filter.minDisplacement
        self.selectedMaxDisplacement = filter.maxDisplacement
        self.displacements = filter.displacements
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
        let minDisplacementRow = displacements.firstIndex(of: selectedMinDisplacement) ?? 0
        let maxDisplacementRow = displacements.firstIndex(of: selectedMaxDisplacement) ?? (displacements.count - 1)
        displacementPicker.selectRow(minDisplacementRow, inComponent: minDisplacementPickerComponent, animated: true)
        displacementPicker.selectRow(maxDisplacementRow, inComponent: maxDisplacementPickerComponent, animated: true)
        updateCaptionLabel()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        filter.minDisplacement = selectedMinDisplacement
        filter.maxDisplacement = selectedMaxDisplacement
        callback(filter)
        super.viewWillDisappear(animated)
    }

    // MARK: - UIPickerView Data Source
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return displacements.count
    }
    
    // MARK: - UIPickerView Delegate
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return displacements[row].value.customLocalizedDescription
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch component {
        case minDisplacementPickerComponent:
            selectedMinDisplacement = displacements[row]
        case maxDisplacementPickerComponent:
            selectedMaxDisplacement = displacements[row]
        default:
            return
        }
    }
    
    // MARK: - Private instance methods
    
    @objc private func clearSelection() {
        selectedMinDisplacement = displacements.first!
        selectedMaxDisplacement = displacements.last!
        let minDisplacementRow = 0
        let maxDisplacementRow = displacements.count - 1
        displacementPicker.selectRow(minDisplacementRow, inComponent: minDisplacementPickerComponent, animated: true)
        displacementPicker.selectRow(maxDisplacementRow, inComponent: maxDisplacementPickerComponent, animated: true)
    }
    
    private func updateCaptionLabel() {
        let formatString = NSLocalizedString("Select all motorcycles with displacement between %@ and %@",
                                             comment: "Select all motorcycles with (engine) displacement between %@ and %@ (two measurements, the first has a lower value than the second)")
        captionLabel.text = String.localizedStringWithFormat(formatString,
                                                             selectedMinDisplacement.customLocalizedDescription,
                                                             selectedMaxDisplacement.customLocalizedDescription)
    }
}
