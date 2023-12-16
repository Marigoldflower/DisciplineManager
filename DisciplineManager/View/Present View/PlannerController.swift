//
//  PlannerController.swift
//  DisciplineManager
//
//  Created by 황홍필 on 2023/12/15.
//

import UIKit

final class PlannerController: UIViewController {
    
    // MARK: - UI Components
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }

}

extension PlannerController: ViewDrawable {
    func configureUI() {
        setBackgroundColor()
        setAutolayout()
    }
    
    func setBackgroundColor() {
        view.backgroundColor = .disciplineBackground
    }
    
    func setAutolayout() {
        
    }
}
