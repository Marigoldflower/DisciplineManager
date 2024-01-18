//
//  DetailMemoNavBar.swift
//  DisciplineManager
//
//  Created by 황홍필 on 2024/01/17.
//


import UIKit
import SnapKit

final class DetailMemoNavBar: UIView {
    
    // MARK: - UI Components
    private let navBarTitle: UILabel = {
        let label = UILabel()
        label.font = .LINESeedRegular(size: 16)
        label.textColor = .white
        label.text = "해야 할 일"
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

extension DetailMemoNavBar: ViewDrawable {
    func configureUI() {
        setBackgroundColor()
        setAutolayout()
    }
    
    func setBackgroundColor() {
        self.backgroundColor = .disciplinePurple
    }
    
    func setAutolayout() {
        [navBarTitle].forEach { self.addSubview($0) }
        
        navBarTitle.snp.makeConstraints { make in
            make.center.equalTo(self.snp.center)
        }
    }
}
