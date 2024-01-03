//
//  TimePickerController.swift
//  DisciplineManager
//
//  Created by 황홍필 on 2024/01/02.
//

import UIKit
import SnapKit

final class TimePickerView: UIView {
    
    // MARK: - Data Receiver
    var startTime = Date() {
        didSet {
            setDefaultTime(startTime)
        }
    }
    var endTime = Date() {
        didSet {
            setDefaultTime(endTime)
        }
    }
    
    // MARK: - Picker Data
    let amPm = ["오전", "오후"]
    let hours = (0...12).map { String(format: "%02d", $0) }
    let minutes = (0...59).map { String(format: "%02d", $0) }
    
    // MARK: - UI Components
    private lazy var pickerView: UIPickerView = {
        let pickerView = UIPickerView()
        pickerView.delegate = self
        pickerView.dataSource = self
        pickerView.backgroundColor = .disciplineCustomDateBackground
        return pickerView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private func setDefaultTime(_ time: Date) {
        let calendar = Calendar.current
        
        let hour = calendar.component(.hour, from: time)
        let minute = calendar.component(.minute, from: time)
        
        let amPmRow = hour < 12 ? 0 : 1
        pickerView.selectRow(amPmRow, inComponent: 0, animated: false)
        
        let hourRow = hour % 12
        pickerView.selectRow(hourRow, inComponent: 1, animated: false)
        
        pickerView.selectRow(minute, inComponent: 2, animated: false)
    }
}

extension TimePickerView: ViewDrawable {
    func configureUI() {
        setBackgroundColor()
        setAutolayout()
    }
    
    func setBackgroundColor() {
        self.backgroundColor = .disciplineCustomDateBackground
    }
    
    func setAutolayout() {
        [pickerView].forEach { self.addSubview($0) }
        
        pickerView.snp.makeConstraints { make in
            make.leading.equalTo(self.snp.leading)
            make.trailing.equalTo(self.snp.trailing)
            make.top.equalTo(self.snp.top)
            make.bottom.equalTo(self.safeAreaLayoutGuide.snp.bottom)
        }
    }
}

extension TimePickerView: UIPickerViewDelegate, UIPickerViewDataSource {
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

