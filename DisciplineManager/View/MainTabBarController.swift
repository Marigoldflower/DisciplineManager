//
//  MainTabBarController.swift
//  DisciplineManager
//
//  Created by 황홍필 on 2023/11/07.
//

import UIKit

final class MainTabBarController: UITabBarController {
    
    // MARK: - UI Components
    private let underline: UIView = {
        let underline = UIView()
        underline.backgroundColor = .disciplinePurple
        underline.layer.cornerRadius = 2
        return underline
    }()
    
    private var selectedImageView: UIImageView?
    
    private let home = UINavigationController(rootViewController: TodoController())
    private let motivation = UINavigationController(rootViewController: MotivationController())
    private let achievement = UINavigationController(rootViewController: AchievementController())
    private let deviceBlock = UINavigationController(rootViewController: DeviceBlockController())
    private let setting = UINavigationController(rootViewController: SettingController())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTabBarSettings()
    }
    
    private func setTabBarSettings() {
        setTabBarElements()
        setTabBarColor()
        setTabBarImage()
        setTabBarUnderline()
//        setTabBarName()
    }
    
    private func setTabBarElements() {
        viewControllers = [home, motivation, achievement, deviceBlock, setting]
    }
    
    private func setTabBarColor() {
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .disciplineBackground
        tabBar.backgroundColor = .disciplineBackground
        tabBar.tintColor = .disciplinePurple
    }
    
    private func setTabBarImage() {
        guard let items = tabBar.items else { return }
        
        items[0].image = UIImage(systemName: "checklist")
        items[1].image = UIImage(systemName: "book.fill")
        items[2].image = UIImage(systemName: "trophy.fill")
        items[3].image = UIImage(systemName: "exclamationmark.octagon.fill")
        items[4].image = UIImage(systemName: "gearshape.fill")
    }
    
    private func setTabBarName() {
        home.title = "홈"
        motivation.title = "동기부여"
        achievement.title = "나의 성취"
        deviceBlock.title = "디지털 디톡스"
        setting.title = "설정"
    }
    
    private func setTabBarUnderline() {
        tabBar.addSubview(underline)
        
        underline.snp.makeConstraints { make in
            make.bottom.equalTo(tabBar.safeAreaLayoutGuide.snp.bottom)
            make.width.equalTo(30)
            make.height.equalTo(4)
            make.centerX.equalTo(tabBar.subviews[0].snp.centerX)
        }
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        guard let index = self.tabBar.items?.firstIndex(of: item) else { return }
        guard tabBar.subviews.count > index + 1 else { return }
        
        let newImageView = tabBar.subviews[index + 1].subviews.first(where: { $0 is UIImageView }) as? UIImageView
        
        UIView.animate(withDuration: 0.3) {
            newImageView?.transform = CGAffineTransform(translationX: 0, y: -10)
            self.view.layoutIfNeeded()
        }
        
        UIView.animate(withDuration: 0.3) {
            self.selectedImageView?.transform = .identity
            self.view.layoutIfNeeded()
        }
        
        UIView.animate(withDuration: 0.3) {
            self.underline.snp.remakeConstraints { make in
                make.bottom.equalTo(tabBar.safeAreaLayoutGuide.snp.bottom)
                make.height.equalTo(4)
                make.width.equalTo(35)
                make.centerX.equalTo(tabBar.subviews[index + 1].snp.centerX)
            }
            self.view.layoutIfNeeded()
        }
        
    }
    
}
