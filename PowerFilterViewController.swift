//
//  PowerFilterViewController.swift
//  Guzzi Tracker
//
//  Created by Paolo Rocca on 18/04/18.
//  Copyright © 2018 PaoloRocca. All rights reserved.
//

import UIKit

class PowerFilterViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    private let powerFilter: Power
    private let minPowerPickerComponent = 0
    private let maxPowerPickerComponent = 1
    private let powersArray: [Int]
    private let callback: (Power) -> ()
    
    private var selectedMinPower: Int {
        didSet {
            if (selectedMinPower > selectedMaxPower) {
                let row = powersArray.index(of: selectedMinPower) ?? (powersArray.count - 1)
                powerPicker.selectRow(row, inComponent: maxPowerPickerComponent, animated: true)
            }
        }
    }
    
    private var selectedMaxPower: Int {
        didSet {
            if (selectedMaxPower < selectedMinPower) {
                let row = powersArray.index(of: selectedMaxPower) ?? 0
                powerPicker.selectRow(row, inComponent: minPowerPickerComponent, animated: true)
            }
        }
    }
    
    @IBOutlet weak var powerPicker: UIPickerView!
    
    init(filter powerFilter: Power, _ callback: @escaping (Power) -> ()) {
        self.powerFilter = powerFilter
        self.selectedMinPower = Int(powerFilter.minPower)
        self.selectedMaxPower = Int(powerFilter.maxPower)
        self.powersArray = Array(Int(powerFilter.smallestPower.rounded(.up))...Int(powerFilter.biggestPower.rounded(.up)))
        self.callback = callback
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let minPowerRow = powersArray.index(of: selectedMinPower) ?? 0
        let maxPowerRow = powersArray.index(of: selectedMaxPower) ?? (powersArray.count - 1)
        powerPicker.selectRow(minPowerRow, inComponent: minPowerPickerComponent, animated: true)
        powerPicker.selectRow(maxPowerRow, inComponent: maxPowerPickerComponent, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        var newFilter = powerFilter
        newFilter.minPower = Double(selectedMinPower)
        newFilter.maxPower = Double(selectedMaxPower)
        callback(newFilter)
        super.viewWillDisappear(animated)
    }
    
    // MARK: - UIPickerView Data Source
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return powersArray.count
    }
    
    // MARK: UIPickerView Delegate
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return String(powersArray[row])
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch component {
        case minPowerPickerComponent:
            selectedMinPower = powersArray[row]
        case maxPowerPickerComponent:
            selectedMaxPower = powersArray[row]
        default:
            return
        }
    }
}





