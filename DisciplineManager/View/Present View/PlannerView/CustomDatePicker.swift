//
//  CustomDatePicker.swift
//  DisciplineManager
//
//  Created by 황홍필 on 2023/12/28.
//

import UIKit
import SnapKit

final class CustomDatePickerController: UIViewController, UISheetPresentationControllerDelegate {
    
    // MARK: - Time Data
    let periods = ["오전", "오후"]
    let hours = Array(01...12) 
    let minutes = Array(00...59)
    
    // MARK: - UI Components
    private lazy var datePicker: UIPickerView = {
        let picker = UIPickerView()
        picker.delegate = self
        picker.dataSource = self
        picker.backgroundColor = .disciplinePurple
        return picker
    }()
    
    override var sheetPresentationController: UISheetPresentationController {
        presentationController as! UISheetPresentationController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
}

extension CustomDatePickerController: ViewDrawable {
    func configureUI() {
        setBackgroundColor()
        setAutolayout()
        setSheetPresentationController()
    }
    
    func setBackgroundColor() {
        view.backgroundColor = .disciplineBackground
    }
    
    func setAutolayout() {
        [datePicker].forEach { view.addSubview($0) }
        
        datePicker.snp.makeConstraints { make in
            make.leading.equalTo(view.snp.leading)
            make.trailing.equalTo(view.snp.trailing)
            make.top.equalTo(view.snp.top)
            make.bottom.equalTo(view.snp.bottom)
        }
    }
    
    private func setSheetPresentationController() {
        sheetPresentationController.delegate = self
        sheetPresentationController.detents = [.medium()]
    }
}

extension CustomDatePickerController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 3
    }
    
    // 각 컴포넌트의 로우 수 설정
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch component {
        case 0:
            return periods.count
        case 1:
            return hours.count
        case 2:
            return minutes.count
        default:
            return 0
        }
    }
    
    // 각 로우의 타이틀 설정
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch component {
        case 0:
            return "\(periods[row])"
        case 1:
            return "\(hours[row])"
        case 2:
            return "\(minutes[row])"
        default:
            return ""
        }
    }
    
    // 선택된 로우에 대한 처리
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let periods = periods[pickerView.selectedRow(inComponent: 0)]
        let hours = hours[pickerView.selectedRow(inComponent: 1)]
        let minutes = minutes[pickerView.selectedRow(inComponent: 2)]
        
        print("Selected periods: \(periods)")
        print("Selected hours: \(hours)")
        print("Selected minutes: \(minutes)")
    }
}
