//
//  WhatToDoView.swift
//  DisciplineManager
//
//  Created by 황홍필 on 2023/12/16.
//

import UIKit
import SnapKit

final class TaskView: UIView {
    
    // MARK: - UI Components
    private let taskLabel: UILabel = {
        let label = UILabel()
        label.font = .LINESeedRegular(size: 18)
        label.textColor = .disciplineBlack
        label.text = "해야 할 일"
        return label
    }()
    
    let taskTextField: UITextField = {
        let textField = UITextField()
        textField.layer.cornerRadius = 15
        textField.layer.borderColor = UIColor.disciplinePurple.cgColor
        textField.layer.borderWidth = 1.0
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: textField.frame.height)) // 원하는 패딩 크기로 변경
        textField.leftView = paddingView
        textField.leftViewMode = .always
        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.LINESeedRegular(size: 15) as Any
        ]
        textField.attributedPlaceholder = NSAttributedString(string: "해야 할 일을 적어주세요 😚", attributes: attributes)
        return textField
    }()
    
    // MARK: - StackView
    private lazy var taskStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [taskLabel, taskTextField])
        stack.axis = .vertical
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

extension TaskView: ViewDrawable {
    func configureUI() {
        setBackgroundColor()
        setAutolayout()
    }
    
    func setBackgroundColor() {
        self.backgroundColor = .red
    }
    
    func setAutolayout() {
        [taskStack].forEach { self.addSubview($0) }
        
        taskStack.snp.makeConstraints { make in
            make.leading.equalTo(self.snp.leading).offset(20)
            make.top.equalTo(self.safeAreaLayoutGuide.snp.top).offset(20)
        }
        
        taskTextField.snp.makeConstraints { make in
            make.leading.equalTo(self.snp.leading).offset(20)
            make.trailing.equalTo(self.snp.trailing).offset(-20)
            make.height.equalTo(50)
        }
    }
}
