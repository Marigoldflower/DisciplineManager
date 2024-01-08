//
//  PriorityView.swift
//  DisciplineManager
//
//  Created by 황홍필 on 2023/12/16.
//

import UIKit
import SnapKit

enum PriorityButtonType: String {
    case high
    case medium
    case low
}

final class PriorityView: UIView {
    // MARK: - Data
    lazy var buttons: [UIButton] = [highButton, mediumButton, lowButton]
    
    // MARK: - UI Components
    private let priorityLabel: UILabel = {
        let label = UILabel()
        label.font = .LINESeedRegular(size: 18)
        label.textColor = .disciplineBlack
        label.text = "중요도"
        return label
    }()
    
    let highButton: UIButton = {
        let button = UIButton()
        button.layer.borderWidth = 1.0
        button.layer.borderColor = UIColor.disciplinePink.cgColor
        button.layer.cornerRadius = 15
        button.layer.masksToBounds = true
        button.setTitle("High", for: .normal)
        button.titleLabel?.font = .LINESeedRegular(size: 16)
        button.setTitleColor(.disciplineBlack, for: .normal)
        return button
    }()
    
    let mediumButton: UIButton = {
        let button = UIButton()
        button.layer.borderWidth = 1.0
        button.layer.borderColor = UIColor.disciplineYellow.cgColor
        button.layer.cornerRadius = 15
        button.layer.masksToBounds = true
        button.setTitle("Medium", for: .normal)
        button.titleLabel?.font = .LINESeedRegular(size: 16)
        button.setTitleColor(.disciplineBlack, for: .normal)
        return button
    }()
    
    let lowButton: UIButton = {
        let button = UIButton()
        button.layer.borderWidth = 1.0
        button.layer.borderColor = UIColor.disciplineBlue.cgColor
        button.layer.cornerRadius = 15
        button.layer.masksToBounds = true
        button.setTitle("Low", for: .normal)
        button.titleLabel?.font = .LINESeedRegular(size: 16)
        button.setTitleColor(.disciplineBlack, for: .normal)
        return button
    }()
    
    // MARK: - Stack
    private lazy var buttonStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [highButton, mediumButton, lowButton])
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        stack.spacing = 10
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

extension PriorityView: ViewDrawable {
    func configureUI() {
        setBackgroundColor()
        setAutolayout()
    }
    
    func setBackgroundColor() {
        self.backgroundColor = .disciplineBackground
    }
    
    func setAutolayout() {
        [priorityLabel, buttonStackView].forEach { self.addSubview($0) }
        
        priorityLabel.snp.makeConstraints { make in
            make.leading.equalTo(self.snp.leading).offset(20)
            make.top.equalTo(self.snp.top).offset(20)
        }
        
        buttonStackView.snp.makeConstraints { make in
            make.leading.equalTo(self.snp.leading).offset(20)
            make.trailing.equalTo(self.snp.trailing).offset(-20)
            make.top.equalTo(priorityLabel.snp.bottom).offset(15)
            make.height.equalTo(45)
        }
    }
}
