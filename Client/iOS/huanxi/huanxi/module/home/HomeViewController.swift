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
import BUAdSDK

class HomeViewController: BaseViewController {
    
    private var cancellable: AnyCancellable?

    private let viewModel = HomeViewModel()

    lazy var tableView: UITableView = {
        let view = UITableView.init(frame: CGRect.zero, style: UITableView.Style.plain)
        view.backgroundColor = .clear
        view.separatorColor = .clear
        view.separatorStyle = .none

        view.register(HomeUserCell.self, forCellReuseIdentifier: HomeUserCell.defaultReuseIdentifier)
        view.register(MainContentCell.self, forCellReuseIdentifier: MainContentCell.defaultReuseIdentifier)
        view.register(HemeRecommendCell.self, forCellReuseIdentifier: HemeRecommendCell.defaultReuseIdentifier)
        
        //信息流广告
        view.register(BUMDFeedAdLeftTableViewCell.self, forCellReuseIdentifier: "BUMDFeedAdLeftTableViewCell")
        view.register(BUMDFeedAdLargeTableViewCell.self, forCellReuseIdentifier: "BUMDFeedAdLargeTableViewCell")
        view.register(BUMDFeedAdGroupTableViewCell.self, forCellReuseIdentifier: "BUMDFeedAdGroupTableViewCell")
        view.register(BUMDFeedVideoAdTableViewCell.self, forCellReuseIdentifier: "BUMDFeedVideoAdTableViewCell")
        view.register(UITableViewCell.self, forCellReuseIdentifier: "UITableViewCell")

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
        self.viewModel.initSDK()
        self.viewModel.requestHomePosts()
        
        // 使用 Combine 订阅通知
        cancellable = NotificationCenter.default.publisher(for: .refreshMainPageNotification)
            .sink { notification in
                self.viewModel.requestHomePosts()
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
            self.viewModel.requestHomePosts()
        }.autoChangeTransparency(true)
        .link(to: tableView)
        header.setCustomHeadTitle()
        
        let footer = CustomAutoFooter { [weak self] in
            guard let `self` = self else { return }
            self.viewModel.requestHomePosts(reloadType: .loadMore)
        }.autoChangeTransparency(true).link(to: tableView)
        footer.setCustomNoMoreTitle()
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
        
//        let button = UIButton(type: .custom)
//        button.frame = CGRect(x: .screenWidth - 46, y: 7, width: 30, height: 30)
//        button.setImage(UIImage.init(named: "main_relay"), for: .normal)
//        button.addTarget(self, action: #selector(gotoDirect), for: .touchUpInside)
//        let rightItem = UIBarButtonItem(customView: button)
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
                case .ad(let model):
                    let cell = self.cellForNativeAd(tableView, indexPath: IndexPath(row: index, section: 0), nativeAd: model)
                    return cell ?? UITableViewCell()
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
                self.tableView.mj_header?.endRefreshing()
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
        
        self.viewModel.hasMoreRelay
            .subscribe(onNext: { [weak self] hasMore in
                guard let `self` = self else { return }
                if !hasMore {
                    self.tableView.mj_footer?.endRefreshingWithNoMoreData()
                } else {
                    self.tableView.mj_footer?.endRefreshing()
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
        emptyView.reloadBlock = { [weak self] in
            guard let self = self else { return }
            self.viewModel.requestHomePosts()
        }
    }
    
}

//MARK: ads UITableViewCell
extension HomeViewController {
    func heightForNativeAd(_ tableView: UITableView, indexPath: IndexPath, nativeAd: BUNativeAd) -> CGFloat {
        var width = tableView.bounds.width
        width -= view.safeAreaInsets.left + view.safeAreaInsets.right
        var height: CGFloat = 150
        if let isExpressAd = nativeAd.mediation?.isExpressAd, isExpressAd{
            height = nativeAd.mediation?.canvasView.bounds.height ?? 150
        } else {
            switch nativeAd.data?.imageMode {
            case .adModeSmallImage:
                height = BUMDFeedAdLeftTableViewCell.cellHeight(withModel: nativeAd, width: width)
            case .adModeLargeImage, .adModeImagePortrait:
                height = BUMDFeedAdLargeTableViewCell.cellHeight(withModel: nativeAd, width: width)
            case .adModeGroupImage:
                height = BUMDFeedAdGroupTableViewCell.cellHeight(withModel: nativeAd, width: width)
            case .videoAdModeImage:
                height = BUMDFeedVideoAdTableViewCell.cellHeight(withModel: nativeAd, width: width)
            default:
                break
            }
        }
        return height
    }
    
    func cellForNativeAd(_ tableView: UITableView, indexPath: IndexPath, nativeAd: BUNativeAd) -> UITableViewCell? {
        nativeAd.rootViewController = self
        nativeAd.delegate = self
        nativeAd.mediation?.canvasView.tag = 1000

        if let isExpressAd = nativeAd.mediation?.isExpressAd, isExpressAd{
            nativeAd.mediation?.render()
            // 模板视图
            let cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell", for: indexPath)
            cell.selectionStyle = .none
            // 重用 BUNativeExpressAdView，先把之前的广告视图取下来，再添加上当前视图
            if let subView = cell.contentView.viewWithTag(1000) {
                subView.removeFromSuperview()
            }
            cell.contentView.addSubview(nativeAd.mediation?.canvasView ?? UIView())
            return cell
        } else {
            // 自渲染
            var cell: BUMDFeedAdBaseTableViewCell?
            switch nativeAd.data?.imageMode {
            case .adModeSmallImage:
                cell = tableView.dequeueReusableCell(withIdentifier: "BUMDFeedAdLeftTableViewCell", for: indexPath) as? BUMDFeedAdLeftTableViewCell
            case .adModeLargeImage, .adModeImagePortrait:
                cell = tableView.dequeueReusableCell(withIdentifier: "BUMDFeedAdLargeTableViewCell", for: indexPath) as? BUMDFeedAdLargeTableViewCell
            case .adModeGroupImage:
                cell = tableView.dequeueReusableCell(withIdentifier: "BUMDFeedAdGroupTableViewCell", for: indexPath) as? BUMDFeedAdGroupTableViewCell
            case .videoAdModeImage, .videoAdModePortrait:
                cell = tableView.dequeueReusableCell(withIdentifier: "BUMDFeedVideoAdTableViewCell", for: indexPath) as? BUMDFeedVideoAdTableViewCell
            default:
                cell = tableView.dequeueReusableCell(withIdentifier: "BUMDFeedAdBaseTableViewCell", for: indexPath) as? BUMDFeedAdBaseTableViewCell
            }
            if let cell = cell {
                cell.tag = indexPath.row
                cell.cellClose = { [weak self] index, cell in
                    guard let `self` = self else { return }
                    if index < self.viewModel.dataList.value.count{
                        cell.nativeAdView = nil
                        self.viewModel.removeItem(index: index)
                    }
                }
                cell.refreshUI(withModel: nativeAd)
            }
            return cell
        }
    }
}

//MARK: UITableViewDelegate
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
            let imgH = traitCollection.horizontalSizeClass == .regular ? 500.0 : 410.0
            return 160 + imgH + (contentH > 50 ? 50 : contentH)
        case .userItem(_):
            return 120
        case .recommend:
            return 330
        case .ad(let ad):
            let contentH = self.heightForNativeAd(tableView, indexPath: indexPath, nativeAd: ad)
            return contentH
        default:
            return UITableView.automaticDimension
        }
    }
}

//MARK: BUMNativeAdDelegate
extension HomeViewController: BUMNativeAdDelegate {
    
    func nativeAdDidBecomeVisible(_ nativeAd: BUNativeAd) {
        // 展示后可获取信息如下
        if let info = nativeAd.mediation?.getShowEcpmInfo() {
            debugPrint("ecpm: \(info.ecpm ?? "N/A")")
            debugPrint("platform: \(info.adnName)")
            debugPrint("ritID: \(info.slotID)")
            debugPrint("requestID: \(info.requestID ?? "None")")
        }
    }
    
    func nativeAdWillPresentFullScreenModal(_ nativeAd: BUNativeAd) {
        
    }
    
    func nativeAdExpressViewRenderSuccess(_ nativeAd: BUNativeAd) {
        debugPrint("nativeAdExpressViewRenderSuccess")
        if let index = self.viewModel.dataList.value.firstIndex(where: { $0.itemAd === nativeAd }) {
            let indexPaths = [
                IndexPath(row: index, section: 0)
            ]
            tableView.reloadRows(at: indexPaths, with: .fade)
        }
    }
    
    func nativeAdExpressViewRenderFail(_ nativeAd: BUNativeAd, error: (any Error)?) {
        
    }
    
    func nativeAdVideo(_ nativeAd: BUNativeAd?, stateDidChanged playerState: BUPlayerPlayState) {
        
    }
    
    func nativeAd(_ nativeAd: BUNativeAd?, dislikeWithReason filterWords: [BUDislikeWords]?) {

        // 遍历所有可见的 cell
        for cell in tableView.visibleCells {
            if let adCell = cell as? BUMDFeedAdBaseTableViewCell {
                adCell.nativeAdView = nil
            }
            
            if let adView = cell.contentView.viewWithTag(1000) {
                adView.removeFromSuperview()
            }
        }

        // 移除广告视图
        nativeAd?.mediation?.canvasView.removeFromSuperview()

        // 刷新表格
        // 从数据源中移除 nativeAd
        if let index = self.viewModel.dataList.value.firstIndex(where: { $0.itemAd === nativeAd }) {
            self.viewModel.removeItem(index: index)
        }
    }
    
    
    func nativeAdVideoDidClick(_ nativeAd: BUNativeAd?) {
        
    }
    
    func nativeAdVideoDidPlayFinish(_ nativeAd: BUNativeAd?) {
        
    }
    
    func nativeAdShakeViewDidDismiss(_ nativeAd: BUNativeAd?) {
        
    }
    
    func nativeAdVideo(_ nativeAdView: BUNativeAd?, rewardDidCountDown countDown: Int) {
        
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
            let userBriefVC = UserBriefVC()
            userBriefVC.user = data.user
            userBriefVC.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(userBriefVC, animated: true)
            postMorePopView.close()
        }).disposed(by: disposeBag)
        postMorePopView.uninterestedButton.rx.tapThrottle().subscribe(onNext: { [weak self] _ in
            guard let `self` = self else { return }
            postMorePopView.close()
            HUDHelper.showHUD()
            self.viewModel.requestMarkPost(params: ["postId" : "\(data.postId ?? 0)", "filterType": "不敢兴趣"], indexPath: indexPath) { success in
                HUDHelper.hideHUD()
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



extension HomeViewController {
    @objc func gotoDirect() {
        let vc = DirectViewController()
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
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
