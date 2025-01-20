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
        layout.itemSize = CGSize.init(width: 210, height: 275)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .init(hexString: "#121212")
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
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
            make.height.equalTo(42)
        }
        contentView.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom)
            make.leading.trailing.bottom.equalToSuperview()
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
                        self.fetchFollow(params: ["followingId" : user.userId ?? 0], indexPath: IndexPath(row: index, section: 0)) { success in
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
