//
//  SettingViewController.swift
//  huanxi
//
//  Created by jack on 2024/7/22.
//

import UIKit

class SettingViewController: BaseViewController {
    
    private let dataList: [SetModel] = [
        SetModel(title: "账号与安全"),
        SetModel(title: "广告接入"),
        SetModel(title: "语言"),
        SetModel(title: "用户协议"),
        SetModel(title: "隐私政策"),
    ]

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    func setupView() {
        title = "设置"
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.top.bottom.left.right.equalToSuperview().offset(0)
        }
    }
    
    @objc func logout() {
        
        let alert = UIAlertController(title: "提示", message: "您确定要退出登录吗？", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "确定", style: .default) { _ in
            LoginManager.requestLogout { success in
            }
        }
        let cancelAction = UIAlertAction(title: "取消", style: .cancel) { _ in
            
        }
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        present(alert, animated: true)
    }
    
    
    lazy var tableView: UITableView = {
        let view = UITableView.init(frame: CGRect.zero, style: UITableView.Style.plain)
        view.backgroundColor = .clear
        view.separatorStyle = .none
        view.delegate = self
        view.dataSource = self
        view.register(SettingItemCell.self)
        return view
    }()
    
}



extension SettingViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let model = dataList.ck_objIndex(indexPath.row) else { return UITableViewCell() }
        let cell: SettingItemCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
        cell.model = model
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 64
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let bgView: UIView = UIView()
        bgView.frame = CGRect.init(x: 0, y: 0, width: .screenWidth, height: 60)

        let btn = UIButton.init(type: .custom)
//        btn.backgroundColor = UIColor.black_forground
        btn.frame = CGRect.init(x: 0, y: 20, width: .screenWidth, height: 40)
        btn.setTitle("退出登录", for: .normal)
        btn.setTitleColor(.red, for: .normal)
        btn.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        btn.addTarget(self, action: #selector(logout), for: .touchUpInside)
        bgView.addSubview(btn)
        return bgView
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            let vc = AccountSecurityVC()
            guard let model = dataList.ck_objIndex(indexPath.row) else { return }
            vc.title = model.title
            self.navigationController?.pushViewController(vc, animated: true)
        case 1:
            let vc = CompanyViewController()
            self.navigationController?.pushViewController(vc, animated: true)
        case 2:
            let vc = LanguageViewController()
            self.navigationController?.pushViewController(vc, animated: true)
        case 3,4:
            let docxName = indexPath.row == 3 ? "欢喜用户协议" : "欢喜隐私协议"
            let filePath = Bundle.main.path(forResource: docxName, ofType: "docx") ?? ""
            DocumentPreviewer.shared.show(from: self, filePaths: [filePath]) {
                print("文件预览完成")
            }
        default:
            break
        }

        
    }
    
}


/*功能
 
 这段代码实现了一个设置界面的控制器 SettingViewController。它包含一个列表，显示不同的设置选项，用户可以点击这些选项进入相应的设置详情界面。 同时，它还提供了一个“退出登录”按钮，允许用户退出登录。

 代码结构

 类:
 SettingViewController: 设置界面的控制器，负责界面的搭建、数据展示和用户交互处理。
 属性:
 dataList: 包含设置选项标题的数组。
 tableView: 显示设置选项的表格视图。
 方法:
 viewDidLoad: 初始化设置界面，加载数据并设置表格视图。
 setupView: 设置界面的标题和表格视图的约束。
 logout: 处理“退出登录”按钮点击事件，弹出确认对话框。
 , numberOfRowsInSection, cellForRowAt, heightForRowAt: 这些方法是 UITableView 的数据源协议方法，用于提供表格视图的数据和创建每一行的单元格。
 viewForFooterInSection, heightForFooterInSection: 这两个方法用于创建表格视图底部的“退出登录”按钮。
 didSelectRowAt: 处理用户点击表格视图单元格的事件，根据选中的选项跳转到相应的设置详情界面，或者使用 DocumentPreviewer 预览用户协议或隐私政策文档。
 代码逻辑

 在 viewDidLoad 方法中，首先设置界面的标题为 "设置"。
 然后，通过 setupView 方法设置表格视图的约束。
 当用户点击某个单元格时，didSelectRowAt 方法会根据选中的行号 (indexPath.row) 来执行不同的操作：
 如果是第 0 行（“账号与安全”），则会跳转到 AccountSecurityVC 界面。
 如果是第 1 行（“广告接入”），则会跳转到 CompanyViewController 界面（可能占位符）。
 如果是第 2 行（“语言”），则会跳转到 LanguageViewController 界面。
 如果是第 3 行（“用户协议”）或第 4 行（“隐私政策”），则会使用 DocumentPreviewer 预览相应的文档。
 点击“退出登录”按钮时，会调用 logout 方法，弹出确认对话框询问用户是否确定退出登录。
 总体而言，这段代码清晰地实现了设置界面的功能，使用了表格视图来展示不同的设置选项，并提供了用户交互的处理逻辑。*/

