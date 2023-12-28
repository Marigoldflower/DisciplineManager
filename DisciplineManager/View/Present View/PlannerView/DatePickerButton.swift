//
//  CustomDatePicker.swift
//  DisciplineManager
//
//  Created by 황홍필 on 2023/12/17.
//

import UIKit
import SnapKit

final class DatePickerButton: UIButton {
    
    // MARK: - UI Components
    private let clockImageView: UIImageView = {
        let imageView = UIImageView()
        let largeConfig = UIImage.SymbolConfiguration(pointSize: 15, weight: .light, scale: .large)
        let largeCloseImage = UIImage(systemName: "clock", withConfiguration: largeConfig)
        imageView.image = largeCloseImage
        imageView.tintColor = .disciplinePurple
        return imageView
    }()
    
    private let timeSelect: UILabel = {
        let label = UILabel()
        label.text = "06:00 PM"
        label.textColor = .disciplineBlack
        label.font = .LINESeedRegular(size: 15)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
}

extension DatePickerButton: ViewDrawable {
    func configureUI() {
        setBackgroundColor()
        setAutolayout()
    }
    
    func setBackgroundColor() {
        self.backgroundColor = .disciplineBackground
    }
    
    func setAutolayout() {
        [clockImageView, timeSelect].forEach { self.addSubview($0) }
        
        clockImageView.snp.makeConstraints { make in
            make.centerY.equalTo(self.snp.centerY)
            make.leading.equalTo(self.snp.leading).offset(10)
        }
        
        timeSelect.snp.makeConstraints { make in
            make.centerY.equalTo(self.snp.centerY)
            make.leading.equalTo(clockImageView.snp.trailing).offset(10)
        }
    }
}
