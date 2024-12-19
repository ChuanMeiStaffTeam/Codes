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
    
    let dataSource = BehaviorRelay<[UserInfoModel]>(value: [])
    
    var onItemTap: ((UserInfoModel)->Void)?

    // 创建 UICollectionView 实例，并且引用 layout 对象
    private lazy var tableView: UITableView = {
        let view = UITableView.init(frame: CGRect.zero, style: UITableView.Style.plain)
        view.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
        view.backgroundColor = .clear
        view.separatorColor = .clear
        view.register(SearchSugUserCell.self, forCellReuseIdentifier: SearchSugUserCell.defaultReuseIdentifier)
        return view
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
        addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func bindUI() {
        dataSource
            .bind(to: tableView.rx.items(cellIdentifier: SearchSugUserCell.defaultReuseIdentifier, cellType: SearchSugUserCell.self)) { row, element, cell in
                cell.user = element
            }
            .disposed(by: disposeBag)
        
        tableView.rx.modelSelected(UserInfoModel.self)
            .subscribe(onNext: { [weak self] value in
                guard let `self` = self else { return }
                if let block = self.onItemTap {
                      block(value)
                }
            })
            .disposed(by: disposeBag)
    }
    
    var items: [UserInfoModel]? {
        didSet {
            dataSource.accept(items ?? [])
            tableView.reloadData()
        }
    }
}
