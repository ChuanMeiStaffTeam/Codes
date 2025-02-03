//
//  SearchSugViewController.swift
//  huanxi
//
//  Created by rslz on 2024/12/19.
//

import RxSwift
import UIKit

class SearchSugViewController: BaseViewController {
    private let headerView = SearchSugHeaderView()
    private let viewModel = SearchViewModel()
    // 保存上一次的输入内容
    var lastInputText: String = ""
    
    private let popView: SearchSugPopView = {
        let view = SearchSugPopView()
        return view
    }()

    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        // 使 textField 成为第一响应者，弹出键盘
        headerView.textField.becomeFirstResponder()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sh_prefersNavigationBarHidden = true
        setupUI()
        bindUI()
    }

    func setupUI() {
        view.backgroundColor = .clear
        view.addSubview(headerView)
        headerView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(UIDevice.sy_navigationFullHeight)
        }

        view.addSubview(popView)
        popView.snp.makeConstraints { make in
            make.top.equalTo(headerView.snp.bottom).offset(5)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview().inset(UIDevice.sy_tabBarFullHeight)
        }
    }

    func bindUI() {
        headerView.cancleButton.rx.tapThrottle().subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            self.dismiss(animated: false)
        }).disposed(by: disposeBag)

        headerView.textField.rx.text
            .debounce(.milliseconds(300), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .skip(1)
            .subscribe(onNext: { [weak self] text in
                guard let self = self else { return }
                let trimmedString = text?.trimmingCharacters(in: .whitespacesAndNewlines)
                self.loadData(keyword: trimmedString ?? "")
            })
            .disposed(by: disposeBag)
        headerView.textField.rx.controlEvent(.editingDidEndOnExit)
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                
                // 获取当前输入框中的文本
                let currentText = self.headerView.textField.text ?? ""
                
                let vc = SearchResultContainerVC()
                vc.keyword = currentText
                vc.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(vc, animated: true)
            })
            .disposed(by: disposeBag)
        
        self.viewModel.searchUesrs
            .subscribe(onNext: { [weak self] cellTypes in
                guard let `self` = self else { return }
                guard !cellTypes.isEmpty else { return }
                self.popView.items = cellTypes
            })
            .disposed(by: disposeBag)

        popView.onItemTap = { [weak self] user in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.openUserPage(user)
            }
        }
    }
    
    func keyboardWillHide() {
        // 键盘隐藏时，收回第一响应者
        self.view.endEditing(true)
    }
}

extension SearchSugViewController {
    private func loadData(keyword: String) {
        viewModel.requestSearchUser(keyword: keyword, completion: {success in })
    }
}

extension SearchSugViewController {
    func openUserPage(_ model: UserInfoModel?) {
        let vc = MineViewController()
        let user = LoginManager.shared.getUserInfo()
        vc.type = user?.userId == model?.userId ? .mySelf : MineType.other
        vc.userId = model?.userId ?? 0
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
}


/*代码功能

这段代码定义了一个名为 SearchSugViewController 的视图控制器，主要用于实现搜索建议功能。当用户在搜索框中输入关键词时，这个视图控制器会向服务器发送请求，获取匹配的搜索建议，并在界面上展示出来。

核心功能

搜索建议展示: 在搜索框下方弹出一个视图，显示搜索建议。
键盘交互: 当用户点击搜索框时，键盘弹出，并自动聚焦在搜索框上。
搜索请求: 当用户输入关键词时，向服务器发送请求，获取搜索建议。
结果展示: 将获取到的搜索建议展示在弹出的视图中。
用户选择: 用户点击某个搜索建议时，可以跳转到相应的页面。
代码结构

SearchSugViewController 类:
属性:
headerView: 搜索头部视图，包含搜索框和取消按钮。
popView: 用于展示搜索建议的弹出视图。
viewModel: 搜索视图模型，负责数据请求和更新。
方法:
viewDidAppear：使搜索框成为第一响应者，弹出键盘。
setupUI：设置界面布局。
bindUI：绑定视图和视图模型，实现数据双向绑定。
loadData：向服务器发送请求，获取搜索建议。
openUserPage：跳转到用户页面。
SearchViewModel 类:
负责管理搜索相关的业务逻辑，包括网络请求、数据处理等。
代码流程

用户输入: 用户在搜索框中输入关键词。
发送请求: 触发 loadData 方法，向服务器发送搜索请求。
获取数据: 服务器返回搜索建议数据。
更新 UI: 将搜索建议数据更新到 popView 中。
用户选择: 用户点击某个搜索建议，触发 openUserPage 方法，跳转到相应页面。
关键点

RxSwift: 使用 RxSwift 来实现响应式编程，简化数据流的管理。
debounce: 通过 debounce 操作符，延迟发送搜索请求，避免频繁请求。
数据绑定: 将视图和视图模型绑定在一起，实现数据变化时 UI 的自动更新。
键盘交互: 自动弹出键盘，方便用户输入。
可能存在的优化点

搜索建议的展示方式: 可以考虑使用 UITableView 或 UICollectionView 来展示搜索建议，提供更好的用户体验。
搜索历史: 可以保存用户的搜索历史，方便用户快速再次搜索。
错误处理: 可以添加错误处理机制，当网络请求失败时，提示用户。
性能优化: 可以优化网络请求和数据渲染，提高应用的流畅性。
总结

这段代码实现了一个功能相对完善的搜索建议功能。通过使用 RxSwift 和 MVVM 模式，使得代码结构清晰，易于维护。
 */
