//
//  HomeCell.swift
//  DisciplineManager
//
//  Created by 황홍필 on 2023/11/22.
//

import UIKit

final class HomeCell: UITableViewCell {

    static let identifier = "HomeCell"
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
        configureUI()
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
        
    }
}
