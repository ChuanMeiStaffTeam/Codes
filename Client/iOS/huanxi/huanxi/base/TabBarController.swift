//
//  TabBarController.swift
//  huanxi
//
//  Created by jack on 2024/2/18.
//

import Foundation
import UIKit

class TabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.delegate = self
        setupTabbar()
    }
    
    func setupTabbar() {
        
        let main = setupViewController(MainViewController(), title: "首页", iconStr: "tabbar_main", selectedIconStr: "tabbar_main")
        let search = setupViewController(SearchViewController(), title: "搜索", iconStr: "tabbar_search", selectedIconStr: "tabbar_search")
        let publish = setupViewController(PublishViewController(), title: "发布", iconStr: "tabbar_publish", selectedIconStr: "tabbar_publish")
        let updates = setupViewController(UpdatesViewController(), title: "动态", iconStr: "tabbar_updates", selectedIconStr: "tabbar_updates")
        let mine = setupViewController(MineViewController(), title: "我的", iconStr: "tabbar_mine", selectedIconStr: "tabbar_mine")

        let viewcontrollers = [main, search, publish, updates, mine]
        self.viewControllers = viewcontrollers
        
        self.tabBar.tintColor = UIColor.white // 设置选中的颜色
        self.tabBar.unselectedItemTintColor = UIColor.gray // 设置未选中的颜色
    }
    
    func setupViewController(_ vc: UIViewController, title: String, iconStr: String, selectedIconStr: String) -> UIViewController {
        
        let icon = UIImage.init(named: iconStr)
        let selectedIcon = UIImage.init(named: selectedIconStr)
        
        let nav = NavigationController(rootViewController: vc)
        nav.tabBarItem = UITabBarItem.init(title: title, image: icon, selectedImage: selectedIcon)
        
        return nav
    }
    
}


extension TabBarController: UITabBarControllerDelegate {

    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        if viewController == tabBarController.viewControllers?[2] {
            let vcToPresent = PublishViewController()
            vcToPresent.modalPresentationStyle = .fullScreen
            present(vcToPresent, animated: true, completion: nil)
            return false // 防止第三个 tab 被选中
        }
        return true
    }

}
