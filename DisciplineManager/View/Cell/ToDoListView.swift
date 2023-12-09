//
//  ToDoList.swift
//  DisciplineManager
//
//  Created by 황홍필 on 2023/12/06.
//

import UIKit
import SnapKit

final class ToDoListView: UIView {
    // MARK: - UI Components
    let checkButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "square"), for: .normal)
        button.setImage(UIImage(systemName: "checkmark.square.fill"), for: .selected)
        button.tintColor = .disciplinePurple
        return button
    }()
    
    let time: UILabel = {
        let label = UILabel()
        label.font = .LINESeedRegular(size: 15.0)
        label.text = ""
        return label
    }()
    
    let whatToDo: UILabel = {
        let label = UILabel()
        label.font = .LINESeedRegular(size: 15.0)
        label.text = ""
        label.numberOfLines = 0
        return label
    }()
    
    lazy var whatToDoErased: UILabel = {
        let label = UILabel()
        label.font = .LINESeedRegular(size: 15.0)
        label.numberOfLines = 0
        let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: whatToDo.text!)
        attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSMakeRange(0, attributeString.length))
        label.attributedText = attributeString
        return label
    }()
    
    let trashButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "trash"), for: .normal)
        button.tintColor = .disciplinePurple
        return button
    }()
    
    // MARK: - StackView
    private lazy var timeAndWhatToDoStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [time, whatToDo])
        stack.axis = .vertical
        stack.spacing = 8
        return stack
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
}

extension ToDoListView: ViewDrawable {
    func configureUI() {
        setBackgroundColor()
        setAutolayout()
    }
    
    func setBackgroundColor() {
        self.backgroundColor = .disciplineBackground
    }
    
    func setAutolayout() {
        [checkButton, timeAndWhatToDoStack, whatToDoErased, trashButton].forEach { self.addSubview($0)}
        
        checkButton.snp.makeConstraints { make in
            make.leading.equalTo(self.snp.leading).offset(20)
            make.centerY.equalTo(self.snp.centerY)
        }
        
        timeAndWhatToDoStack.snp.makeConstraints { make in
            make.leading.equalTo(checkButton.snp.trailing).offset(30)
            make.trailing.equalTo(trashButton.snp.leading).offset(-30)
            make.centerY.equalTo(self.snp.centerY)
        }
        
        // 할 일 목록 지워진 버전을 할 일 목록과 겹쳐놓는다.
        whatToDoErased.snp.makeConstraints { make in
            make.edges.equalTo(whatToDo)
        }
        
        trashButton.snp.makeConstraints { make in
            make.trailing.equalTo(self.snp.trailing).offset(-20)
            make.centerY.equalTo(self.snp.centerY)
        }
    }
}
