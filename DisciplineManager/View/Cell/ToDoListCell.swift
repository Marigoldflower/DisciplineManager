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
    
    let toDoListView: ToDoListView = {
        let view = ToDoListView()
        view.layer.borderColor = UIColor.disciplinePurple.cgColor
        view.layer.borderWidth = 2
        view.layer.cornerRadius = 20
        view.layer.masksToBounds = true
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
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
