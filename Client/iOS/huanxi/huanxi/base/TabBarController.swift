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
        
        let main = setupViewController(HomeViewController(), title: "首页", iconStr: "tabbar_main", selectedIconStr: "tabbar_main")
        let search = setupViewController(SearchViewController(), title: "搜索", iconStr: "tabbar_search", selectedIconStr: "tabbar_search")
        let publish = setupViewController(PublishViewController(), title: "发布", iconStr: "tabbar_publish", selectedIconStr: "tabbar_publish")
        let updates = setupViewController(UpdatesViewController(), title: "动态", iconStr: "tabbar_updates", selectedIconStr: "tabbar_updates")
        let mine = setupViewController(MineViewController(), title: "我的", iconStr: "tabbar_mine", selectedIconStr: "tabbar_mine")

        let viewcontrollers = [main, search, publish, updates, mine]
        self.viewControllers = viewcontrollers
        
        self.tabBar.tintColor = UIColor.white // 设置选中的颜色
        self.tabBar.unselectedItemTintColor = UIColor.gray // 设置未选中的颜色
        
        self.tabBar.barTintColor = UIColor.black
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
        guard let viewControllers = viewControllers else { return false }
        // 获取目标视图控制器的索引
        guard let targetIndex = viewControllers.firstIndex(of: viewController) else { return true }
        
        // 如果是 Message、Update 或 Mine，需要检查登录
        if targetIndex == 2 || targetIndex == 3 || targetIndex == 4 {
            if !LoginManager.shared.isLogin() {
                // 未登录时弹出登录界面
                Task {
                    let loginResult = await LoginViewController.startLogin()
                    if loginResult {
                        if targetIndex == 2 {
                            let vcToPresent = PublishViewController()
                            vcToPresent.modalPresentationStyle = .fullScreen
                            present(vcToPresent, animated: true, completion: nil)
                        } else {
                            // 登录成功后切到首页
                            self.selectedIndex = 0
                        }
                    }
                }
                return false // 阻止切换到目标 Tab
            } else {
                if targetIndex == 2 {
                    let vcToPresent = PublishViewController()
                    vcToPresent.modalPresentationStyle = .fullScreen
                    present(vcToPresent, animated: true, completion: nil)
                    return false // 阻止切换到目标 Tab
                }
            }
        }
        return true
    }

}
