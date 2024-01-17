//
//  ToDoList.swift
//  DisciplineManager
//
//  Created by 황홍필 on 2023/12/06.
//

import UIKit
import SnapKit

final class ToDoListView: UIView {
    
    // MARK: - Erased Label Data
    var isStrikethrough: Bool = false
    
    // MARK: - UI Components
    lazy var checkButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "square"), for: .normal)
        button.setImage(UIImage(systemName: "checkmark.square.fill"), for: .selected)
        button.tintColor = .disciplinePurple
        button.addTarget(self, action: #selector(checkButtonTapped), for: .touchUpInside)
        return button
    }()
    
    let time: UILabel = {
        let label = UILabel()
        label.font = .LINESeedRegular(size: 15.0)
        label.textColor = .systemGray
        label.text = ""
        return label
    }()
    
    let plan: UILabel = {
        let label = UILabel()
        label.font = .LINESeedRegular(size: 15.0)
        label.textColor = .disciplineBlack
        label.text = ""
        label.numberOfLines = 0
        return label
    }()
    
    lazy var whatToDoErased: UILabel = {
        let label = UILabel()
        label.font = .LINESeedRegular(size: 15.0)
        label.numberOfLines = 0
        let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: plan.text!)
        attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSMakeRange(0, attributeString.length))
        label.attributedText = attributeString
        return label
    }()
    
    var detailMemoButton: UIButton! = nil
    
    let priorityColorView: UIView = {
        let view = UIView()
        view.backgroundColor = .disciplineBackground
        return view
    }()
    
    // MARK: - StackView
    private lazy var timeAndWhatToDoStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [time, plan])
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
    
    // MARK: - objc
    @objc func checkButtonTapped(_ sender: UIButton) {
        setCheckAnimationWhenCheckBoxTapped()
        setHapticsWhenCheckBoxTapped()
        setTodoListErasedWhenCheckBoxTapped()
    }
    
    private func setCheckAnimationWhenCheckBoxTapped() {
        UIView.animate(withDuration: 0.1, animations: {
            self.checkButton.isSelected = !(self.checkButton.isSelected)
            self.checkButton.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)

        }) { _ in
            UIView.animate(withDuration: 0.1) {
                self.checkButton.transform = CGAffineTransform.identity
            }
        }
    }
    
    private func setHapticsWhenCheckBoxTapped() {
        let impactFeedbackgenerator = UIImpactFeedbackGenerator(style: .light)
        impactFeedbackgenerator.prepare()
        impactFeedbackgenerator.impactOccurred()
    }
    
    private func setTodoListErasedWhenCheckBoxTapped() {
        if isStrikethrough {
            // 취소선이 있으면 취소선을 제거하고 변수를 업데이트합니다.
            UIView.transition(with: self.plan, duration: 0.2, options: .transitionCrossDissolve, animations: {
                let normalString = NSAttributedString(string: self.plan.text ?? "")
                self.plan.attributedText = normalString
                self.plan.textColor = .disciplineBlack
                self.plan.backgroundColor = .disciplineBackground
            }, completion: nil)
            isStrikethrough = false
        } else {
            // 취소선이 없으면 취소선을 추가하고 변수를 업데이트합니다.
            UIView.transition(with: self.plan, duration: 0.2, options: .transitionCrossDissolve, animations: {
                self.plan.attributedText = self.plan.text?.strikeThrough()
                self.plan.backgroundColor = .disciplineBackground
                self.plan.textColor = .systemGray
            }, completion: nil)
            isStrikethrough = true
        }
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
        [checkButton, timeAndWhatToDoStack, whatToDoErased, priorityColorView].forEach { self.addSubview($0)}
        
        checkButton.snp.makeConstraints { make in
            make.leading.equalTo(self.snp.leading).offset(20)
            make.centerY.equalTo(self.snp.centerY)
        }
        
        timeAndWhatToDoStack.snp.makeConstraints { make in
            make.leading.equalTo(checkButton.snp.trailing).offset(30)
            make.centerY.equalTo(self.snp.centerY)
        }
        
        plan.snp.makeConstraints { make in
            make.width.equalTo(160)
        }
        
        // 할 일 목록 지워진 버전을 할 일 목록과 겹쳐놓는다.
        whatToDoErased.snp.makeConstraints { make in
            make.edges.equalTo(plan)
        }
        
        priorityColorView.snp.makeConstraints { make in
            make.width.equalTo(25)
            make.height.equalTo(130)
            make.trailing.equalTo(self.snp.trailing)
            make.centerY.equalTo(self.snp.centerY)
        }
    }
}
