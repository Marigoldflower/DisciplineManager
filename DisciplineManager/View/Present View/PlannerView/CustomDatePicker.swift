//
//  CustomDatePicker.swift
//  DisciplineManager
//
//  Created by 황홍필 on 2023/12/17.
//

import UIKit
import SnapKit

final class CustomDatePicker: UIView {
    
    // MARK: - Time Data
    let periods = ["오전", "오후"]
    let hours = Array(1...12)
    let minutes = Array(0...59)
    
    // MARK: - UI Components
    private let clockImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "clock")
        imageView.tintColor = .disciplinePurple
        return imageView
    }()
    
    private lazy var timePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        let datePickerContainer = UIView()
        datePickerContainer.backgroundColor = .white
        datePickerContainer.addSubview(datePicker)
        datePicker.datePickerMode = .time
        datePicker.date = Date()
        datePicker.timeZone = TimeZone.current
        datePicker.addTarget(self, action: #selector(datePickerChanged(picker:)), for: .valueChanged)
        datePicker.setValue(UIColor.disciplinePurple, forKeyPath: "textColor")
        return datePicker
    }()
    
    // MARK: - Stack
    private lazy var customDatePicker: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [clockImageView, timePicker])
        stack.axis = .horizontal
        stack.spacing = 1
        stack.distribution = .fill
        stack.alignment = .center
        return stack
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    // MARK: - objc
    @objc func datePickerChanged(picker: UIDatePicker) {
        let timeFormatter = DateFormatter()
        timeFormatter.timeStyle = .short
        let selectedTime = timeFormatter.string(from: picker.date)
        print("Selected time: \(selectedTime)")
    }
}

extension CustomDatePicker: ViewDrawable {
    func configureUI() {
        setBackgroundColor()
        setAutolayout()
    }
    
    func setBackgroundColor() {
        self.backgroundColor = .disciplineBackground
    }
    
    func setAutolayout() {
        [customDatePicker].forEach { self.addSubview($0) }
        
        customDatePicker.snp.makeConstraints { make in
            make.center.equalTo(self.snp.center)
        }
        
        clockImageView.snp.makeConstraints { make in
            make.width.height.equalTo(25)
        }
        
        timePicker.snp.makeConstraints { make in
            make.width.equalTo(200)
            make.height.equalTo(40)
        }
    }
}

extension CustomDatePicker: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 3
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 {
            return periods.count
        } else if component == 1 {
            return hours.count
        } else {
            return minutes.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if component == 0 {
            return periods[row]
        } else if component == 1 {
            return "\(hours[row]) 시"
        } else {
            return String(format: "%02d 분", minutes[row])
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let selectedPeriod = periods[pickerView.selectedRow(inComponent: 0)]
        let selectedHour = hours[pickerView.selectedRow(inComponent: 1)]
        let selectedMinute = minutes[pickerView.selectedRow(inComponent: 2)]
        print("Selected time: \(selectedPeriod) \(selectedHour)시 \(selectedMinute)분")
    }
}
