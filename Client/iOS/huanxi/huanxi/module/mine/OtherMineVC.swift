//
//  OtherMineVC.swift
//  huanxi
//
//  Created by rslz on 2025/2/25.
//

import UIKit
import JXSegmentedView
import RxSwift
import RxCocoa
import SDCAlertView

class OtherMineVC: BaseViewController {
    
    enum OperatButtonType {
        case none  // 加载中
        case follow // 关注
        case followed // 已关注
        case blacked // 已拉黑
    }
    
    var userId: Int = 0
    
    var currentUser: UpdateUserModel = UpdateUserModel()

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
        view.distribution = .fill
    })
    
    private lazy var mineUserInfoView = MineHeaderView(type: .other)
    private let operatButton = UIButton().then({view in
        view.setTitle("关注", for: .normal)
        view.titleLabel?.font = .systemFont(ofSize: 14)
        view.layer.cornerRadius = 6
        view.tintColor = .white
    })
    
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

    ///取关抽屉
    private let drawerView: DrawerView = {
        let view = DrawerView()
        view.accessibilityIdentifier = "PostMorePopView"
        view.backgroundColor = UIColor.postBgColor
        view.snapPositions = [.closed, .open]
        view.position = .open
        view.openHeightBehavior = .fixed(height: 200)
        view.cornerRadius = 20
        return view
    }()
    
    private lazy var blackTipView: BlackTipView = {
        let blackTipView = BlackTipView()
        return blackTipView
    }()
    
    private let operatButtonStateRelay = BehaviorRelay<OperatButtonType>(value: .none)
    
    private let viewModel = MineViewModel()

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindUI()
        sh_prefersNavigationBarHidden = true
    }
    
    private func loadData() {
        LoginManager.requestOtherUserInfo(userId: "\(userId)") { [weak self] result in
            guard let `self` = self else { return }
            guard let result = result else { return }
            self.currentUser = result
            self.nameLabel.text = self.currentUser.user?.fullName ?? "游客"
            self.mineUserInfoView.reloadData(self.currentUser.user)
            if (self.currentUser.reported ?? false) {
                self.operatButtonStateRelay.accept(.blacked)
            } else {
                let type:OperatButtonType = (self.currentUser.followed ?? false) ? .followed : .follow
                self.operatButtonStateRelay.accept(type)
            }
        }
    }
    
    private func setupUI() {
        view.addSubview(navStackView)
        
        backButton.rx.tapThrottle().subscribe(onNext: { [weak self] _ in
            guard let `self` = self else { return }
            self.onBackTap()
        }).disposed(by: disposeBag)
        
        setButton.rx.tapThrottle().subscribe(onNext: { [weak self] _ in
            guard let `self` = self else { return }
            CustomAlertView.showCustomAlert(preferredStyle: .actionSheet, actions: [
                AlertAction(title: "取消", style: .preferred),
                AlertAction(title: "拉黑", style: .destructive, handler: { [weak self] _ in
                    guard let `self` = self else { return }
                    CustomAlertView.showCustomAlert(title: "确定将“\(self.nameLabel.text ?? "")”拉黑？", preferredStyle: .alert, actions: [
                        AlertAction(title: "取消", style: .preferred),
                        AlertAction(title: "拉黑", style: .destructive, handler: { [weak self] _ in
                            guard let `self` = self else { return }
                            Task {
                                HUDHelper.showHUD()
                                let success = await self.viewModel.fetchUserReports(self.userId)
                                HUDHelper.hideHUD()
                                if success {
                                    self.currentUser.reported = true
                                    self.operatButtonStateRelay.accept(.blacked)
                                }
                            }
                        }),
                    ])
                }),
                AlertAction(title: "账户简介", style: .normal, handler: { [weak self] _ in
                    guard let `self` = self else { return }
                    let userBriefVC = UserBriefVC()
                    userBriefVC.user = self.currentUser.user
                    self.navigationController?.pushViewController(userBriefVC, animated: true)
                }),
            ])
        }).disposed(by: disposeBag)
        
        let space = UIView()
        [backButton, nameLabel, space, setButton].forEach{ navStackView.addArrangedSubview($0) }
        navStackView.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview().inset(15)
            make.top.equalTo(UIDevice.sy_safeDistanceTop)
            make.height.equalTo(UIDevice.sy_navigationBarHeight)
        }
        nameLabel.snp.makeConstraints { make in
            make.width.lessThanOrEqualTo(100)
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
            let vc = MineFollowContainerVC()
            vc.currentUser = self.currentUser.user
            vc.listType = type
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
        view.addSubview(operatButton)
        operatButton.snp.makeConstraints { make in
            make.height.equalTo(30)
            make.top.equalTo(mineUserInfoView.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(15)
        }

        segmentedView.dataSource = titleDataSource
        view.addSubview(segmentedView)
        segmentedView.snp.makeConstraints { make in
            make.top.equalTo(operatButton.snp.bottom).offset(15)
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
    
    func bindUI() {
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
        
        operatButton.rx.tapThrottle().subscribe(onNext: { [weak self] _ in
            guard let `self` = self else { return }
            let buttonState = operatButtonStateRelay.value
            switch buttonState {
            case .none:
                break
            case .follow:
                Task {
                    HUDHelper.showHUD()
                    let success = await self.viewModel.fetchFollow(self.userId)
                    HUDHelper.hideHUD()
                    if success {
                        self.currentUser.followed = true
                        self.operatButtonStateRelay.accept(.followed)
                    }
                }
            case .followed:
                let popView = UnFollowPopView()
                popView.show(self.nameLabel.text)
                popView.reportButton.rx.tapThrottle().subscribe(onNext: { [weak self] _ in
                    guard let `self` = self else { return }
                    popView.close()
                    Task {
                        HUDHelper.showHUD()
                        let success = await self.viewModel.fetchUnFollow(self.userId)
                        HUDHelper.hideHUD()
                        if success {
                            self.currentUser.followed = false
                            self.operatButtonStateRelay.accept(.follow)
                        }
                    }
                }).disposed(by: disposeBag)
            case .blacked:
                Task {
                    HUDHelper.showHUD()
                    let success = await self.viewModel.fetchUserReports(self.userId, canaleBlack: true)
                    HUDHelper.hideHUD()
                    if success {
                        self.currentUser.reported = false
                        self.operatButtonStateRelay.accept(.follow)
                    }
                }
            }
            
        }).disposed(by: disposeBag)
        
        operatButtonStateRelay
            .subscribe(onNext: { [weak self] buttonState in
                guard let `self` = self else { return }
                operatButton.setImage(UIImage(), for: .normal)
                operatButton.setImgPosition(postion: .Right, spacing: 0)
                operatButton.backgroundColor = .clear
                blackTipView.removeFromSuperview()
                switch buttonState {
                case .none:
                    operatButton.setTitle("加载中", for: .normal)
                    operatButton.layer.borderWidth = 1
                    operatButton.layer.borderColor = UIColor.white.cgColor
                case .follow:
                    operatButton.setTitle("关注", for: .normal)
                    operatButton.layer.borderWidth = 0
                    operatButton.backgroundColor = .mainBlueColor
                case .followed:
                    operatButton.setTitle("已关注", for: .normal)
                    operatButton.setImage(UIImage.init(systemName: "chevron.down")?.withRenderingMode(.alwaysOriginal), for: .normal)
                    operatButton.layer.borderWidth = 1
                    operatButton.layer.borderColor = UIColor.white.cgColor
                    operatButton.setImgPosition(postion: .Right, spacing: 5)
                case .blacked:
                    operatButton.setTitle("取消拉黑", for: .normal)
                    operatButton.layer.borderWidth = 0
                    operatButton.backgroundColor = .mainBlueColor
                    setErrorView()
                }
            })
            .disposed(by: disposeBag)
    }
    
    // MARK: - 设置错误视图
    private func setErrorView() {
        blackTipView.removeFromSuperview()
        view.addSubview(blackTipView)
        blackTipView.snp.makeConstraints { make in
            make.top.equalTo(segmentedView.snp.bottom)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }

}

extension OtherMineVC: JXSegmentedListContainerViewDataSource {
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
