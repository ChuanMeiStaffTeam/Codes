//
//  UpdatesViewController.swift
//  huanxi
//
//  Created by jack on 2024/2/18.
//

import UIKit

class UpdatesViewController: BaseViewController {
    
    let vm = HomeViewModel()
    var mainView: MainView!

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        
        mainView.reloadMainViewData(vm.mainList)
    }
    
    
    func setupView() {
        setupNavView()
        
        mainView = MainView(frame: CGRect.init(x: 0, y: 0, width: .screenWidth, height: .screenHeight - .bottomSafeAreaHeight - .tabBarHeight))
        view.addSubview(mainView)
        
    }
    
    func setupNavView() {
        
        let view = UIView(frame: CGRect.init(x: 0, y: 0, width: 150, height: 40))
        view.backgroundColor = .clear
        
        let imageView = UIImageView(image: UIImage.init(named: "huanxi.jpg"))
        imageView.frame = CGRect(x: 39, y: 0, width: 72, height: 36)
        imageView.contentMode = .scaleAspectFill
        view.addSubview(imageView)
//        let leftItem = UIBarButtonItem(customView: imageView)
        self.navigationItem.titleView = view
        
        let button = UIButton(type: .custom)
        button.frame = CGRect(x: .screenWidth - 46, y: 7, width: 30, height: 30)
        button.setImage(UIImage.init(named: "main_relay"), for: .normal)
        button.addTarget(self, action: #selector(gotoDirect), for: .touchUpInside)
        let rightItem = UIBarButtonItem(customView: button)
//        self.navigationItem.rightBarButtonItem = rightItem
        
        // 隐藏导航栏底部的分割线
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.shadowImage = UIImage() // 隐藏分割线
        appearance.shadowColor = nil       // 确保无颜色
        appearance.backgroundColor = UIColor.black // 可选，设置导航栏背景颜色

        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        
    }
    
    
    @objc func gotoDirect() {
        let vc = DirectViewController()
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}

/*
class UpdatesViewController: BaseViewController {
    
    let updatesThisMonthCell = "UpdatesThisMonthCell"
    let updatesEarlierCell = "UpdatesEarlierCell"
    let updatesRecommendCell = "UpdatesRecommendCell"

    var dataList: [Int] = [1, 5, 3];
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        setupView()
    }
    
    
    func setupView() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview().offset(0)
        }
    }
    
    
    lazy var tableView: UITableView = {
        let view = UITableView.init(frame: CGRect.zero, style: UITableView.Style.plain)
        view.backgroundColor = .clear
        view.delegate = self
        view.dataSource = self
        view.register(UpdatesThisMonthCell.self, forCellReuseIdentifier: updatesThisMonthCell)
        view.register(UpdatesEarlierCell.self, forCellReuseIdentifier: updatesEarlierCell)
        view.register(UpdatesRecommendCell.self, forCellReuseIdentifier: updatesRecommendCell)
        return view
    }()
}

extension UpdatesViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        
        var text = "为您推荐"
        if section == 0 {
            text = "本月"
        } else if section == 1 {
            text = "更早之前"
        }
        let titleLabel = UILabel(frame: .init(x: 16, y: 0, width: 200, height: 40))
        titleLabel.textColor = .white
        titleLabel.font = .systemFont(ofSize: 14, weight: .medium)
        titleLabel.text = text
        headerView.addSubview(titleLabel)
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = dataList[section]
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            let cell = UpdatesThisMonthCell.init(style: .default, reuseIdentifier: updatesThisMonthCell)
            cell.followBlock = {
                HUDHelper.showToast("点击了关注")
            }
            return cell
        } else if indexPath.section == 1 {
            let cell = UpdatesEarlierCell.init(style: .default, reuseIdentifier: updatesEarlierCell)
            return cell
        } else {
            let cell = UpdatesRecommendCell.init(style: .default, reuseIdentifier: updatesRecommendCell)
            cell.followBlock = {
                HUDHelper.showToast("点击了关注")
            }
            cell.closeBlock = {
                HUDHelper.showToast("点击了关闭")
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 2 {
            return 82
        }
        return 64
    }
    
    
}

*/

/*代码功能：

这段代码主要实现了一个用户注册的视图控制器。它负责收集用户的注册信息（账号、昵称、密码等），并向服务器发送注册请求。

主要功能点：

UI布局: 使用 SnapKit 对各个 UI 元素（如文本输入框、按钮等）进行布局，使其在不同屏幕尺寸下都能保持良好的显示效果。
数据校验: 在提交注册信息之前，会对用户输入的账号、昵称、密码等进行基本的校验，确保输入的有效性。
网络请求: 通过 NetworkManager.shared.postRequest 发送注册请求到服务器，并将服务器返回的结果进行处理。
用户交互: 提供关闭按钮、文本输入框、按钮等交互元素，方便用户进行操作。
代码结构：

类名: RegisterViewController，表示这是一个用于注册的视图控制器。
属性:
closeBtn: 关闭按钮。
accountTF, nickNameTF, pwdTF, repwdTF: 用于输入账号、昵称、密码的文本框。
其他一些用于布局和状态管理的属性。
方法:
viewDidLoad: 在视图加载时，进行 UI 布局和绑定事件。
setupView: 初始化 UI 元素并设置约束。
closeAction: 关闭视图控制器。
registerAction: 处理注册按钮点击事件，验证输入信息并发送网络请求。
代码逻辑:

用户输入: 用户在文本框中输入账号、昵称和密码。
校验: 点击注册按钮时，系统会校验输入信息的合法性，例如密码是否一致等。
网络请求: 如果校验通过，则向服务器发送注册请求。
处理响应: 根据服务器返回的结果，显示相应的提示信息，如注册成功或失败。
潜在改进:

密码强度校验: 可以增加密码强度校验，要求密码包含数字、字母和特殊字符等。
用户协议: 可以增加用户协议勾选框，要求用户同意协议才能注册。
验证码: 可以增加验证码功能，提高安全性。
加载指示: 在发送网络请求时，可以显示加载指示器。
错误处理: 可以对网络请求错误进行更详细的处理，并提示用户。
UI优化: 可以对 UI 进行优化，使其更加美观和用户友好。
*/
