//
//  MainTabBarController.swift
//  DisciplineManager
//
//  Created by 황홍필 on 2023/11/07.
//

import UIKit

final class MainTabBarController: UITabBarController {
    
    // MARK: - UI Components
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
    }
    
    private func setTabBarElements() {
        viewControllers = [home, motivation, achievement, deviceBlock, setting]
    }
    
    private func setTabBarColor() {
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        tabBar.backgroundColor = .systemGray5
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
}
