//
//  SearchSugPopView.swift
//  huanxi
//
//  Created by rslz on 2024/12/19.
//

import Foundation
import UIKit
import RxRelay

class SearchSugPopView: BaseView {
    
    let dataSource = BehaviorRelay<[SearchViewModel.CellType]>(value: [])
    
    var onItemTap: ((UserInfoModel)->Void)?

    // 创建 UICollectionView 实例，并且引用 layout 对象
    private let popTableView: UITableView = {
        let view = UITableView.init(frame: CGRect.zero, style: UITableView.Style.plain)
        view.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
        view.backgroundColor = .clear
        view.separatorColor = .clear
        view.register(SearchSugUserCell.self, forCellReuseIdentifier: SearchSugUserCell.defaultReuseIdentifier)
        return view
    }()
    
    private lazy var emptyView: CCEmptyView = {
        let emptyView = CCEmptyView()
        return emptyView
    }()
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        bindUI()
    }
    
    
    func setupView() {
        backgroundColor = .black
        addSubview(popTableView)
        popTableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func bindUI() {
        
        dataSource
            .bind(to: popTableView.rx.items) { tableView, index, item in
                switch item {
                case .skeleton:
                    let cell = tableView.dequeueReusableCell(withIdentifier: SearchSugUserCell.defaultReuseIdentifier, for: IndexPath(row: index, section: 0)) as! SearchSugUserCell
                    cell.isSkeletonVisible = true
                    return cell
                case .userItem(let userModel):
                    let cell = tableView.dequeueReusableCell(withIdentifier: SearchSugUserCell.defaultReuseIdentifier, for: IndexPath(row: index, section: 0)) as! SearchSugUserCell
                    cell.user = userModel
                    cell.isSkeletonVisible = false
                    return cell
                default:
                    let cell = UITableViewCell()
                    cell.backgroundColor = .clear
                    return cell
                }
            }
            .disposed(by: disposeBag)
        
        dataSource
            .subscribe(onNext: { [weak self] cellTypes in
                guard let `self` = self else { return }
                if cellTypes.isEmpty {
                    self.setEmptyOrNetErrorView(.noData)
                } else {
                    self.emptyView.removeFromSuperview()
                }
            })
            .disposed(by: disposeBag)
        
        popTableView.rx.itemSelected
            .withUnretained(self)
            .compactMap { owner, indexPath -> UserInfoModel? in
                guard case .userItem(let userModel) = owner.dataSource.value[indexPath.row] else {
                    return nil
                }
                return userModel
            }
            .subscribe(onNext: { [weak self] userModel in
                self?.onItemTap?(userModel)
            })
            .disposed(by: disposeBag)
        
    }
    
    var items: [SearchViewModel.CellType]? {
        didSet {
            dataSource.accept(items ?? [])
        }
    }
    
    // MARK: - 设置空视图or错误视图
    private func setEmptyOrNetErrorView(_ type: CCEmptyType) {
        emptyView.removeFromSuperview()
        addSubview(emptyView)
        emptyView.snp.makeConstraints { make in
            make.centerY.equalToSuperview().offset(-80)
            make.centerX.equalToSuperview()
        }
        emptyView.updateType(type: type)
    }
}
