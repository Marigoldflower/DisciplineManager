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
    let navBar: DetailMemoNavBar = {
        let navBar = DetailMemoNavBar()
        return navBar
    }()
    
    lazy var taskTextField: UITextField = {
        let textField = UITextField()
        textField.layer.cornerRadius = 15
        textField.layer.borderColor = UIColor.disciplinePurple.cgColor
        textField.layer.borderWidth = 1.0
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: textField.frame.height)) // 원하는 패딩 크기로 변경
        textField.leftView = paddingView
        textField.leftViewMode = .always
        let attributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.lightGray,
            .font: UIFont.LINESeedRegular(size: 15) as Any
        ]
        textField.attributedPlaceholder = NSAttributedString(string: "해야 할 일을 적어주세요 😚", attributes: attributes)
        return textField
    }()
    
    lazy var detailTaskTextView: UITextView = {
        let textView = UITextView()
        textView.layer.cornerRadius = 15
        textView.layer.borderColor = UIColor.disciplinePurple.cgColor
        textView.layer.borderWidth = 1.0
        textView.backgroundColor = .disciplineBackground
        textView.text = "더 기록해야 할 추가적인 정보는 여기에 적어주세요 😚"
        textView.textColor = UIColor.lightGray
        textView.font = .LINESeedRegular(size: 14)
        textView.textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 0, right: 0)
        return textView
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
