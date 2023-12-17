//
//  PriorityView.swift
//  DisciplineManager
//
//  Created by 황홍필 on 2023/12/16.
//

import UIKit

final class PriorityView: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}

extension PriorityView: ViewDrawable {
    func configureUI() {
        setBackgroundColor()
        setAutolayout()
    }
    
    func setBackgroundColor() {
        self.backgroundColor = .green
    }
    
    func setAutolayout() {
        
    }
}
