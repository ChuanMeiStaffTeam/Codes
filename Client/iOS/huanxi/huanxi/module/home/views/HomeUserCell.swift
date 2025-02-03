//
//  HomeUserCell.swift
//  huanxi
//
//  Created by rslz on 2025/1/20.
//

import UIKit
import RxRelay

class HomeUserCell: BaseTableViewCell {
    
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

    let users = BehaviorRelay<[CellType]>(value:  Array(repeating: .skeleton, count: 5))

    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        layout.itemSize = CGSize.init(width: 100, height: 100)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor.clear
        collectionView.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(HomeUserItemCell.self)
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
        self.backgroundColor = .clear
        contentView.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func bindUI() {
        // 绑定数据到 collectionView
        self.users
            .bind(to: collectionView.rx.items) { collectionView, index, item in
                switch item {
                case .skeleton:
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeUserItemCell.defaultReuseIdentifier, for: IndexPath(row: index, section: 0)) as! HomeUserItemCell
                    cell.isSkeletonVisible = true
                    return cell
                case .userItem(let user):
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeUserItemCell.defaultReuseIdentifier, for: IndexPath(row: index, section: 0)) as! HomeUserItemCell
                    cell.model = user
                    cell.isSkeletonVisible = false
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


/*代码功能:

定义了一个展示用户信息的表格视图单元格: HomeUserCell 继承自 UITableViewCell，用于在表格视图中展示用户信息。
使用 RxSwift 框架:
借助 BehaviorRelay 和 rx.items 实现了数据绑定，将 users 数组中的数据动态地映射到 UICollectionView 上。
利用 RxSwift 的操作符处理用户点击事件，并安全地调用闭包。
代码结构:

属性:

model: 一个可选的 UserInfoModel 数组，用于存储用户信息。
didSelectItemBlock: 一个闭包，用于处理用户点击事件。
users: 一个 BehaviorRelay，用于存储单元格类型（CellType），包括 skeleton（加载骨架屏）、userItem（用户数据）、empty（空数据）、error（错误状态）。
collectionView: 一个 UICollectionView，用于水平展示用户列表。
方法:

init(style:reuseIdentifier:): 初始化方法，设置单元格的样式和添加子视图。
setupUI(): 设置子视图的布局。
bindUI(): 绑定数据到 collectionView，处理用户点击事件。
CellType 枚举: 定义了单元格的不同类型，方便处理不同状态下的数据。

代码逻辑:

初始化: 在 init(style:reuseIdentifier:) 方法中，设置单元格的样式，添加 collectionView 作为子视图，并调用 setupUI() 和 bindUI() 方法。
数据绑定: 在 bindUI() 方法中，使用 users 数组的 bind 方法将数据绑定到 collectionView，根据不同的 CellType 创建相应的单元格。
处理用户点击: 监听 collectionView 的点击事件，获取点击的用户信息，并通过闭包 didSelectItemBlock 将用户信息传递给外部。
更新数据: 当 model 属性的值发生变化时，更新 users 数组，触发 collectionView 的数据刷新。
代码亮点:

使用了 RxSwift 框架: 提高了代码的可读性和可维护性。
使用了枚举: 更好地表示单元格的不同状态。
使用了数据绑定: 将数据与 UI 进行了分离，提高了代码的可测试性和可维护性。
使用了骨架屏: 提高了用户体验，在数据加载过程中显示加载动画。
潜在改进:

优化数据加载: 可以考虑使用异步加载数据，避免阻塞主线程。
添加错误处理: 可以添加错误处理逻辑，例如网络请求失败时显示错误提示。
优化性能: 对于大量数据，可以考虑使用缓存机制来提高性能。
总结

 这段代码实现了一个功能较为完善的用户列表单元格，使用了 RxSwift 框架来提高代码的可读性和可维护性，并考虑了数据加载、用户交互等方面。它可以作为构建复杂用户列表的基础。*/
