//
//  HemeRecommendCell.swift
//  huanxi
//
//  Created by rslz on 2025/1/20.
//

import UIKit
import RxRelay

class HemeRecommendCell: BaseTableViewCell {
    
    enum CellType: Equatable {
        case skeleton
        case userItem(UserInfoModel)
        case empty
        case error
        
        static func == (lhs: CellType, rhs: CellType) -> Bool {
            switch (lhs, rhs) {
            case (.skeleton, .skeleton), (.empty, .empty), (.error, .error):
                return true
            case let (.userItem(leftItem), .userItem(rightItem)):
                return leftItem == rightItem
            default:
                return false
            }
        }
    }
    
    var didSelectItemBlock: ((UserInfoModel?) -> Void)?
    var hiddenBlock: (() -> Void)?

    let users = BehaviorRelay<[CellType]>(value:  Array(repeating: .skeleton, count: 5))

    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 0
        layout.itemSize = CGSize.init(width: 210, height: 275)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .init(hexString: "#121212")
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
//        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(HemeRecommendItemCell.self)
        collectionView.register(SpaceCollectionViewCell.self)
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
        bindUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setupUI() {

        selectionStyle = .none
        backgroundColor = .init(hexString: "#121212")
        
        let titleLabel = UILabel()
        titleLabel.textColor = .white
        titleLabel.font = .systemFont(ofSize: 14)
        titleLabel.text = "为你推荐"
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.equalToSuperview().offset(15)
            make.height.equalTo(45)
        }
        contentView.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.height.greaterThanOrEqualTo(275)
        }
    }
    
    func bindUI() {
        // 绑定数据到 collectionView
        self.users
            .bind(to: collectionView.rx.items) { [weak self] collectionView, index, item in
                guard let `self` = self else {
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SpaceCollectionViewCell.defaultReuseIdentifier, for: IndexPath(row: index, section: 0)) as! SpaceCollectionViewCell
                    cell.backgroundColor = .clear
                    return cell
                }
                switch item {
                case .skeleton:
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HemeRecommendItemCell.defaultReuseIdentifier, for: IndexPath(row: index, section: 0)) as! HemeRecommendItemCell
                    cell.isSkeletonVisible = true
                    return cell
                case .userItem(let user):
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HemeRecommendItemCell.defaultReuseIdentifier, for: IndexPath(row: index, section: 0)) as! HemeRecommendItemCell
                    cell.model = user
                    cell.isSkeletonVisible = false
                    cell.onTap = { [weak self] in
                        guard let `self` = self else { return }
                        if !LoginManager.shared.isLogin() {
                            Task {
                                let loginResult = await LoginViewController.startLogin()
                                if loginResult {
                                }
                            }
                        } else {
                            self.fetchFollow(params: ["followingId" : user.userId ?? 0], indexPath: IndexPath(row: index, section: 0)) { success in
                            }
                        }
                    }
                    return cell
                default:
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SpaceCollectionViewCell.defaultReuseIdentifier, for: IndexPath(row: index, section: 0)) as! SpaceCollectionViewCell
                    cell.backgroundColor = .clear
                    return cell
                }
            }
            .disposed(by: disposeBag)

    
        collectionView.rx.itemSelected
            .withUnretained(self)
            .compactMap { owner, indexPath -> UserInfoModel? in
                guard case .userItem(let userModel) = owner.users.value[indexPath.row] else {
                    return nil
                }
                return userModel
            }
            .subscribe(onNext: { [weak self] userModel in
                guard let self = self else { return }
                DispatchQueue.main.async {
                    if let block = self.didSelectItemBlock {
                        block(userModel)
                    }
                }
            })
            .disposed(by: disposeBag)
    }
    
    var model: [UserInfoModel]? {
        didSet {
            let users: [CellType] = (model ?? []).map { CellType.userItem($0) }
            self.users.accept(users)
        }
    }
}

extension HemeRecommendCell {
    func fetchFollow(
        params: [String: Any], indexPath: IndexPath?, completion: @escaping (Bool) -> Void
    ) {
        NetworkManager.shared.postRequest(
            path: "follows/follow",
            parameters: params,
            responseType: String.self
        ) { [weak self] success, message, data in
            if success {
                guard let `self` = self else { return }
                DispatchQueue.main.async {
                 guard let indexPath = indexPath else { return }
                    var currentData = self.users.value
                    currentData.remove(at: indexPath.row)
                    self.users.accept(currentData)
                    if currentData.isEmpty {
                        if let block = self.hiddenBlock {
                            block()
                        }
                    }
                }
            } else {
                HUDHelper.showToast(message)
            }
            completion(success)
        }
    }
}


/*代码功能:

定义了一个展示用户推荐列表的表格视图单元格 HemeRecommendCell，继承自 BaseTableViewCell。
它包含标题栏 (titleLabel) 和一个水平滚动的 collectionView，用于展示推荐用户信息。
支持骨架屏动画 (isSkeletonVisible)，在数据加载过程中显示占位效果。
当用户点击推荐用户头像时，会判断用户是否登录，并根据登录状态执行不同的操作。
使用 RxSwift 框架处理数据绑定和用户点击事件。
代码结构:

属性:

didSelectItemBlock: 一个闭包，用于处理用户点击推荐用户头像的事件。
hiddenBlock: 一个闭包，用于在推荐列表为空时隐藏该单元格。
users: 一个 BehaviorRelay，用于存储单元格类型（CellType），包括 skeleton（加载骨架屏）、userItem（用户数据）、empty（空数据）、error（错误状态）。
collectionView: 一个 UICollectionView，用于水平展示推荐用户列表。
方法:

init(style:reuseIdentifier:): 初始化方法，设置子视图的布局。
required init?(coder:): 编码器初始化方法，目前不支持。
setupUI(): 设置子视图的样式和布局。
bindUI(): 绑定数据到 collectionView，处理用户点击事件。
model: 属性的观察者，当 model 值变化时，更新推荐用户列表。
fetchFollow(params:indexPath:completion:): 网络请求方法，用于关注/取消关注推荐用户。
HemeRecommendCell 拓展: 实现网络请求关注/取消关注推荐用户的功能。

代码逻辑:

初始化: 在 init(style:reuseIdentifier:) 方法中，设置单元格的样式、添加子视图 (titleLabel 和 collectionView)，并通过 SnapKit 进行布局。
数据绑定: 在 bindUI() 方法中，使用 BehaviorRelay 和 rx.items 绑定数据到 collectionView。
根据不同的 CellType 创建相应的单元格。
处理用户点击事件，判断用户是否登录。
如果未登录，则弹出登录提示框。
如果已登录，则调用 fetchFollow 方法关注/取消关注推荐用户。
关注/取消关注: fetchFollow 方法用于发送网络请求，关注/取消关注推荐用户。
根据请求结果更新 users 数据，并可能触发 hiddenBlock 闭包隐藏单元格。
总体而言

 这段代码实现了一个可用于展示用户推荐列表的表格视图单元格。它使用了 RxSwift 框架提高了代码的可读性和可维护性，并考虑了用户登录状态和网络请求等因素。*/
