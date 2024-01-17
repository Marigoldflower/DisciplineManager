//
//  HowManyTimesToRepeat.swift
//  DisciplineManager
//
//  Created by 황홍필 on 2024/01/05.
//

import UIKit
import SnapKit
import ReactorKit
import RxCocoa

final class HowManyTimesToRepeatTheTask: UIView, View {
    
    // MARK: - DisposeBag
    var disposeBag = DisposeBag()
    
    // MARK: - SelectedRepetition
    var selectedRepetition: String = "매일"
    
    // MARK: - ViewModel
    let repetitionViewModel = RepetitionViewModel()
    
    // MARK: - UI Components
    private let repeatLabel: UILabel = {
        let label = UILabel()
        label.font = .LINESeedRegular(size: 18)
        label.textColor = .disciplineBlack
        label.text = "반복"
        return label
    }()
    
    private lazy var segmentedControl: UISegmentedControl = {
        let segment = UISegmentedControl(items: ["하루만", "매일", "주간", "월간"])
        segment.layer.borderWidth = 1.0
        segment.layer.borderColor = UIColor.disciplinePurple.cgColor
        segment.setTitleTextAttributes(setSegmentControlAttributedText(with: .disciplineBlack), for: .normal)
        segment.setTitleTextAttributes(setSegmentControlAttributedText(with: .white), for: .selected)
        segment.backgroundColor = .white
        segment.selectedSegmentTintColor = .disciplinePurple
        segment.selectedSegmentIndex = 1
        selectedRepetition = segment.titleForSegment(at: segment.selectedSegmentIndex)!
        segment.layer.cornerRadius = 15
        segment.layer.masksToBounds = true
        return segment
    }()
    
    // MARK: - Stack
    private lazy var stackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [repeatLabel, segmentedControl])
        stack.axis = .vertical
        stack.spacing = 15
        return stack
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        reactor = repetitionViewModel
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
}

extension HowManyTimesToRepeatTheTask: Bindable {
    func bind(reactor: RepetitionViewModel) {
        bindAction(reactor)
        bindState(reactor)
    }
    
    func bindAction(_ reactor: Reactor) {
        segmentedControl.rx.selectedSegmentIndex
            .map { self.segmentedControl.titleForSegment(at: $0) ?? "" }
            .map { RepetitionViewModel.Action.selectSegment($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    func bindState(_ reactor: Reactor) {
        reactor.state
            .map { $0.selectedSegment }
            .distinctUntilChanged()
            .subscribe(onNext: { [weak self] selectedRepetition in
                self?.selectedRepetition = selectedRepetition
            })
            .disposed(by: disposeBag)
    }
}

extension HowManyTimesToRepeatTheTask: ViewDrawable {
    func configureUI() {
        setBackgroundColor()
        setAutolayout()
    }
    
    func setBackgroundColor() {
        self.backgroundColor = .disciplineBackground
    }
    
    func setAutolayout() {
        [stackView].forEach { self.addSubview($0) }
        
        stackView.snp.makeConstraints { make in
            make.leading.equalTo(self.snp.leading).offset(20)
            make.top.equalTo(self.snp.top).offset(20)
        }
        
        segmentedControl.snp.makeConstraints { make in
            make.leading.equalTo(self.snp.leading).offset(20)
            make.trailing.equalTo(self.snp.trailing).offset(-20)
            make.height.equalTo(45)
        }
    }
    
    private func setSegmentControlAttributedText(with color: UIColor) -> [NSAttributedString.Key : Any]? {
        let textAttributes: [NSAttributedString.Key : Any] = [
            .foregroundColor: color,
            .font: UIFont.LINESeedRegular(size: 15) as Any
        ]
        
        return textAttributes
    }
}
