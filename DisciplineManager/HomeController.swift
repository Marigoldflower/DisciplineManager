//
//  ViewController.swift
//  DisciplineManager
//
//  Created by 황홍필 on 2023/11/07.
//

import UIKit
import FSCalendar
import SnapKit

final class HomeController: UIViewController {
    
    private let calendar = FSCalendar()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        setCalendarUI()
        setCalendarDelegate()
    }

    private func setCalendarUI() {
        setCalendarTextColor()
        hideCalendarText()
        setCalendarAsWeek()
    }
    
    private func setCalendarTextColor() {
        calendar.appearance.titleDefaultColor = .black
        calendar.appearance.titleWeekendColor = .systemPink
        calendar.appearance.headerTitleColor = .systemPink
        calendar.appearance.weekdayTextColor = .orange
    }
    
    private func hideCalendarText() {
        calendar.appearance.headerMinimumDissolvedAlpha = 0
        
        
    }
    
    private func setCalendarAsWeek() {
        calendar.scope = .week
    }
    
    private func setCalendarDelegate() {
        calendar.delegate = self
        calendar.dataSource = self
    }
    

}

extension HomeController: ViewDrawable {
    func configureUI() {
        setBackgroundColor()
        setAutolayout()
    }
    
    func setBackgroundColor() {
        view.backgroundColor = .white
    }
    
    func setAutolayout() {
        [calendar].forEach { view.addSubview($0) }
        
        calendar.snp.makeConstraints { make in
            make.leading.equalTo(view.snp.leading)
            make.trailing.equalTo(view.snp.trailing)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.height.equalTo(220)
        }
    }
}

extension HomeController: FSCalendarDelegate, FSCalendarDataSource, FSCalendarDelegateAppearance {
    
}
