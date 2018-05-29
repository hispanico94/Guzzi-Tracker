import UIKit

class MinMaxYearFilterViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    private let minYearPickerComponent = 0
    private let maxYearPickerComponent = 1
    private let yearsArray = Array(getFoundationYear()...getCurrentYear())
    private let callback: (MinMaxYear) -> ()
    
    private var selectedMinYear: Int {
        didSet {
            if (selectedMinYear > selectedMaxYear) {
                selectedMaxYear = selectedMinYear
                let row = yearsArray.index(of: selectedMinYear) ?? (yearsArray.count - 1)
                yearPicker.selectRow(row, inComponent: maxYearPickerComponent, animated: true)
            }
            updateCaptionLabel()
        }
    }

    private var selectedMaxYear: Int {
        didSet {
            if (selectedMaxYear < selectedMinYear) {
                selectedMinYear = selectedMaxYear
                let row = yearsArray.index(of: selectedMaxYear) ?? 0
                yearPicker.selectRow(row, inComponent: minYearPickerComponent, animated: true)
            }
            updateCaptionLabel()
        }
    }
    
    @IBOutlet weak var yearPicker: UIPickerView!
    @IBOutlet weak var captionLabel: UILabel!
    
    init(minYear: Int, maxYear: Int, _ callback: @escaping (MinMaxYear) -> ()) {
        self.callback = callback
        selectedMinYear = minYear
        selectedMaxYear = maxYear
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Years interval"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "Clear", style: .plain, target: self, action: #selector(clearSelection))
        let minYearRow = yearsArray.index(of: selectedMinYear) ?? 0
        let maxYearRow = yearsArray.index(of: selectedMaxYear) ?? (yearsArray.count - 1)
        yearPicker.selectRow(minYearRow, inComponent: minYearPickerComponent, animated: true)
        yearPicker.selectRow(maxYearRow, inComponent: maxYearPickerComponent, animated: true)
        updateCaptionLabel()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        let filter = MinMaxYear(minYear: selectedMinYear, maxYear: selectedMaxYear)
        callback(filter)
        super.viewWillDisappear(animated)
    }
    
    // MARK: - UIPickerView Data Source
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return yearsArray.count
    }
    
    // MARK: - UIPickerView Delegate
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return String(yearsArray[row])
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch component {
        case minYearPickerComponent:
            selectedMinYear = yearsArray[row]
        case maxYearPickerComponent:
            selectedMaxYear = yearsArray[row]
        default:
            return
        }
    }
    
    // MARK: - Private instance methods
    
    @objc private func clearSelection() {
        selectedMinYear = yearsArray.first!
        selectedMaxYear = yearsArray.last!
        let minYearRow = 0
        let maxYearRow = yearsArray.count - 1
        yearPicker.selectRow(minYearRow, inComponent: minYearPickerComponent, animated: true)
        yearPicker.selectRow(maxYearRow, inComponent: maxYearPickerComponent, animated: true)
    }
    
    private func updateCaptionLabel() {
        captionLabel.text = "Filter all motorcycles built from \(selectedMinYear) to \(selectedMaxYear)"
    }
}
