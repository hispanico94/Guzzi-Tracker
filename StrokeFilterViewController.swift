//
//  StrokeFilterViewController.swift
//  Guzzi Tracker
//
//  Created by Paolo Rocca on 18/04/18.
//  Copyright © 2018 PaoloRocca. All rights reserved.
//

import UIKit

class StrokeFilterViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    private var filter: Stroke
    private let minStrokePickerComponent = 0
    private let maxStrokePickerComponent = 1
    private let strokes: [Measurement<UnitLength>]
    private let callback: (Stroke) -> ()
    
    private var selectedMinStroke: Measurement<UnitLength> {
        didSet {
            if (selectedMinStroke > selectedMaxStroke) {
                selectedMaxStroke = selectedMinStroke
                let row = strokes.index(of: selectedMinStroke) ?? (strokes.count - 1)
                strokePicker.selectRow(row, inComponent: maxStrokePickerComponent, animated: true)
            }
        }
    }
    
    private var selectedMaxStroke: Measurement<UnitLength> {
        didSet {
            if (selectedMaxStroke < selectedMinStroke) {
                selectedMinStroke = selectedMaxStroke
                let row = strokes.index(of: selectedMaxStroke) ?? 0
                strokePicker.selectRow(row, inComponent: minStrokePickerComponent, animated: true)
            }
        }
    }
    
    @IBOutlet weak var strokePicker: UIPickerView!
    
    init(filter: Stroke, _ callback: @escaping (Stroke) -> ()) {
        self.filter = filter
        self.selectedMinStroke = filter.minStroke
        self.selectedMaxStroke = filter.maxStroke
        self.strokes = filter.strokes
        self.callback = callback
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = filter.title
        let minStrokeRow = strokes.index(of: selectedMinStroke) ?? 0
        let maxStrokeRow = strokes.index(of: selectedMaxStroke) ?? (strokes.count - 1)
        strokePicker.selectRow(minStrokeRow, inComponent: minStrokePickerComponent, animated: true)
        strokePicker.selectRow(maxStrokeRow, inComponent: maxStrokePickerComponent, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        filter.minStroke = selectedMinStroke
        filter.maxStroke = selectedMaxStroke
        callback(filter)
        super.viewWillDisappear(animated)
    }
    
    // MARK: - UIPickerView Data Source
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return strokes.count
    }
    
    // MARK: - UIPickerView Delegate
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return strokes[row].value.descriptionWithDecimalsIfPresent
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch component {
        case minStrokePickerComponent:
            selectedMinStroke = strokes[row]
        case maxStrokePickerComponent:
            selectedMaxStroke = strokes[row]
        default:
            return
        }
    }
}
