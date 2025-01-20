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
