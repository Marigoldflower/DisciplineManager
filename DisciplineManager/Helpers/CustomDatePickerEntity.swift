//
//  CustomDatePicker.swift
//  DisciplineManager
//
//  Created by 황홍필 on 2023/12/29.
//

import UIKit

final class CustomDatePickerEntity: NSObject {
    
    private lazy var pickerView: UIPickerView = {
        let pickerView = UIPickerView()
        pickerView.delegate = self
        pickerView.dataSource = self
        pickerView.backgroundColor = .disciplineCustomDateBackground
        return pickerView
    }()
    
    // MARK: - Picker Data
    let amPm = ["오전", "오후"]
    let hours = (0...12).map { String(format: "%02d", $0) }
    let minutes = (0...59).map { String(format: "%02d", $0) }
    
    var inputView: UIView {
        return pickerView
    }
}

extension CustomDatePickerEntity: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 3
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch component {
        case 0:
            return amPm.count
        case 1:
            return hours.count
        case 2:
            return minutes.count
        default:
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var label: UILabel
        
        if let view = view as? UILabel {
            label = view
        } else {
            label = UILabel()
        }
        
        label.textColor = .disciplineBlack
        label.textAlignment = .center
        label.font = .LINESeedRegular(size: 16)
        
        var text = ""
        
        switch component {
        case 0:
            text = amPm[row]
        case 1:
            text = hours[row]
        case 2:
            text = minutes[row]
        default:
            break
        }
        
        label.text = text
        
        return label
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let selectedAmPm = amPm[pickerView.selectedRow(inComponent: 0)]
        let selectedHour = hours[pickerView.selectedRow(inComponent: 1)]
        let selectedMinute = minutes[pickerView.selectedRow(inComponent: 2)]
        print("\(selectedAmPm) \(selectedHour):\(selectedMinute)")
    }
}
