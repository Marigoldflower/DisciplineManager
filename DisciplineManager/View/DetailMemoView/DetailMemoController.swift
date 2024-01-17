//
//  DetailMemoView.swift
//  DisciplineManager
//
//  Created by 황홍필 on 2024/01/16.
//

import UIKit
import SnapKit

final class DetailMemoController: UIViewController {

    // MARK: - UI Components
    let detailMemoView: DetailMemoView = {
        let view = DetailMemoView()
        view.layer.cornerRadius = 15
        view.layer.masksToBounds = true
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if touches.first?.view == self.view {
            self.dismiss(animated: true, completion: nil)
        }
    }
}

extension DetailMemoController: ViewDrawable {
    func configureUI() {
        setBackgroundColor()
        setAutolayout()
    }
    
    func setBackgroundColor() {
        view.backgroundColor = .black.withAlphaComponent(0.4)
    }
    
    func setAutolayout() {
        [detailMemoView].forEach { view.addSubview($0) }
        
        detailMemoView.snp.makeConstraints { make in
            make.center.equalTo(view.snp.center)
            
            make.leading.equalTo(view.snp.leading).offset(60)
            make.trailing.equalTo(view.snp.trailing).offset(-60)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(150)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-150)
//            make.width.height.equalTo(200)
        }
    }
}
