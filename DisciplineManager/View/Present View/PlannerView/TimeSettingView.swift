//
//  TimeSettingView.swift
//  DisciplineManager
//
//  Created by 황홍필 on 2023/12/16.
//

import UIKit
import SnapKit

final class TimeSettingView: UIView {
    
    // MARK: - UI Components
    private let startTimeLabel: UILabel = {
        let label = UILabel()
        label.font = .LINESeedRegular(size: 18)
        label.textColor = .disciplineBlack
        label.text = "시작 시간"
        return label
    }()
    
    private lazy var startDateView: UIView = {
        let view = UIView()
        return view
    }()
    
    lazy var startDatePickerEntity: CustomDatePickerEntity = {
        let datePickerEntity = CustomDatePickerEntity()
        return datePickerEntity
    }()
    
    private let endTimeLabel: UILabel = {
        let label = UILabel()
        label.font = .LINESeedRegular(size: 18)
        label.textColor = .disciplineBlack
        label.text = "종료 시간"
        return label
    }()
    
    private lazy var endDateView: UIView = {
        let view = UIView()
        return view
    }()
    
    lazy var endDatePickerEntity: CustomDatePickerEntity = {
        let datePickerEntity = CustomDatePickerEntity()
        return datePickerEntity
    }()
    
    // MARK: - StackView
    private lazy var startStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [startTimeLabel, startDateView])
        stack.axis = .vertical
        stack.spacing = 15
        return stack
    }()
    
    private lazy var endStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [endTimeLabel, endDateView])
        stack.axis = .vertical
        stack.spacing = 15
        return stack
    }()
    
    private lazy var totalStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [startStack, endStack])
        stack.axis = .horizontal
        stack.spacing = 15
        return stack
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
   
    private func setStartTimeLabel() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "  a hh:mm"
        let startTime = formatter.string(from: Date())
        
        return startTime
    }
    
    private func setEndTimeLabel() -> String {
        let threeHoursLater = Calendar.current.date(byAdding: .hour, value: 3, to: Date())
        let formatter = DateFormatter()
        formatter.dateFormat = "  a hh:mm"
        let endTime = formatter.string(from: threeHoursLater ?? Date())
        
        return endTime
    }
}

extension TimeSettingView: ViewDrawable {
    func configureUI() {
        setBackgroundColor()
        setAutolayout()
        setTextFieldUI(of: startTextField)
        setTextFieldUI(of: endTextField)
        makeCustom(datePicker: startDatePicker, with: startTextField)
        makeCustom(datePicker: endDatePicker, with: endTextField)
    }
    
    func setBackgroundColor() {
        self.backgroundColor = .disciplineBackground
    }
    
    func setAutolayout() {
        [totalStack].forEach { self.addSubview($0) }
        
        totalStack.snp.makeConstraints { make in
            make.leading.equalTo(self.snp.leading).offset(20)
            make.top.equalTo(self.snp.top).offset(20)
        }
        
        endDateView.snp.makeConstraints { make in
            make.width.equalTo(160)
            make.height.equalTo(40)
        }
        
        endTextField.snp.makeConstraints { make in
            make.width.equalTo(160)
            make.height.equalTo(40)
        }
    }
    
    private func makeCustom(datePicker: CustomDatePicker, with textField: UITextField) {
        textField.inputView = datePicker.inputView
    }
    
    private func setTextFieldUI(of textField: UITextField) {
        setTextFieldBorder(of: textField)
        setTextFieldPadding(of: textField)
        setTextFieldImage(of: textField)
        setTextFieldText(of: textField)
        removeTextFieldCursor(of: textField)
    }
    
    private func setTextFieldBorder(of textField: UITextField) {
        textField.layer.cornerRadius = 15
        textField.layer.borderColor = UIColor.disciplinePurple.cgColor
        textField.layer.borderWidth = 1.0
    }
    
    private func setTextFieldPadding(of textField: UITextField) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 35, height: textField.frame.height))
        textField.leftView = paddingView
        textField.leftViewMode = .always
    }
    
    private func setTextFieldImage(of textField: UITextField) {
        let imageView = UIImageView()
        let largeConfig = UIImage.SymbolConfiguration(pointSize: 15, weight: .light, scale: .large)
        let largeCloseImage = UIImage(systemName: "clock", withConfiguration: largeConfig)
        imageView.image = largeCloseImage
        imageView.tintColor = .disciplinePurple
        textField.rightView = imageView
        textField.rightViewMode = .always
    }
    
    private func setTextFieldText(of textField: UITextField) {
        textField.attributedPlaceholder = NSAttributedString(string: textField.placeholder ?? "", attributes: [NSAttributedString.Key.foregroundColor: UIColor.disciplineBlack])
        textField.font = .LINESeedRegular(size: 15)
    }
    
    private func removeTextFieldCursor(of textField: UITextField) {
        textField.tintColor = .clear
    }
}

extension TimeSettingView: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return false
    }
}
