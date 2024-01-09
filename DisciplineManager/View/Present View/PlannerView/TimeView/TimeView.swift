//
//  TimeSettingView.swift
//  DisciplineManager
//
//  Created by 황홍필 on 2023/12/16.
//

import UIKit
import SnapKit

final class TimeView: UIView {
    
    // MARK: - StartTime & EndTime
    lazy var startTime = setStartTimeLabel() {
        didSet {
            startDateButton.currentTime.text = startTime
        }
    }
    lazy var endTime = setEndTimeLabel() {
        didSet {
            endDateButton.currentTime.text = endTime
        }
    }
    
    // MARK: - UI Components
    private let startTimeLabel: UILabel = {
        let label = UILabel()
        label.font = .LINESeedRegular(size: 18)
        label.textColor = .disciplineBlack
        label.text = "시작 시간"
        return label
    }()
    
    lazy var startDateButton: SelectTimePickerView = {
        let view = SelectTimePickerView()
        view.layer.borderWidth = 1.0
        view.layer.borderColor = UIColor.disciplinePurple.cgColor
        view.layer.cornerRadius = 15
        view.layer.masksToBounds = true
        view.currentTime.text = startTime
        return view
    }()
    
    private let endTimeLabel: UILabel = {
        let label = UILabel()
        label.font = .LINESeedRegular(size: 18)
        label.textColor = .disciplineBlack
        label.text = "종료 시간"
        return label
    }()
    
    lazy var endDateButton: SelectTimePickerView = {
        let view = SelectTimePickerView()
        view.layer.borderWidth = 1.0
        view.layer.borderColor = UIColor.disciplinePurple.cgColor
        view.layer.cornerRadius = 15
        view.layer.masksToBounds = true
        view.currentTime.text = endTime
        return view
    }()
    
    // MARK: - StackView
    private lazy var startStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [startTimeLabel, startDateButton])
        stack.axis = .vertical
        stack.spacing = 15
        return stack
    }()
    
    private lazy var endStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [endTimeLabel, endDateButton])
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
        formatter.dateFormat = "a hh:mm"
        let startTime = formatter.string(from: Date())
        
        return startTime
    }
    
    private func setEndTimeLabel() -> String {
        let threeHoursLater = Calendar.current.date(byAdding: .hour, value: 3, to: Date())
        let formatter = DateFormatter()
        formatter.dateFormat = "a hh:mm"
        let endTime = formatter.string(from: threeHoursLater ?? Date())
        
        return endTime
    }
}

extension TimeView: ViewDrawable {
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
        
        startDateButton.snp.makeConstraints { make in
            make.width.equalTo(160)
            make.height.equalTo(40)
        }
        
        endDateButton.snp.makeConstraints { make in
            make.width.equalTo(160)
            make.height.equalTo(40)
        }
    }
}
