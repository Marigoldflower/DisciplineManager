//
//  CustomDatePicker.swift
//  DisciplineManager
//
//  Created by 황홍필 on 2023/12/17.
//

import UIKit
import SnapKit

final class CustomDatePicker: UIView {

    // MARK: - UI Components
    private let clockImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "clock")
        imageView.tintColor = .disciplinePurple
        return imageView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }

}

extension CustomDatePicker: ViewDrawable {
    func configureUI() {
        setBackgroundColor()
        setAutolayout()
    }
    
    func setBackgroundColor() {
        
    }
    
    func setAutolayout() {
        
    }
}
