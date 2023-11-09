//
//  Bindable.swift
//  DisciplineManager
//
//  Created by 황홍필 on 2023/11/08.
//

import Foundation
import ReactorKit

protocol Bindable {
    associatedtype Reactor: ReactorKit.Reactor
    func bindState(_ reactor: Reactor)
    func bindAction(_ reactor: Reactor)
}
