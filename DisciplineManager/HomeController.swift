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
        setCalendarDelegate()
        for family in UIFont.familyNames {
            print(family)

            for sub in UIFont.fontNames(forFamilyName: family) {
                 print("====> \(sub)")
            }
        }
    }
    
    private func setCalendarDelegate() {
        calendar.delegate = self
        calendar.dataSource = self
    }
    
}

extension HomeController: ViewDrawable {
    // MARK: - protocol 구현부
    func configureUI() {
        setBackgroundColor()
        setAutolayout()
        setCalendarUI()
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
            make.height.equalTo(240)
        }
    }
    
    // MARK: - 나머지 UI 구현부
    private func setCalendarUI() {
        setCalendarTextColor()
        hideCalendarText()
        setCalendarAsWeek()
        setCalendarFonts()
    }
    
    private func setCalendarTextColor() {
        calendar.appearance.titleDefaultColor = .black
        calendar.appearance.titleWeekendColor = .systemPink
        calendar.appearance.headerTitleColor = .systemPink
        calendar.appearance.weekdayTextColor = .orange
    }
    
    private func hideCalendarText() {
        hideCalendarHeaderSideText()
        hideCalendarHeaderTitleText()
    }
    
    private func hideCalendarHeaderSideText() {
        calendar.appearance.headerMinimumDissolvedAlpha = 0
    }
    
    private func hideCalendarHeaderTitleText() {
        calendar.headerHeight = 0
    }
    
    private func setCalendarAsWeek() {
        calendar.scope = .week
    }
    
    private func setCalendarFonts() {
        calendar.appearance.titleFont = UIFont(name: "LINESeedSansKR-Bold", size: 15.0)
        calendar.appearance.weekdayFont = UIFont(name: "LINESeedSansKR-Regular", size: 15.0)
    }
    
}

extension HomeController: FSCalendarDelegate, FSCalendarDataSource, FSCalendarDelegateAppearance {
    
}
