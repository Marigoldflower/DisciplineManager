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
    var startTimeReceiver = Date() {
        didSet {
            setTimeToPickerViewIndex(with: startTimeReceiver)
            setTimeWhenSelectButtonIsTapped(with: startTimeReceiver)
        }
    }
    var endTimeReceiver = Date() {
        didSet {
            setTimeToPickerViewIndex(with: endTimeReceiver)
            setTimeWhenSelectButtonIsTapped(with: endTimeReceiver)
        }
    }
    
    // MARK: - Selected PickerData
    var selectedAmPm = String()
    var selectedHour = String()
    var selectedMinute = String()
    
    // MARK: - Picker Data
    let amPm = ["오전", "오후"]
    let hours = (1...12).map { String(format: "%02d", $0) }
    let minutes = (0...59).map { String(format: "%02d", $0) }
    
    // MARK: - UI Components
    let selectButton: UIButton = {
        let button = UIButton()
        button.setTitle("선택", for: .normal)
        button.setTitleColor(.disciplinePurple, for: .normal)
        button.titleLabel?.font = .LINESeedRegular(size: 15)
        return button
    }()
    
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
    
    private func setTimeWhenSelectButtonIsTapped(with time: Date) {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "a hh mm"

        let timeString = formatter.string(from: time)
        let timeComponents = timeString.components(separatedBy: " ")

        if timeComponents.count == 3 {
            selectedAmPm = timeComponents[0]
            selectedHour = timeComponents[1]
            selectedMinute = timeComponents[2]
        }
    }
    
    private func setTimeToPickerViewIndex(with time: Date) {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "a hh mm"

        let timeString = formatter.string(from: time)
        let timeComponents = timeString.components(separatedBy: " ")
        
        setAmPm(with: timeComponents[0])
        setHour(with: timeComponents[1])
        setMinute(with: timeComponents[2])
    }
    
    private func setAmPm(with timeComponents: String) {
        if timeComponents == "오전" {
            pickerView.selectRow(0, inComponent: 0, animated: false)
        } else {
            pickerView.selectRow(1, inComponent: 0, animated: false)
        }
    }
    
    private func setHour(with timeComponents: String) {
        guard let hour = Int(timeComponents) else { return }
        pickerView.selectRow(hour - 1, inComponent: 1, animated: false)
    }
    
    private func setMinute(with timeComponents: String) {
        guard let minute = Int(timeComponents) else { return }
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
        [selectButton, pickerView].forEach { self.addSubview($0) }
        
        selectButton.snp.makeConstraints { make in
            make.trailing.equalTo(self.snp.trailing).offset(-10)
            make.top.equalTo(self.snp.top).offset(5)
        }
        
        pickerView.snp.makeConstraints { make in
            make.leading.equalTo(self.snp.leading)
            make.trailing.equalTo(self.snp.trailing)
            make.top.equalTo(selectButton.snp.bottom)
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
        
        print("현재의 시간? \(selectedAmPm) \(selectedHour) \(selectedMinute)")
        
        self.selectedAmPm = selectedAmPm
        self.selectedHour = selectedHour
        self.selectedMinute = selectedMinute 
    }
}

