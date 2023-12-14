//
//  HomeCell.swift
//  DisciplineManager
//
//  Created by 황홍필 on 2023/11/22.
//

import UIKit
import SnapKit

final class ToDoListCell: UITableViewCell {
    
    static let identifier = "HomeCell"
    
    lazy var toDoListView: ToDoListView = {
        let view = ToDoListView()
        view.layer.borderColor = UIColor.disciplinePurple.cgColor
        view.layer.borderWidth = 2
        view.layer.cornerRadius = 20
        view.layer.masksToBounds = true
        let toDoListViewIsTapped = UITapGestureRecognizer(target: self, action: #selector(whenTodoListViewIsTapped))
        view.addGestureRecognizer(toDoListViewIsTapped)
        view.isUserInteractionEnabled = true
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        // TableView Cell 내부의 UIButton과 상호작용하려면 반드시 이 코드를 붙여줘야 한다. ⭐️⭐️
        contentView.isUserInteractionEnabled = true
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    // MARK: - @objc
    @objc private func whenTodoListViewIsTapped() {
        setAnimationTo_TodoListView()
    }
    
    private func setAnimationTo_TodoListView() {
        UIView.animate(withDuration: 0.1, animations: {
            self.toDoListView.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
            self.toDoListView.backgroundColor = UIColor.systemGray5
        }) { _ in
            UIView.animate(withDuration: 0.1) {
                self.toDoListView.transform = CGAffineTransform.identity
                self.toDoListView.backgroundColor = UIColor.clear
            }
        }
    }
}

extension ToDoListCell: ViewDrawable {
    func configureUI() {
        setBackgroundColor()
        setAutolayout()
    }
    
    func setBackgroundColor() {
        self.backgroundColor = .disciplineBackground
    }
    
    func setAutolayout() {
        [toDoListView].forEach { addSubview($0) }
        
        toDoListView.snp.makeConstraints { make in
            make.leading.equalTo(self.snp.leading).offset(20)
            make.trailing.equalTo(self.snp.trailing).offset(-20)
            make.top.equalTo(self.snp.top).offset(10)
            make.bottom.equalTo(self.snp.bottom).offset(-10)
        }
    }
}
