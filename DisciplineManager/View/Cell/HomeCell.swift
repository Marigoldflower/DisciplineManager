//
//  HomeCell.swift
//  DisciplineManager
//
//  Created by 황홍필 on 2023/11/22.
//

import UIKit
import SnapKit

final class HomeCell: UITableViewCell {

    static let identifier = "HomeCell"
    
    let timeLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 16)
        return label
    }()
    
    let iconButton: UIButton = {
        let button = UIButton()
        button.setTitle("", for: .normal)
        return button
    }()
    
    let whatToDo: UIButton = {
        let button = UIButton()
        button.setTitle("", for: .normal)
        return button
    }()
    
    private let doneButton: UIButton = {
        let button = UIButton()
        button.setTitle("", for: .normal)
        return button
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
}

extension HomeCell: ViewDrawable {
    func configureUI() {
        setBackgroundColor()
        setAutolayout()
    }
    
    func setBackgroundColor() {
        self.backgroundColor = .white
    }
    
    func setAutolayout() {
        [timeLabel, iconButton, whatToDo, doneButton].forEach { addSubview($0) }
        
        timeLabel.snp.makeConstraints { make in
            make.leading.equalTo(self.snp.leading).offset(5)
            make.centerY.equalTo(self.snp.centerY)
        }
        
        iconButton.snp.makeConstraints { make in
            make.leading.equalTo(timeLabel.snp.trailing).offset(10)
            make.centerY.equalTo(self.snp.centerY)
        }
        
        whatToDo.snp.makeConstraints { make in
            make.leading.equalTo(whatToDo.snp.trailing).offset(10)
            make.centerY.equalTo(self.snp.centerY)
        }
        
        doneButton.snp.makeConstraints { make in
            make.trailing.equalTo(self.snp.trailing).offset(-15)
            make.centerY.equalTo(self.snp.centerY)
        }
    }
}
