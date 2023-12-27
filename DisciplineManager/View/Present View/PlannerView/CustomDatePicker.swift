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
        let largeConfig = UIImage.SymbolConfiguration(pointSize: 15, weight: .light, scale: .large)
        let largeCloseImage = UIImage(systemName: "clock", withConfiguration: largeConfig)
        imageView.image = largeCloseImage
        imageView.tintColor = .disciplinePurple
        return imageView
    }()
    
    private let timeSelect: UIButton = {
        let button = UIButton()
        button.setTitle("06:00 PM", for: .normal)
        button.setTitleColor(.disciplineBlack, for: .normal)
        button.titleLabel?.font = .LINESeedRegular(size: 15)
        return button
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
