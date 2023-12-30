//
//  DatePickerView.swift
//  DisciplineManager
//
//  Created by 황홍필 on 2023/12/29.
//

import UIKit

// 여기에 "clock" 이미지와 현재 시간을 적은 label을 만들면 된다.
final class CustomDatePickerView: UIView {

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
        
    }
}



