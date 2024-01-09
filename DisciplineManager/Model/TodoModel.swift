//
//  TodoModel.swift
//  DisciplineManager
//
//  Created by 황홍필 on 2023/11/22.
//

import UIKit

struct TodoModel {
    var plan: String
    var detailPlan: String
    var time: String
    var repetition: String
    var priority: String
    var alertIsOn: Bool
    
    init(plan: String, detailPlan: String, time: String, repetition: String, priority: String, alertIsOn: Bool) {
        self.plan = plan
        self.time = time
        self.detailPlan = detailPlan
        self.repetition = repetition
        self.priority = priority
        self.alertIsOn = alertIsOn
    }
    
    init(plan: String, time: String) {
        self.plan = plan
        self.time = time
        self.detailPlan = ""
        self.repetition = ""
        self.priority = ""
        self.alertIsOn = false
    }
}
