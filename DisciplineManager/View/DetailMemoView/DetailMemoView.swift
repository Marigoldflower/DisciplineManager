//
//  DetailMemoView.swift
//  DisciplineManager
//
//  Created by 황홍필 on 2024/01/17.
//


import UIKit
import SnapKit

final class DetailMemoView: UIView {
    // MARK: - UI Components
    let navBar: UIView = {
        let navBar = UIView()
        navBar.backgroundColor = .disciplinePurple
        return navBar
    }()
    
    
    
    let plan: UILabel = {
        let label = UILabel()
        label.font = .LINESeedRegular(size: 15)
        return label
    }()
    
    let detailPlan: UILabel = {
        let label = UILabel()
        label.font = .LINESeedRegular(size: 14)
        return label
    }()
    
//    // MARK: - Stack
//    private lazy var stackView: UIStackView = {
//        let stack = UIStackView(arrangedSubviews: [plan, detailPlan])
//        stack.axis = .vertical
//        stack.spacing = 5
//        return stack
//    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
}

extension DetailMemoView: ViewDrawable {
    func configureUI() {
        setBackgroundColor()
        setAutolayout()
    }
    
    func setBackgroundColor() {
        self.backgroundColor = .disciplineBackground
    }
    
    func setAutolayout() {
        [navBar, plan, detailPlan].forEach { self.addSubview($0) }
        
        navBar.snp.makeConstraints { make in
            make.leading.equalTo(self.snp.leading)
            make.trailing.equalTo(self.snp.trailing)
            make.top.equalTo(self.snp.top)
            make.height.equalTo(40)
        }
        
        plan.snp.makeConstraints { make in
            make.leading.equalTo(self.snp.leading).offset(15)
            make.top.equalTo(navBar.snp.bottom).offset(15)
        }
        
        detailPlan.snp.makeConstraints { make in
            make.leading.equalTo(self.snp.leading).offset(15)
            make.top.equalTo(plan.snp.bottom).offset(15)
        }
    }
}
