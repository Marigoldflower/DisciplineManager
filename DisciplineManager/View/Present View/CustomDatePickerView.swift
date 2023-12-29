//
//  CustomDatePickerView.swift
//  DisciplineManager
//
//  Created by 황홍필 on 2023/12/29.
//

import UIKit
import SnapKit

final class CustomDatePickerView: UIView {
    
    // MARK: - UI Components
    
    
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
        self.backgroundColor = .disciplineCustomDateBackground
    }
    
    func setAutolayout() {
        
    }
}
