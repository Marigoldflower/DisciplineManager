//
//  HowManyTimesToRepeat.swift
//  DisciplineManager
//
//  Created by 황홍필 on 2024/01/05.
//

import UIKit
import SnapKit

final class HowManyTimesToRepeatTheTask: UIView {
    
    // MARK: - SelectedRepetition
    var selectedRepetition: String = "매일"
    
    // MARK: - UI Components
    private let repeatLabel: UILabel = {
        let label = UILabel()
        label.font = .LINESeedRegular(size: 18)
        label.textColor = .disciplineBlack
        label.text = "반복"
        return label
    }()
    
    private lazy var segmentedControl: UISegmentedControl = {
        let segment = UISegmentedControl(items: ["하루만", "매일", "주간", "월간"])
        segment.layer.borderWidth = 1.0
        segment.layer.borderColor = UIColor.disciplinePurple.cgColor
        segment.setTitleTextAttributes(setSegmentControlAttributedText(with: .disciplineBlack), for: .normal)
        segment.setTitleTextAttributes(setSegmentControlAttributedText(with: .white), for: .selected)
        segment.backgroundColor = .white
        segment.selectedSegmentTintColor = .disciplinePurple
        segment.selectedSegmentIndex = 1
        selectedRepetition = segment.titleForSegment(at: segment.selectedSegmentIndex)!
        segment.layer.cornerRadius = 15
        segment.layer.masksToBounds = true
        return segment
    }()
    
    // MARK: - Stack
    private lazy var stackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [repeatLabel, segmentedControl])
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

extension HowManyTimesToRepeatTheTask: ViewDrawable {
    func configureUI() {
        setBackgroundColor()
        setAutolayout()
    }
    
    func setBackgroundColor() {
        self.backgroundColor = .disciplineBackground
    }
    
    func setAutolayout() {
        [stackView].forEach { self.addSubview($0) }
        
        stackView.snp.makeConstraints { make in
            make.leading.equalTo(self.snp.leading).offset(20)
            make.top.equalTo(self.snp.top).offset(20)
        }
        
        segmentedControl.snp.makeConstraints { make in
            make.leading.equalTo(self.snp.leading).offset(20)
            make.trailing.equalTo(self.snp.trailing).offset(-20)
            make.height.equalTo(45)
        }
    }
    
    private func setSegmentControlAttributedText(with color: UIColor) -> [NSAttributedString.Key : Any]? {
        let textAttributes: [NSAttributedString.Key : Any] = [
            .foregroundColor: color,
            .font: UIFont.LINESeedRegular(size: 15) as Any
        ]
        
        return textAttributes
    }
}
