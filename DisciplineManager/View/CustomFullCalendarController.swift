//
//  CustomAlertController.swift
//  DisciplineManager
//
//  Created by 황홍필 on 2023/11/09.
//

import UIKit
import FSCalendar
import SnapKit

final class CustomFullCalendarController: UIViewController {
    
    private let calendar = FSCalendar()
    
    private let calendarView: UIView = {
        let calendarView = UIView()
        calendarView.backgroundColor = .white
        calendarView.layer.cornerRadius = 15
        return calendarView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        addTapGesture()
    }
    
    private func addTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissCustomAlertController))
        self.view.addGestureRecognizer(tapGesture)
    }
    
    @objc func dismissCustomAlertController(sender: UITapGestureRecognizer) {
        let touchPoint = sender.location(in: view)
        if !calendar.frame.contains(touchPoint) {
            self.dismiss(animated: true, completion: nil)
        }
    }
}

extension CustomFullCalendarController: ViewDrawable {
    func configureUI() {
        setBackgroundColor()
        setAutolayout()
        setCustomFullCalendarPresentationStyle()
        setCustomFullCalendarTransitionStyle()
    }
    
    func setBackgroundColor() {
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.35)
    }
    
    func setAutolayout() {
        [calendarView].forEach { view.addSubview($0) }
        [calendar].forEach { calendarView.addSubview($0) }
        
        calendarView.snp.makeConstraints { make in
            make.leading.equalTo(view.snp.leading).offset(10)
            make.trailing.equalTo(view.snp.trailing).offset(-10)
            make.bottom.equalTo(view.snp.bottom).offset(-10)
        }
        
        calendar.snp.makeConstraints { make in
            make.leading.equalTo(calendarView.snp.leading)
            make.trailing.equalTo(calendarView.snp.trailing)
            make.top.equalTo(calendarView.snp.top)
            make.bottom.equalTo(calendarView.snp.bottom)
        }
    }
    
    private func setCustomFullCalendarPresentationStyle() {
        self.modalPresentationStyle = .overCurrentContext
    }
    
    private func setCustomFullCalendarTransitionStyle() {
        self.modalTransitionStyle = .crossDissolve
    }
}
