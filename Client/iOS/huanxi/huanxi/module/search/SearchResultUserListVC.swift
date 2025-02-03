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
                guard case .userItem(let userModel) = owner.viewModel.searchUesrs.value[indexPath.row] else {
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

extension SearchResultUserListVC {
    func openUserPage(_ model: UserInfoModel?) {
        let vc = MineViewController()
        let user = LoginManager.shared.getUserInfo()
        vc.type = user?.userId == model?.userId ? .mySelf : MineType.other
        vc.userId = model?.userId ?? 0
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

/*代码主要功能：

这段代码实现了一个搜索结果的用户列表页面。当用户输入关键词进行搜索后，这个页面会展示搜索到的用户列表。

代码结构和主要部分：

SearchResultUserListVC 类：
属性：
keyword：存储用户输入的搜索关键词。
popTableView：用于展示搜索结果的表格视图。
emptyView：当没有搜索结果时，显示的空视图。
viewModel：负责数据请求和管理的视图模型。
方法：
viewDidLoad：初始化界面，绑定数据，发起网络请求。
setupUi：设置表格视图的约束。
bindUI：将 viewModel 中的数据绑定到 UITableView，并处理用户点击事件。
setEmptyOrNetErrorView：设置空视图或错误视图。
loadData：发起网络请求获取搜索结果。
数据绑定：
使用 RxSwift 进行数据绑定，将 viewModel 中的搜索结果数据实时更新到 UITableView 上。
当搜索结果为空时，显示空视图。
用户交互：
点击表格视图中的用户项，会跳转到该用户的详情页。
代码流程：

初始化： 在 viewDidLoad 方法中，设置界面，绑定数据，发起网络请求获取搜索结果。
数据展示： 将获取到的搜索结果数据绑定到 UITableView 上，并在表格视图中展示。
空状态处理： 如果搜索结果为空，则显示空视图。
用户交互： 用户点击表格视图中的某一项时，跳转到对应的用户详情页。
代码亮点：

使用 RxSwift 进行数据绑定： 使代码更简洁，提高了数据流的可读性。
采用 MVVM 设计模式： 将视图和数据逻辑分离，提高代码的可维护性。
处理空状态： 当没有搜索结果时，给用户友好的提示。
用户交互： 实现点击用户项跳转到详情页的功能。
可能存在的问题和改进点：

错误处理： 可以添加更多的错误处理，比如网络请求失败时的处理。
性能优化： 如果数据量较大，可以考虑使用分页加载，提高性能。
UI/UX： 可以根据设计稿对界面进行优化，提高用户体验。
测试： 可以编写单元测试，保证代码的正确性。
总结：

这段代码实现了一个功能完善的用户搜索列表页面，使用了较好的设计模式和框架。通过对代码的分析，我们可以更深入地了解其内部实现细节，并为后续的代码优化提供参考。
 */
