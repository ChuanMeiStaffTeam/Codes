//
//  MainView.swift
//  huanxi
//
//  Created by jack on 2024/2/28.
//

import Foundation
import UIKit
import SnapKit

class MainView: UIView {
    
    private let viewModel = HomeViewModel()
    var mainList: [MainModel] = []
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        self.clipsToBounds = true
        addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(0)
        }
    }
    
    func reloadMainViewData(_ list: [MainModel]) {
        mainList = list
        tableView.reloadData()
    }
    
    lazy var tableView: UITableView = {
        let view = UITableView.init(frame: CGRect.zero, style: UITableView.Style.plain)
        view.backgroundColor = .clear
        view.separatorColor = .clear
        view.delegate = self
        view.dataSource = self
        view.register(MainUserCell.self, forCellReuseIdentifier: MainUserCell.defaultReuseIdentifier)
        view.register(MainContentCell.self, forCellReuseIdentifier: MainContentCell.defaultReuseIdentifier)
        view.register(MainRecommendCell.self, forCellReuseIdentifier: MainRecommendCell.defaultReuseIdentifier)
        return view
    }()
    
}


extension MainView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mainList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let model = mainList[indexPath.row]
        if model.type == "user" {
            let cell = MainUserCell.init(style: .default, reuseIdentifier: MainUserCell.defaultReuseIdentifier)
            return cell
        } else if model.type == "content" {
            let cell = MainContentCell.init(style: .default, reuseIdentifier: MainContentCell.defaultReuseIdentifier)
            cell.delegate = self
            let post = self.viewModel.postsList[indexPath.row]
            cell.model = post
            return cell
        } else if model.type == "recommend" {
            let cell = MainRecommendCell.init(style: .default, reuseIdentifier: MainRecommendCell.defaultReuseIdentifier)
            return cell
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let model = mainList[indexPath.row]
        if model.type == "user" {
            return 100
        } else if model.type == "content" {
            return 585
        } else if model.type == "recommend" {
            return 330
        }
        return 0
    }
}

extension MainView: MainContentCellDelegate {
    func didClickMark(_ data: PostModel, indexPath: IndexPath?, markComplete: ((Bool) -> Void)?) {
        
    }
    
    func didClickMore(_ data: PostModel, indexPath: IndexPath?) {

    }
    
    func didClickLike(_ data: PostModel, indexPath: IndexPath?) {
        if let index = self.viewModel.postsList.firstIndex(where: { $0.postId == data.postId }) {
            var post = self.viewModel.postsList[index]
            post.liked = data.liked
            post.likesCount = data.liked ? (post.likesCount ?? 0) + 1 : (post.likesCount ?? 0) - 1
            self.viewModel.postsList[index] = post
            let indexPath = IndexPath(row: index, section: 0)
            tableView.reloadRows(at: [indexPath], with: .none)
        }
    }
    
    func didClickComment(_ data: PostModel) {
     
    }
    
    func didClickShare(_ data: PostModel) {
  
    }
    

}


/*整体概览

这段代码定义了一个名为 MainView 的类，它是 iOS 应用程序中的一个视图，负责展示主界面。它主要包含一个 UITableView，用于展示不同类型的数据（用户、内容、推荐）。

关键点分析

数据模型:
MainModel: 似乎是一个协议或结构体，用来表示列表中的每一项数据。它包含一个 type 属性，用于区分是用户、内容还是推荐。
viewModel: 一个 HomeViewModel 类型的实例，负责提供视图所需的数据。
mainList: 一个 MainModel 数组，存储当前显示在列表中的所有数据。
视图结构:
tableView: 一个 UITableView 实例，用于显示列表数据。
MainUserCell, MainContentCell, MainRecommendCell: 三种自定义的 UITableViewCell 子类，分别用于展示不同类型的单元格。
数据加载和刷新:
reloadMainViewData(_:) 方法用于重新加载列表数据。
UITableViewDelegate 和 UITableViewDataSource:
MainView 实现了这两个协议，负责配置表格视图的各种行为，包括行数、单元格的内容、高度等。
单元格配置:
根据 MainModel 的 type 属性，创建不同的单元格类型，并配置其内容。
MainContentCell 还有额外的交互功能，如点赞、评论、分享等。
数据交互:
MainView 通过 MainContentCellDelegate 协议与 MainContentCell 进行交互，处理用户的点击事件。
当用户点击点赞按钮时，会更新 viewModel 中对应的数据，并刷新表格视图。
代码功能总结

展示列表数据: 根据 viewModel 提供的数据，在 tableView 中展示不同类型的单元格。
处理用户交互: 响应用户的点击事件，如点赞、评论、分享等。
更新视图: 当数据发生变化时，及时更新 tableView 的显示。
可能的改进点

代码结构: 可以考虑将 tableView 的配置代码提取到一个单独的方法中，提高代码的可读性。
数据源管理: 可以考虑使用一个更强大的数据源管理框架，例如 RxSwift 或 Combine，来简化数据流的管理。
单元格复用: 确保单元格的复用机制正确，避免不必要的创建和销毁。
错误处理: 可以添加一些错误处理机制，例如网络请求失败时的提示。
需要更多信息才能更详细地分析

MainModel 的具体结构：包含哪些属性？
HomeViewModel 的职责：如何获取数据？如何更新数据？
MainUserCell, MainContentCell, MainRecommendCell 的具体实现：如何展示数据？
应用程序的整体架构：MainView 在整个应用程序中的位置。
总结

 这段代码实现了一个基本的列表视图，可以展示不同类型的数据，并支持用户交互。如果能提供更多的上下文信息，我可以给出更详细和准确的分析。*/
