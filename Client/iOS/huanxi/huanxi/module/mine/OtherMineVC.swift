//
//  OtherMineVC.swift
//  huanxi
//
//  Created by rslz on 2025/2/25.
//

import UIKit
import JXSegmentedView


class OtherMineVC: BaseViewController {
    
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
    
    lazy var mineUserInfoView = MineHeaderView(type: .other)
    
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
        LoginManager.requestOtherUserInfo(userId: "\(userId)") { [weak self] result in
            guard let `self` = self else { return }
            guard let result = result else { return }
            self.currentUser = result.0
            self.nameLabel.text = self.currentUser?.fullName ?? "游客"
            self.mineUserInfoView.reloadData(self.currentUser)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.currentUser?.userId = userId
        setupUI()
        bindUI()
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
