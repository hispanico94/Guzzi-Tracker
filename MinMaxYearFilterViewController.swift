//
//  MinMaxYearFilterViewController.swift
//  Guzzi Tracker
//
//  Created by Paolo Rocca on 05/04/18.
//  Copyright © 2018 PaoloRocca. All rights reserved.
//

import UIKit

class MinMaxYearFilterViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    private let minYearPickerComponent = 0
    private let maxYearPickerComponent = 1
    private weak var filter: MinMaxYear?
    private let yearRange: Array<Int>
    
    private var selectedMinYear: Int {
        willSet {
            filter?.minYear = newValue
        }
        didSet {
            if (filter?.minYear != selectedMinYear) {
                selectedMinYear = filter?.minYear ?? getFoundationYear()
                let row = yearRange.index(of: selectedMinYear) ?? 0
                yearPicker.selectRow(row, inComponent: minYearPickerComponent, animated: true)
            }
            if (selectedMinYear > selectedMaxYear) {
                let row = yearRange.index(of: selectedMinYear) ?? (yearRange.count - 1)
                yearPicker.selectRow(row, inComponent: maxYearPickerComponent, animated: true)
            }
        }
    }
    
    private var selectedMaxYear: Int {
        willSet {
            filter?.maxYear = newValue
        }
        didSet {
            if (filter?.maxYear != selectedMaxYear) {
                selectedMaxYear = filter?.maxYear ?? getCurrentYear()
                let row = yearRange.index(of: selectedMaxYear) ?? (yearRange.count - 1)
                yearPicker.selectRow(row, inComponent: maxYearPickerComponent, animated: true)
            }
            if (selectedMaxYear < selectedMinYear) {
                let row = yearRange.index(of: selectedMaxYear) ?? 0
                yearPicker.selectRow(row, inComponent: minYearPickerComponent, animated: true)
            }
        }
    }
    
    @IBOutlet weak var yearPicker: UIPickerView!
    
    
    init(minMaxYear filter: MinMaxYear) {
        self.filter = filter
        yearRange = Array(filter.yearRange)
        selectedMinYear = filter.minYear
        selectedMaxYear = filter.maxYear
        super.init(nibName: "MinMaxYearFilterViewController", bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return yearRange.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return String(yearRange[row])
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch component {
        case 0:
            selectedMinYear = yearRange[row]
        case 1:
            selectedMaxYear = yearRange[row]
        default:
            return
        }
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        let minYearRow = yearRange.index(of: selectedMinYear) ?? 0
        let maxYearRow = yearRange.index(of: selectedMaxYear) ?? (yearRange.count - 1)
        yearPicker.selectRow(minYearRow, inComponent: minYearPickerComponent, animated: true)
        yearPicker.selectRow(maxYearRow, inComponent: maxYearPickerComponent, animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
