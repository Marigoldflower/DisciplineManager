//
//  DatePickerView.swift
//  DisciplineManager
//
//  Created by 황홍필 on 2023/12/29.
//

import UIKit
import SnapKit

// 여기에 "clock" 이미지와 현재 시간을 적은 label을 만들면 된다.
final class CustomDatePickerView: UIView {
    
    // MARK: - UI Components
    private let clockImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "clock")
        imageView.tintColor = .disciplinePurple
        return imageView
    }()

    let currentTime: UILabel = {
        let label = UILabel()
        label.font = .LINESeedRegular(size: 16)
        label.textColor = .disciplineBlack
        return label
    }()
    
    // MARK: - StackView
    private lazy var stackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [clockImage, currentTime])
        stack.axis = .horizontal
        stack.spacing = 2
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

extension CustomDatePickerView: ViewDrawable {
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
            make.leading.equalTo(self.snp.leading).offset(15)
            make.centerY.equalTo(self.snp.centerY)
        }
    }
}



