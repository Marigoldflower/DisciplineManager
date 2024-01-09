//
//  AlertView.swift
//  DisciplineManager
//
//  Created by 황홍필 on 2023/12/16.
//

import UIKit
import SnapKit

final class AlertView: UIView {
    
    // MARK: - SelectedSwitch
    var isOn = false {
        didSet {
            print("현재 알림 상태는 \(isOn)")
        }
    }
    
    // MARK: - UI Components
    private let getAlertForThisTask: UILabel = {
        let label = UILabel()
        label.font = .LINESeedRegular(size: 18)
        label.textColor = .disciplineBlack
        label.text = "알림 받기"
        return label
    }()
    
    private lazy var switchControl: UISwitch = {
        let switchControl = UISwitch()
        switchControl.isOn = false
        isOn = switchControl.isOn.toggle()
        switchControl.onTintColor = .disciplineBlue
        return switchControl
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }

}

extension AlertView: ViewDrawable {
    func configureUI() {
        setBackgroundColor()
        setAutolayout()
    }
    
    func setBackgroundColor() {
        self.backgroundColor = .disciplineBackground
    }
    
    func setAutolayout() {
        [getAlertForThisTask, switchControl].forEach { self.addSubview($0) }
        
        getAlertForThisTask.snp.makeConstraints { make in
            make.leading.equalTo(self.snp.leading).offset(20)
            make.centerY.equalTo(switchControl.snp.centerY)
        }
        
        switchControl.snp.makeConstraints { make in
            make.trailing.equalTo(self.snp.trailing).offset(-20)
            make.top.equalTo(self.snp.top).offset(20)
        }
    }
}
