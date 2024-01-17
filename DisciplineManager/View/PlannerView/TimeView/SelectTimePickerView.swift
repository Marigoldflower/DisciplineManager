//
//  SelectTimePickerView.swift
//  DisciplineManager
//
//  Created by 황홍필 on 2024/01/02.
//

import UIKit
import SnapKit

final class SelectTimePickerView: UIView {
    
    // MARK: - UI Components
    private let clockImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "clock")
        imageView.tintColor = .disciplinePurple
        return imageView
    }()

    lazy var currentTime: UILabel = {
        let label = UILabel()
        label.font = .LINESeedRegular(size: 16)
        label.textColor = .disciplineBlack
        return label
    }()
    
    // MARK: - StackView
    private lazy var stackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [clockImage, currentTime])
        stack.axis = .horizontal
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

extension SelectTimePickerView: ViewDrawable {
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
