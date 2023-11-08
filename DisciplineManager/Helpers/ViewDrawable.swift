//
//  ViewDrawable.swift
//  DisciplineManager
//
//  Created by 황홍필 on 2023/11/08.
//

import Foundation

protocol ViewDrawable: AnyObject {
    func configureUI()
    func setBackgroundColor()
    func setAutolayout()
}
