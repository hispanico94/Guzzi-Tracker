//
//  StrokeFilterViewController.swift
//  Guzzi Tracker
//
//  Created by Paolo Rocca on 18/04/18.
//  Copyright © 2018 PaoloRocca. All rights reserved.
//

import UIKit

class StrokeFilterViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    private let strokeFilter: Stroke
    private let minStrokePickerComponent = 0
    private let maxStrokePickerComponent = 1
    private let strokesArray: [Int]
    private let callback: (Stroke) -> ()
    
    private var selectedMinStroke: Int {
        didSet {
            if (selectedMinStroke > selectedMaxStroke) {
                let row = strokesArray.index(of: selectedMinStroke) ?? (strokesArray.count - 1)
                strokePicker.selectRow(row, inComponent: maxStrokePickerComponent, animated: true)
            }
        }
    }
    
    private var selectedMaxStroke: Int {
        didSet {
            if (selectedMaxStroke < selectedMinStroke) {
                let row = strokesArray.index(of: selectedMaxStroke) ?? 0
                strokePicker.selectRow(row, inComponent: minStrokePickerComponent, animated: true)
            }
        }
    }
    
    @IBOutlet weak var strokePicker: UIPickerView!
    
    init(filter strokeFilter: Stroke, _ callback: @escaping (Stroke) -> ()) {
        self.strokeFilter = strokeFilter
        self.selectedMinStroke = Int(strokeFilter.minStroke.value)
        self.selectedMaxStroke = Int(strokeFilter.maxStroke.value)
        self.strokesArray = Array(Int(strokeFilter.smallestStroke.value.rounded(.down))...Int(strokeFilter.biggestStroke.value.rounded(.up)))
        self.callback = callback
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let minStrokeRow = strokesArray.index(of: selectedMinStroke) ?? 0
        let maxStrokeRow = strokesArray.index(of: selectedMaxStroke) ?? (strokesArray.count - 1)
        strokePicker.selectRow(minStrokeRow, inComponent: minStrokePickerComponent, animated: true)
        strokePicker.selectRow(maxStrokeRow, inComponent: maxStrokePickerComponent, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        var newFilter = strokeFilter
        newFilter.minStroke = Measurement(value: Double(selectedMinStroke), unit: .millimeters)
        newFilter.maxStroke = Measurement(value: Double(selectedMaxStroke), unit: .millimeters)
        callback(newFilter)
        super.viewWillDisappear(animated)
    }
    
    // MARK: - UIPickerView Data Source
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return strokesArray.count
    }
    
    // MARK: - UIPickerView Delegate
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return String(strokesArray[row])
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch component {
        case minStrokePickerComponent:
            selectedMinStroke = strokesArray[row]
        case maxStrokePickerComponent:
            selectedMaxStroke = strokesArray[row]
        default:
            return
        }
    }
}
