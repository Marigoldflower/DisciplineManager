//
//  MainTabBarController.swift
//  DisciplineManager
//
//  Created by 황홍필 on 2023/11/07.
//

import UIKit

final class MainTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTabBarElements()
        setTabBarColor()
        setTabBarImage()
    }
    
    private func setTabBarElements() {
        let home = UINavigationController(rootViewController: HomeController())
        let motivation = UINavigationController(rootViewController: MotivationController())
        let achievement = UINavigationController(rootViewController: AchievementController())
        let deviceBlock = UINavigationController(rootViewController: DeviceBlockController())
        let setting = UINavigationController(rootViewController: SettingController())
        
        viewControllers = [home, motivation, achievement, deviceBlock, setting]
    }
    
    private func setTabBarColor() {
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .white
        tabBar.backgroundColor = .white
        tabBar.tintColor = .systemOrange
    }
    
    private func setTabBarImage() {
        guard let items = tabBar.items else { return }
        
        items[0].image = UIImage(systemName: "house.fill")
        items[1].image = UIImage(systemName: "shared.with.you") 
        items[2].image = UIImage(systemName: "trophy.fill")
        items[3].image = UIImage(systemName: "exclamationmark.octagon.fill")
        items[4].image = UIImage(systemName: "gearshape.fill")
    }
    
}
