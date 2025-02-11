//
//  MineViewController.swift
//  huanxi
//
//  Created by jack on 2024/2/18.
//

import UIKit
import JXSegmentedView

enum MineType {
    case mySelf
    case other
}

class MineViewController: BaseViewController {
    
    var type: MineType = .mySelf

    var userId: Int = LoginManager.shared.getUserInfo()?.userId ?? 0
    
    var currentUser: UserInfoModel? = UserInfoModel()

    private let backButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage.init(systemName: "chevron.backward")?.withRenderingMode(.alwaysOriginal), for: .normal)
        button.tintColor = .white
        // 配置按钮的样式
        var config = UIButton.Configuration.plain()
//        config.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 15)
        button.configuration = config
        return button
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 20)
        return label
    }()
    
    private let setButton: UIButton = UIButton().then({view in
        view.setImage(UIImage(named: "main_more"), for: .normal)
    })
    
    private let navStackView = UIStackView().then({view in
        view.axis = .horizontal
        view.alignment = .center
    })
    
    lazy var mineUserInfoView = MineHeaderView(type: type)
    
    private let titleDataSource: JXSegmentedTitleImageDataSource = {
        let dataSource = JXSegmentedTitleImageDataSource()
        dataSource.isItemSpacingAverageEnabled = true
        dataSource.titles = [MineViewModel.ListType.publish.value, MineViewModel.ListType.collect.value]
        dataSource.titleImageType = .onlyImage
        dataSource.imageSize = CGSize(width: 25, height: 25)
//        dataSource.isImageZoomEnabled = true
        dataSource.normalImageInfos = ["mine_post", "mine_mark"]
        dataSource.selectedImageInfos = ["mine_post", "mine_mark"]
        return dataSource
    }()
        
    private let segmentedView: JXSegmentedView = {
        let view = JXSegmentedView()
        let indicator = JXSegmentedIndicatorLineView()
        indicator.indicatorHeight = 0
        view.indicators = [indicator]
        return view
    }()
    
    lazy var listContainerView: JXSegmentedListContainerView = {
        return JXSegmentedListContainerView(dataSource: self)
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        switch type {
        case .mySelf:
            if LoginManager.shared.isLogin() {
                LoginManager.requestUserInfo { [weak self] success in
                    guard let `self` = self else { return }
                    self.currentUser = LoginManager.shared.getUserInfo()
                    self.nameLabel.text = LoginManager.shared.getUserInfo()?.fullName ?? "游客"
                    self.mineUserInfoView.reloadData(LoginManager.shared.getUserInfo())
                }
            }
        case .other:
            LoginManager.requestOtherUserInfo(userId: "\(userId)") { [weak self] user in
                guard let `self` = self else { return }
                self.currentUser = user
                self.nameLabel.text = user?.fullName ?? "游客"
                self.mineUserInfoView.reloadData(user)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.currentUser?.userId = userId
        setupUI()
        sh_prefersNavigationBarHidden = true
        
    }
    
    
    func setupUI() {
        view.addSubview(navStackView)
        
        backButton.rx.tapThrottle().subscribe(onNext: { [weak self] _ in
            guard let `self` = self else { return }
            self.onBackTap()
        }).disposed(by: disposeBag)
        
        setButton.rx.tapThrottle().subscribe(onNext: { [weak self] _ in
            guard let `self` = self else { return }
            let vc = SettingViewController()
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        }).disposed(by: disposeBag)
        
        if type == .mySelf {
            navStackView.distribution = .equalSpacing
            [nameLabel, setButton].forEach{ navStackView.addArrangedSubview($0) }
            navStackView.snp.makeConstraints { make in
                make.leading.trailing.equalToSuperview().inset(15)
                make.top.equalTo(UIDevice.sy_safeDistanceTop)
                make.height.equalTo(UIDevice.sy_navigationBarHeight)
            }
            nameLabel.snp.makeConstraints { make in
                make.width.lessThanOrEqualTo(100)
            }
        } else {
            navStackView.distribution = .fill
            [backButton, nameLabel].forEach{ navStackView.addArrangedSubview($0) }
            navStackView.snp.makeConstraints { make in
                make.leading.equalToSuperview()
                make.top.equalTo(UIDevice.sy_safeDistanceTop)
                make.height.equalTo(UIDevice.sy_navigationBarHeight)
            }
            nameLabel.snp.makeConstraints { make in
                make.width.lessThanOrEqualTo(100)
            }
        }

        view.addSubview(mineUserInfoView)
        mineUserInfoView.snp.makeConstraints { make in
            make.top.equalTo(navStackView.snp.bottom)
            make.leading.trailing.equalToSuperview()
        }
        mineUserInfoView.editHomePageBlock = { [weak self] in
            guard let `self` = self else { return }
            let vc = EditProfileVC()
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        }
        mineUserInfoView.onFollowTap = { [weak self] type in
            guard let `self` = self else { return }
//            if self.type == .other {
//                return
//            }
            let vc = MineFollowContainerVC()
            vc.currentUser = self.currentUser
            vc.listType = type
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        }

        segmentedView.dataSource = titleDataSource
        view.addSubview(segmentedView)
        segmentedView.snp.makeConstraints { make in
            make.top.equalTo(mineUserInfoView.snp.bottom).offset(15)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(35)
        }

        segmentedView.listContainer = listContainerView
        view.addSubview(listContainerView)
        listContainerView.snp.makeConstraints { make in
            make.top.equalTo(segmentedView.snp.bottom)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }

}

extension MineViewController: JXSegmentedListContainerViewDataSource {
    func numberOfLists(in listContainerView: JXSegmentedListContainerView) -> Int {
        if let titleDataSource = segmentedView.dataSource as? JXSegmentedBaseDataSource {
            return titleDataSource.dataSource.count
        }
        return 0
    }

    func listContainerView(_ listContainerView: JXSegmentedListContainerView, initListAt index: Int) -> JXSegmentedListContainerViewListDelegate {
        let vc = MineCollectListVC()
        vc.listType = MineViewModel.ListType(rawValue: index) ?? .collect
        vc.userId = "\(userId)"
        return vc
    }
}


/*代码功能：
 
 这段代码定义了一个名为 MineViewModel 的类，用于管理个人中心页面的数据和逻辑。它主要负责：

 数据模型: 定义了 CellType、ListType 和 ProfileType 三种枚举类型，分别表示 cell 的类型、列表的类型和用户个人资料的字段类型。
 数据源: 使用 BehaviorRelay 维护 dataList 和 followList 两个数据源，分别存储帖子列表、收藏列表、关注列表和粉丝列表。
 网络请求: 提供了 requestPostList、fetchFollowsList、fetchFanslist 和 uploadAvatar 等方法，用于向服务器发送网络请求，获取或更新用户数据。
 UI 绑定: 通过 bindUI 方法将数据源与 UI 控件绑定，实现数据更新时自动刷新 UI。
 代码结构:

 MineViewModel 类: 是整个类的核心，负责管理数据和业务逻辑。
 枚举类型: CellType、ListType 和 ProfileType 用于定义不同类型的数据和配置。
 属性: dataList、followList 用于存储数据，cancellable 用于管理订阅。
 方法: 提供了各种方法用于获取数据、更新 UI、处理用户交互等。
 代码逻辑:

 初始化: 创建 MineViewModel 实例时，会初始化数据源和一些配置。
 网络请求: 通过 requestPostList、fetchFollowsList、fetchFanslist 和 uploadAvatar 方法向服务器发送网络请求，获取或更新用户数据。
 数据绑定: 使用 bindUI 方法将数据源与 UI 控件绑定，实现数据更新时自动刷新 UI。
 UI 更新: 通过 dataList 和 followList 的变化来触发 UI 更新，例如刷新列表视图。
 用户交互: 提供了处理用户交互的接口，例如上传头像、关注/取消关注等。
 代码亮点:

 使用 Combine: 使用 Combine 框架来处理异步操作和数据流。
 数据驱动 UI: 通过 BehaviorRelay 实现数据驱动 UI，当数据发生变化时，UI 会自动更新。
 模块化: 将不同的功能模块化，提高代码的可维护性。
 错误处理: 虽然代码中没有显式地展示错误处理，但一般会在网络请求中加入错误处理逻辑，以保证应用的稳定性。
 潜在改进:

 错误处理: 可以进一步完善错误处理，例如针对不同类型的网络错误显示不同的错误提示。
 数据缓存: 可以考虑缓存数据，以提高性能和减少网络请求。
 分页加载: 可以实现分页加载，以提高用户体验。
 单元测试: 可以编写单元测试来验证代码的正确性和稳定性。
*/
