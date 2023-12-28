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
    
    lazy var startDatePicker: DatePickerButton = {
        let datePicker = DatePickerButton()
        datePicker.layer.borderColor = UIColor.disciplinePurple.cgColor
        datePicker.layer.borderWidth = 1.0
        datePicker.layer.cornerRadius = 10
        datePicker.layer.masksToBounds = true
        return datePicker
    }()
    
    private let endTimeLabel: UILabel = {
        let label = UILabel()
        label.font = .LINESeedRegular(size: 18)
        label.textColor = .disciplineBlack
        label.text = "종료 시간"
        return label
    }()
    
    lazy var endDatePicker: DatePickerButton = {
        let datePicker = DatePickerButton()
        datePicker.layer.borderColor = UIColor.disciplinePurple.cgColor
        datePicker.layer.borderWidth = 1.0
        datePicker.layer.cornerRadius = 10
        datePicker.layer.masksToBounds = true
        return datePicker
    }()
    
    // MARK: - StackView
    private lazy var startStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [startTimeLabel, startDatePicker])
        stack.axis = .vertical
        stack.spacing = 15
        return stack
    }()
    
    private lazy var endStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [endTimeLabel, endDatePicker])
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
   
}

extension TimeSettingView: ViewDrawable {
    func configureUI() {
        setBackgroundColor()
        setAutolayout()
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
        
        startDatePicker.snp.makeConstraints { make in
            make.width.equalTo(160)
            make.height.equalTo(40)
        }
        
        endDatePicker.snp.makeConstraints { make in
            make.width.equalTo(160)
            make.height.equalTo(40)
        }
    }
}
