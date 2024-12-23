//
//  SearchResultUserListVC.swift
//  huanxi
//
//  Created by rslz on 2024/12/23.
//

import UIKit
import SnapKit
import JXSegmentedView
import RxRelay

class SearchResultUserListVC: BaseViewController {
    
    var keyword: String = ""

    private let popTableView: UITableView = {
        let view = UITableView.init(frame: CGRect.zero, style: UITableView.Style.plain)
        view.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
        view.backgroundColor = .clear
        view.separatorColor = .clear
        view.register(SearchUserCell.self, forCellReuseIdentifier: SearchUserCell.defaultReuseIdentifier)
        return view
    }()
    
    private lazy var emptyView: CCEmptyView = {
        let emptyView = CCEmptyView()
        return emptyView
    }()
    
    private let viewModel = SearchResultViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        sh_prefersNavigationBarHidden = true
        setupUI()
        bindUI()
        self.loadData(keyword: keyword)
    }
    
    func setupUI() {
        view.addSubview(popTableView)
        popTableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func bindUI() {
        self.viewModel.searchUesrs
            .bind(to: popTableView.rx.items) { tableView, index, item in
                switch item {
                case .skeleton:
                    let cell = tableView.dequeueReusableCell(withIdentifier: SearchUserCell.defaultReuseIdentifier, for: IndexPath(row: index, section: 0)) as! SearchUserCell
                    cell.isSkeletonVisible = true
                    return cell
                case .userItem(let userModel):
                    let cell = tableView.dequeueReusableCell(withIdentifier: SearchUserCell.defaultReuseIdentifier, for: IndexPath(row: index, section: 0)) as! SearchUserCell
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
        
        self.viewModel.searchUesrs
            .skip(1)
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
                guard case .userItem(let userModel) = owner.viewModel.searchUesrs.value[indexPath.row] else {
                    return nil
                }
                return userModel
            }
            .subscribe(onNext: { [weak self] userModel in
                guard let self = self else { return }
                DispatchQueue.main.async {
                    let vc = UserBriefVC()
                    vc.user = userModel
                    vc.hidesBottomBarWhenPushed = true
                    self.navigationController?.pushViewController(vc, animated: true)
                }
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
    }
}

extension SearchResultUserListVC {
    private func loadData(keyword: String) {
        viewModel.requestSearchUser(keyword: keyword, completion: {success in })
    }
}

extension SearchResultUserListVC: JXSegmentedListContainerViewListDelegate {
    func listView() -> UIView {
        return view
    }
}
