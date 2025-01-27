//
//  LanguageViewController.swift
//  huanxi
//
//  Created by jack on 2024/9/12.
//

import UIKit
import SwiftUI

class LanguageViewController: BaseViewController {
    
    var dataList: [String] = []

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
    }
    
    func setupView() {
        title = "语言"
        
        dataList = ["简体中文"]

        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.top.bottom.left.right.equalToSuperview().offset(0)
        }
    }

    
    lazy var tableView: UITableView = {
        let view = UITableView.init(frame: CGRect.zero, style: UITableView.Style.plain)
        view.backgroundColor = .clear
        view.separatorStyle = .none
        view.delegate = self
        view.dataSource = self
        view.register(SettingItemCell.self, forCellReuseIdentifier: "cell")
        return view
    }()
    
}



extension LanguageViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = SettingItemCell.init(style: .default, reuseIdentifier: "cell")
        
        let title = dataList[indexPath.row]
        cell.titleLabel.text = title
        cell.arrow.isHidden = true
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 64
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

    }
    
}

/*代码功能概览
 
 这段代码主要实现了一个简单的语言设置页面。用户可以在这个页面中选择不同的语言，但目前只提供了“简体中文”这一选项。

 代码详细解读

 LanguageViewController 类：

 继承： 继承自 BaseViewController，说明这个类可能有一些基础的视图控制器功能。
 属性：
 dataList: 用来存储语言列表的数组，目前只有一个元素。
 方法：
 viewWillAppear：视图即将显示时调用，这里没有具体实现。
 viewDidLoad：视图加载完成后调用，主要负责设置视图。
 setupView：
 设置标题为“语言”。
 创建一个 UITableView，用于显示语言列表。
 设置 tableView 的样式、数据源、代理等。
 tableView：一个懒加载的 UITableView 属性，用于显示语言列表。
 协议：
 实现了 UITableViewDelegate 和 UITableViewDataSource 协议，用于配置和管理 tableView。
 UITableViewDelegate 和 UITableViewDataSource 协议实现：

 numberOfRowsInSection：返回表格的行数，根据 dataList 数组的长度。
 cellForRowAt：配置每个单元格，设置单元格的标题为对应语言，并隐藏箭头。
 heightForRowAt：设置每个单元格的高度。
 didSelectRowAt：当用户点击某个单元格时调用，但目前没有实现任何功能。
 代码优缺点分析

 优点：

 代码结构清晰，易于理解。
 充分利用了 UITableView 来展示语言列表。
 代码注释较少，但变量和方法命名清晰，有助于理解。
 缺点：

 功能单一： 目前只支持一种语言，没有实际的语言切换功能。
 缺少错误处理： 没有对用户操作或数据异常进行处理。
 缺少国际化支持： 除了中文，没有考虑其他语言的显示。
 没有持久化： 用户选择的语言设置没有保存，每次启动应用都会恢复默认设置。
 改进建议

 增加语言选项： 将 dataList 数组扩展，包含更多的语言选项。
 实现语言切换功能： 在 didSelectRowAt 方法中实现语言切换的逻辑，比如保存用户选择的语言到 UserDefaults，并重新加载界面。
 添加错误处理： 对可能出现的错误进行处理，比如空数组、索引越界等。
 支持国际化： 使用 NSLocalizedString 等方式实现多语言支持。
 持久化用户设置： 使用 UserDefaults 或其他存储方式保存用户选择的语言。
 优化界面： 可以考虑使用自定义的 UITableViewCell，增加一些交互效果，比如选中状态的背景色变化。*/
