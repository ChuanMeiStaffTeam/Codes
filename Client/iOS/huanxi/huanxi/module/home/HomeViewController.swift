//
//  HomeViewController.swift
//  huanxi
//
//  Created by jack on 2024/2/18.
//

import UIKit
import SwiftUI
import Combine
import MJRefresh

class HomeViewController: BaseViewController {
    
    private var cancellable: AnyCancellable?

    private let viewModel = HomeViewModel()

    lazy var tableView: UITableView = {
        let view = UITableView.init(frame: CGRect.zero, style: UITableView.Style.plain)
        view.backgroundColor = .clear
        view.separatorColor = .clear
        view.register(HomeUserCell.self, forCellReuseIdentifier: HomeUserCell.defaultReuseIdentifier)
        view.register(MainContentCell.self, forCellReuseIdentifier: MainContentCell.defaultReuseIdentifier)
        view.register(HemeRecommendCell.self, forCellReuseIdentifier: HemeRecommendCell.defaultReuseIdentifier)
        return view
    }()

    private lazy var emptyView: CCEmptyView = {
        let emptyView = CCEmptyView()
        return emptyView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        bindUI()
        refrehData()
        
        // 使用 Combine 订阅通知
        cancellable = NotificationCenter.default.publisher(for: .refreshMainPageNotification)
            .sink { notification in
                self.refrehData()
            }
    }
    
    deinit {
        // Combine 会自动取消订阅，但可以手动释放以确保安全
        cancellable?.cancel()
    }
    
    
    func setupView() {
        setupNavView()
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(0)
        }
        let header = MJRefreshNormalHeader { [weak self] in
            guard let self = self else { return }
            self.refrehData()
        }.autoChangeTransparency(true)
        .link(to: tableView)
        header.stateLabel?.isHidden = true
    }
    
    func setupNavView() {
        
        let view = UIView(frame: CGRect.init(x: 0, y: 0, width: 150, height: 40))
        view.backgroundColor = .clear
        
        let imageView = UIImageView(image: UIImage.init(named: "huanxi.jpg"))
        imageView.frame = CGRect(x: -10, y: 4, width: 72, height: 36)
        imageView.contentMode = .scaleAspectFit
        view.addSubview(imageView)
        let leftItem = UIBarButtonItem(customView: view)
        self.navigationItem.leftBarButtonItem = leftItem
        
        let button = UIButton(type: .custom)
        button.frame = CGRect(x: .screenWidth - 46, y: 7, width: 30, height: 30)
        button.setImage(UIImage.init(named: "main_relay"), for: .normal)
        button.addTarget(self, action: #selector(gotoDirect), for: .touchUpInside)
        let rightItem = UIBarButtonItem(customView: button)
        self.navigationItem.rightBarButtonItem = rightItem
        
        // 隐藏导航栏底部的分割线
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.shadowImage = UIImage() // 隐藏分割线
        appearance.shadowColor = nil       // 确保无颜色
        appearance.backgroundColor = UIColor.black // 可选，设置导航栏背景颜色

        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
    }
    
    func bindUI() {
        
        tableView.rx.setDelegate(self).disposed(by: disposeBag)

        self.viewModel.dataList
            .bind(to: tableView.rx.items) { tableView, index, item in
                switch item {
                case .skeleton:
                    let cell = tableView.dequeueReusableCell(withIdentifier: MainContentCell.defaultReuseIdentifier, for: IndexPath(row: index, section: 0)) as! MainContentCell
                    cell.isSkeletonVisible = true
                    return cell
                case .postItem(let post):
                    let cell = tableView.dequeueReusableCell(withIdentifier: MainContentCell.defaultReuseIdentifier, for: IndexPath(row: index, section: 0)) as! MainContentCell
                    cell.isSkeletonVisible = false
                    cell.delegate = self
                    cell.model = post
                    cell.indexPath = IndexPath(row: index, section: 0)
                    return cell
                case .userItem(let users):
                    let cell = tableView.dequeueReusableCell(withIdentifier: HomeUserCell.defaultReuseIdentifier, for: IndexPath(row: index, section: 0)) as! HomeUserCell
                    cell.model = users
                    cell.didSelectItemBlock = { [weak self] user in
                        guard let `self` = self else { return }
                        self.openUserPage(user)
                    }
                    return cell
                case .recommend(let model):
                    let cell = tableView.dequeueReusableCell(withIdentifier: HemeRecommendCell.defaultReuseIdentifier, for: IndexPath(row: index, section: 0)) as! HemeRecommendCell
                    cell.model = model.users
                    cell.didSelectItemBlock = { [weak self] user in
                        guard let `self` = self else { return }
                        self.openUserPage(user)
                    }
                    cell.hiddenBlock = { [weak self] in
                        guard let `self` = self else { return }
                        self.viewModel.hiddenFollow(indexPath: IndexPath(row: index, section: 0))
                    }
                    return cell
                default:
                    let cell = UITableViewCell()
                    cell.backgroundColor = .clear
                    return cell
                }
            }
            .disposed(by: disposeBag)
        
        self.viewModel.dataList
            .subscribe(onNext: { [weak self] cellTypes in
                guard let `self` = self else { return }
                DispatchQueue.main.async {
                    if cellTypes.isEmpty {
                        self.setEmptyOrNetErrorView(.noData)
                    } else if cellTypes.first == .error {
                        self.setEmptyOrNetErrorView(.noNetwork)
                    } else {
                        self.emptyView.removeFromSuperview()
                    }
                }
            })
            .disposed(by: disposeBag)
        
        tableView.rx.itemSelected
            .withUnretained(self)
            .subscribe(onNext: { cellType in
            })
            .disposed(by: disposeBag)
        
    }
    
    
    private func refrehData() {
        viewModel.requestHomePosts { [weak self] result in
            guard let self = self else { return }
            self.tableView.mj_header?.endRefreshing()
        }
    }
    
    // MARK: - 设置空视图or错误视图
    private func setEmptyOrNetErrorView(_ type: CCEmptyType) {
        emptyView.removeFromSuperview()
        view.addSubview(emptyView)
        emptyView.snp.makeConstraints { make in
            make.centerY.equalToSuperview().offset(-80)
            make.centerX.equalToSuperview()
        }
        emptyView.updateType(type: type)
        emptyView.reloadBlock = { [weak self] in
            guard let self = self else { return }
            self.refrehData()
        }
    }
    
}

extension HomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let item = self.viewModel.dataList.value.ck_objIndex(indexPath.item) else {
            return 0
        }
        switch item {
        case .skeleton:
            return 620
        case .postItem(let post):
            let contentH = post.caption?.height(withConstrainedWidth: UIDevice.screenWidth - 20, font: .systemFont(ofSize: 14)) ?? 16
            return 570 + (contentH > 50 ? 50 : contentH)
        case .userItem(_):
            return 120
        case .recommend:
            return 330
        default:
            return 0
        }
    }
}


extension HomeViewController: MainContentCellDelegate {
    func didClickMore(_ data: PostModel, indexPath: IndexPath?) {
        let postMorePopView = PostMorePopView()
        postMorePopView.show(data)
        postMorePopView.trashButton.rx.tapThrottle().subscribe(onNext: { [weak self] _ in
            guard let `self` = self else { return }
            postMorePopView.close()
            self.viewModel.requestDeletePost(params: ["postId" : data.postId ?? 0], indexPath: indexPath) { success in}
        }).disposed(by: disposeBag)
        postMorePopView.briefcaseButton.rx.tapThrottle().subscribe(onNext: { [weak self] _ in
            guard let `self` = self else { return }
            self.openUserPage(data.user)
            postMorePopView.close()
        }).disposed(by: disposeBag)
        postMorePopView.uninterestedButton.rx.tapThrottle().subscribe(onNext: { [weak self] _ in
            guard let `self` = self else { return }
            postMorePopView.close()
            self.viewModel.requestMarkPost(params: ["postId" : data.postId ?? 0], indexPath: indexPath) { success in
                if success {
                    
                }
            }
        }).disposed(by: disposeBag)
        postMorePopView.reportButton.rx.tapThrottle().subscribe(onNext: { [weak self] _ in
            guard let `self` = self else { return }

        }).disposed(by: disposeBag)
    }
    
    func didClickLike(_ data: PostModel, indexPath: IndexPath?) {
        if !LoginManager.shared.isLogin() {
            Task {
                let loginResult = await LoginViewController.startLogin()
                if loginResult {
                    self.viewModel.fetchLikeAction(data, indexPath: indexPath)
                }
            }
        } else {
            self.viewModel.fetchLikeAction(data, indexPath: indexPath)
        }
    }
    
    func didClickMark(_ data: PostModel, indexPath: IndexPath?, markComplete: ((Bool) -> Void)?) {
        if !LoginManager.shared.isLogin() {
            Task {
                let loginResult = await LoginViewController.startLogin()
                if loginResult {
                    self.viewModel.fetchCollectAction(data, indexPath: indexPath) { favorite in
                        markComplete?(favorite)
                    }
                }
            }
        } else {
            self.viewModel.fetchCollectAction(data, indexPath: indexPath) { favorite in
                markComplete?(favorite)
            }
        }
    }
    
    func didClickComment(_ data: PostModel) {
     
    }
    
    func didClickShare(_ data: PostModel) {
  
    }
    

}



extension HomeViewController {
    @objc func gotoDirect() {
        let vc = DirectViewController()
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func openUserPage(_ model: UserInfoModel?) {
        let vc = MineViewController()
        let user = LoginManager.shared.getUserInfo()
        vc.type = user?.userId == model?.userId ? .mySelf : MineType.other
        vc.userId = model?.userId ?? 0
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
}


/*代码功能概览
 
 这段代码主要实现了一个 iOS 应用程序的首页视图控制器。它负责：

 展示内容： 通过 UITableView 显示各种类型的内容，包括帖子、用户、推荐等。
 数据获取： 使用 viewModel 从网络或本地数据源获取数据，并更新 UI。
 用户交互： 处理用户的各种交互，比如点击帖子、用户、点赞、收藏等。
 界面刷新： 支持下拉刷新功能。
 代码结构分析

 HomeViewController 类：

 属性：
 viewModel：负责数据管理和业务逻辑的视图模型。
 tableView：用于展示内容的主表格视图。
 emptyView：在没有数据时显示的空视图。
 cancellable：用于管理 Combine 订阅。
 方法：
 viewDidLoad：初始化视图，设置导航栏、表格视图，绑定数据，订阅通知。
 setupView：设置视图的布局。
 setupNavView：设置导航栏的样式。
 bindUI：将视图模型的数据绑定到表格视图上，处理用户交互。
 refrehData：刷新数据。
 setEmptyOrNetErrorView：显示空视图或错误视图。
 tableView(_:heightForRowAt:)：根据不同类型的 cell 计算行高。
 其他方法：处理各种用户交互事件，比如点击点赞、收藏等。
 数据绑定：

 使用 Combine 订阅 viewModel.dataList，实时更新表格视图。
 根据不同的数据类型（postItem, userItem, recommend 等），创建不同的 cell 类型，并设置对应的属性。
 用户交互：

 通过 tableView.rx.itemSelected 监听用户点击事件。
 根据点击的 cell 类型，执行不同的操作，比如跳转到用户详情页、点赞、收藏等。
 关键点和技术点：

 MVVM 模式： 将视图和数据逻辑分离，提高代码的可维护性。
 Combine： 用于声明式地处理异步操作和数据流。
 RxSwift： 用于响应式编程，将数据绑定到 UI。
 MJRefresh： 用于实现下拉刷新功能。
 自定义 cell： HomeUserCell, MainContentCell, HemeRecommendCell 等自定义 cell 用于展示不同类型的数据。
 可能的改进点：

 代码优化： 可以进一步优化代码结构，提高可读性。例如，可以将一些重复的代码封装成方法。
 错误处理： 可以添加更多的错误处理，比如网络请求失败时的处理。
 性能优化： 如果数据量较大，可以考虑使用分页加载，提高性能。
 UI/UX： 可以根据设计稿对界面进行优化，提高用户体验。
 测试： 可以编写单元测试，保证代码的正确性。*/
