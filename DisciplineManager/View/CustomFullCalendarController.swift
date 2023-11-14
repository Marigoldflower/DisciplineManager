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
    
    private let customFullCalendarView: CustomFullCalendarView = {
        let view = CustomFullCalendarView()
        view.layer.cornerRadius = 10
        view.clipsToBounds = true
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()

        // 화면 터치시 dismiss 설정
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissSelf))
        view.addGestureRecognizer(tapGesture)
    }

    @objc func dismissSelf() {
        self.dismiss(animated: true, completion: nil)
    }
}

extension CustomFullCalendarController: ViewDrawable {
    func configureUI() {
        setBackgroundColor()
        setAutolayout()
    }
    
    func setBackgroundColor() {
        view.backgroundColor = .clear
    }
    
    func setAutolayout() {
        [customFullCalendarView].forEach { view.addSubview($0) }
        
        customFullCalendarView.snp.makeConstraints { make in
            make.leading.equalTo(view.snp.leading).offset(10)
            make.trailing.equalTo(view.snp.trailing).offset(-10)
            make.top.equalTo(view.snp.top).offset(200)
            make.bottom.equalTo(view.snp.bottom).offset(-10)
        }
    }
}
