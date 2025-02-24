//
//  SquareViewController.swift
//  huanxi
//
//  Created by rslz on 2025/1/20.
//

import UIKit
import SwiftUI
import Combine
import MJRefresh

class SquareViewController: BaseViewController {
    
    private var cancellable: AnyCancellable?
    
    private let viewModel = SquareViewModel()

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
        
        self.navigationItem.title = "广场"
        
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

extension SquareViewController: UITableViewDelegate {
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


extension SquareViewController: MainContentCellDelegate {
    func didClickMore(_ data: PostModel, indexPath: IndexPath?) {
        let postMorePopView = PostMorePopView()
        postMorePopView.show(data)
        postMorePopView.trashButton.rx.tapThrottle().subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            postMorePopView.close()
            self.viewModel.requestDeletePost(params: ["postId" : data.postId ?? 0], indexPath: indexPath) { success in}
        }).disposed(by: disposeBag)
        postMorePopView.briefcaseButton.rx.tapThrottle().subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            self.openUserPage(data.user)
            postMorePopView.close()
        }).disposed(by: disposeBag)
        postMorePopView.uninterestedButton.rx.tapThrottle().subscribe(onNext: { [weak self] _ in
            guard let `self` = self else { return }
            postMorePopView.close()
            self.viewModel.requestMarkPost(params: ["postId" : "\(data.postId ?? 0)", "filterType": "不敢兴趣"], indexPath: indexPath) { success in
                if success {
                    HUDHelper.showSuccessToast("反馈成功")
                }
            }
        }).disposed(by: disposeBag)
        postMorePopView.reportButton.rx.tapThrottle().subscribe(onNext: { [weak self] _ in
            guard let `self` = self else { return }
            postMorePopView.close()
            Task {
                let result = await ReportReasonVC.startReportReason(postMorePopView.postModel)
                if result {
                    self.viewModel.hiddenReport(indexPath: indexPath)
                    HUDHelper.showSuccessToast("举报成功，我们会尽快处理")
                }
            }
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



extension SquareViewController {
    func openUserPage(_ model: UserInfoModel?) {
        let vc = MineViewController()
        let user = LoginManager.shared.getUserInfo()
        vc.type = user?.userId == model?.userId ? .mySelf : MineType.other
        vc.userId = model?.userId ?? 0
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}

/*代码功能：

这段代码定义了一个自定义的 UITableViewCell，名为 UpdatesRecommendCell，主要用于社交媒体应用中展示推荐关注的用户。它通常会出现在动态列表中，显示一些你可能感兴趣的用户信息。

主要功能点：

UI 布局: 使用 SnapKit 对 cell 内部的子视图（头像、昵称、内容文本、标签、关注按钮、关闭按钮）进行布局，使其在不同屏幕尺寸下都能保持良好的显示效果。
数据展示: 通过 reloadData 方法设置 cell 的内容，包括头像图片、用户昵称、推荐理由、标签（如热门）以及关注按钮和关闭按钮的状态。
交互功能: 提供了两个按钮：
followBtn: 用于关注或取消关注推荐用户。
closeBtn: 用于关闭该推荐项，不再显示。
这两个按钮都绑定了对应的闭包，以便在点击时触发相应的操作。
代码结构：

类名: UpdatesRecommendCell，明确表示这个类用于展示推荐的更新。
属性:
followBlock: 一个闭包，用于在点击关注按钮时执行自定义操作。
closeBlock: 一个闭包，用于在点击关闭按钮时执行自定义操作。
icon: 用于显示头像的 UIImageView。
nameLabel: 用于显示用户昵称的 UILabel。
contentLabel: 用于显示推荐理由的 UILabel。
tagLabel: 用于显示标签的 UILabel。
followBtn: 用于关注或取消关注的 UIButton。
closeBtn: 用于关闭推荐项的 UIButton。
方法:
init(style:reuseIdentifier:): 初始化方法，设置 cell 的样式和重用标识符。
reloadData：更新 cell 的内容，包括头像、内容和时间。
setupView: 配置 cell 的子视图，设置约束和样式。
followAction: 关注按钮的点击事件处理函数，触发 followBlock 回调。
closeAction: 关闭按钮的点击事件处理函数，触发 closeBlock 回调。
代码逻辑:

初始化: 创建 cell 时，会调用 setupView 方法来设置子视图的布局和样式。
更新数据: 当需要显示新的数据时，调用 reloadData 方法更新 cell 的内容。
显示内容: cell 的内容包括头像、昵称、推荐理由、标签、关注按钮和关闭按钮，这些信息通过对应的属性和约束来显示。
用户交互: 点击关注按钮或关闭按钮时，会触发相应的闭包，可以执行自定义的逻辑，比如发送网络请求、更新数据源等。
潜在改进:

数据源: 当前代码中，reloadData 方法直接硬编码了数据。在实际应用中，应该通过数据源来动态设置 cell 的内容。
自定义样式: 可以提供更多的自定义选项，比如允许用户自定义 cell 的外观。
性能优化: 如果有大量的数据需要展示，可以考虑使用异步加载图片、复用 cell 等方式来优化性能。
 可访问性: 考虑为视障用户提供更好的访问性，比如使用语义化的标签和设置适当的对比度。*/
