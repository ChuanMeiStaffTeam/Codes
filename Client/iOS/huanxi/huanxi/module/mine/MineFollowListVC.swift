//
//  MineFollowListVC.swift
//  huanxi
//
//  Created by rslz on 2025/1/20.
//

import UIKit
import SnapKit
import JXSegmentedView

class MineFollowListVC: BaseViewController {
        
    var listType: FollowListType = .follow

    var userId: Int = 0

    private let popTableView: UITableView = {
        let view = UITableView.init(frame: CGRect.zero, style: UITableView.Style.plain)
        view.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
        view.backgroundColor = .clear
        view.separatorColor = .clear
        view.register(SearchUserCell.self, forCellReuseIdentifier: SearchUserCell.defaultReuseIdentifier)
        return view
    }()
    
    private let emptyView: CCEmptyView = {
        let emptyView = CCEmptyView()
        return emptyView
    }()
    
    private let viewModel = MineViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        sh_prefersNavigationBarHidden = true
        setupUI()
        bindUI()
        self.loadData(listType: listType)
    }
    
    func setupUI() {
        view.addSubview(popTableView)
        popTableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func bindUI() {
        self.viewModel.followList
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
        
        self.viewModel.followList
            .skip(1)
            .subscribe(onNext: { [weak self] cellTypes in
                guard let `self` = self else { return }
                DispatchQueue.main.async {
                    if cellTypes.isEmpty {
                        self.setEmptyOrNetErrorView(.noData)
                    } else {
                        self.emptyView.removeFromSuperview()
                    }
                }
            })
            .disposed(by: disposeBag)
        
        popTableView.rx.itemSelected
            .withUnretained(self)
            .compactMap { owner, indexPath -> UserInfoModel? in
                guard case .userItem(let userModel) = owner.viewModel.followList.value[indexPath.row] else {
                    return nil
                }
                return userModel
            }
            .subscribe(onNext: { [weak self] userModel in
                guard let self = self else { return }
                DispatchQueue.main.async {
                    self.openUserPage(userModel)
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

extension MineFollowListVC {
    private func loadData(listType: FollowListType) {
        Task {
            _ = listType == .follow ? await viewModel.fetchFollowsList(userId) : await viewModel.fetchFanslist(userId)
        }
    }
}

extension MineFollowListVC: JXSegmentedListContainerViewListDelegate {
    func listView() -> UIView {
        return view
    }
}

extension MineFollowListVC {
    func openUserPage(_ model: UserInfoModel?) {
        let user = LoginManager.shared.getUserInfo()
        if user?.userId != model?.userId {
            let vc = OtherMineVC()
            vc.userId = model?.userId ?? 0
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        } else {
            let vc = MineViewController()
            vc.userId = model?.userId ?? 0
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}

/*代码功能：

这段代码主要实现了一个用户关注列表和粉丝列表的切换功能。它是一个视图控制器，用于展示当前用户所关注的用户和关注当前用户的用户。

代码结构：

FollowListType 枚举: 定义了两种列表类型：关注和粉丝。
MineFollowContainerVC 类:
负责管理关注和粉丝列表的切换。
使用 JXSegmentedView 实现顶部分段控件。
使用 JXSegmentedListContainerView 管理不同列表对应的子控制器。
通过 MineFollowListVC 子控制器来展示具体的关注或粉丝列表。
segmentedView: 分段控件，用于在关注和粉丝列表之间切换。
listContainerView: 容器视图，用于承载不同的列表视图控制器。
MineFollowListVC: 子控制器，负责展示具体的关注或粉丝列表。
代码逻辑:

创建 MineFollowContainerVC 实例: 初始化时设置当前用户和初始列表类型。
设置 UI: 创建分段控件、容器视图，并设置约束。
绑定数据: 将分段控件的数据源设置为 titleDataSource，将容器视图的数据源设置为 self。
切换列表: 用户点击分段控件时，会触发 JXSegmentedListContainerView 的代理方法，从而切换到对应的列表视图控制器。
子控制器: MineFollowListVC 负责展示具体的关注或粉丝列表，它会根据 listType 从服务器获取数据并展示。
代码亮点:

使用 JXSegmentedView: 简化了分段控件的实现。
使用 JXSegmentedListContainerView: 方便管理多个列表视图控制器。
代码结构清晰: 代码结构清晰，职责分明。
支持自定义: 可以通过自定义 JXSegmentedView 的样式来实现不同的 UI 效果。
潜在改进:

数据缓存: 可以缓存用户关注和粉丝列表的数据，减少网络请求。
下拉刷新: 可以添加下拉刷新功能，实现列表数据的实时更新。
分页加载: 对于大量数据，可以采用分页加载的方式，提高性能。
错误处理: 可以添加错误处理机制，例如网络请求失败时的提示。
*/
