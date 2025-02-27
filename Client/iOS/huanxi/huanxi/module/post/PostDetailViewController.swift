//
//  PostDetailViewController.swift
//  huanxi
//
//  Created by rslz on 2025/1/21.
//

import UIKit
import SwiftUI
import Combine
import MJRefresh

class PostDetailViewController: BaseViewController {
        
    private let viewModel = PostDetailViewModel()

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
        
    var postItem: PostModel? {
        didSet {
            guard let model = postItem else { return }
            self.viewModel.dataList.accept([PostDetailViewModel.CellType.postItem(model)])
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        bindUI()
    }
    
    func setupView() {
        setupNavView()
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func setupNavView() {
        
        self.navigationItem.title = "帖子"
        
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
    
    
    // MARK: - 设置空视图or错误视图
    private func setEmptyOrNetErrorView(_ type: CCEmptyType) {
        emptyView.removeFromSuperview()
        view.addSubview(emptyView)
        emptyView.snp.makeConstraints { make in
            make.centerY.equalToSuperview().offset(-80)
            make.centerX.equalToSuperview()
        }
        emptyView.updateType(type: type)
    }
    
}

extension PostDetailViewController: UITableViewDelegate {
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


extension PostDetailViewController: MainContentCellDelegate {
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
            let userBriefVC = UserBriefVC()
            userBriefVC.user = data.user
            userBriefVC.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(userBriefVC, animated: true)
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
    
    func didClickAvatar(_ data: PostModel) {
        self.openUserPage(data.user)
    }
    
    func didClickComment(_ data: PostModel) {
     
    }
    
    func didClickShare(_ data: PostModel) {
  
    }
    

}



extension PostDetailViewController {
    func openUserPage(_ model: UserInfoModel?) {
        let user = LoginManager.shared.getUserInfo()
        if user?.userId != model?.userId {
            let vc = OtherMineVC()
            vc.userId = model?.userId ?? 0
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        } else {
            let vc = MineViewController()
            vc.userId = model?.userId ?? 0
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}


/*代码分析：帖子详情页视图控制器
整体功能

这段代码实现了一个 iOS 应用程序的帖子详情页视图控制器。它主要负责展示帖子内容、处理用户交互（点赞、收藏、评论等）、以及与后台进行数据交互。

核心功能和代码解读

ViewModel:
PostDetailViewModel: 该 ViewModel 负责管理帖子详情页的数据和业务逻辑，包括：
dataList: 一个包含不同类型 Cell 的数组，用于驱动 UITableView 的数据源。
fetchLikeAction, fetchCollectAction, requestDeletePost 等方法用于处理点赞、收藏、删除等操作。
UITableView:
用于展示帖子内容、用户、推荐等信息。
使用 rxSwift 绑定数据源，实现数据驱动 UI。
自定义 Cell 类型：
MainContentCell: 展示帖子主要内容。
HomeUserCell: 展示用户信息。
HemeRecommendCell: 展示推荐用户。
视图交互:
点赞、收藏、评论、分享: 通过 MainContentCellDelegate 协议处理用户点击事件，并调用 ViewModel 中相应的方法。
用户跳转: 点击用户头像时，跳转到用户个人页面。
空状态和错误状态: 当没有数据或网络错误时，显示相应的空视图。
代码亮点

MVVM模式: 清晰地分开了视图和数据逻辑，提高了代码的可维护性。
RxSwift: 使用 RxSwift 进行数据绑定和事件处理，使得代码更加简洁和反应式。
自定义Cell: 针对不同的数据类型，使用了不同的 Cell，提高了 UI 的灵活性和可扩展性。
空状态处理: 考虑了数据为空或网络错误的情况，显示相应的空视图。
潜在改进

错误处理: 可以对网络请求错误进行更详细的处理，例如显示错误信息、重试机制等。
性能优化: 对于大量数据，可以考虑使用分页加载、缓存等优化手段。
单元测试: 可以编写单元测试来保证代码的正确性。
国际化: 可以使用 Localizable.strings 文件来实现多语言支持。
可访问性: 可以考虑使用 Accessibility 特性，提高应用的可访问性。*/
