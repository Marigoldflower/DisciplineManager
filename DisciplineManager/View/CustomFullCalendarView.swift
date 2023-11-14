//
//  CustomFullCalendarView.swift
//  DisciplineManager
//
//  Created by 황홍필 on 2023/11/13.
//

import UIKit

final class CustomFullCalendarView: UIView {
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }

}

extension CustomFullCalendarView: ViewDrawable {
    func configureUI() {
        setBackgroundColor()
        setAutolayout()
    }
    
    func setBackgroundColor() {
        backgroundColor = .white
    }
    
    func setAutolayout() {
        
    }
}
