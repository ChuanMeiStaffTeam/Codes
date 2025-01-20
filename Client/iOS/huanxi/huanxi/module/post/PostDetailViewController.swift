//
//  PostDetailViewController.swift
//  huanxi
//
//  Created by rslz on 2025/1/21.
//

import UIKit
import SwiftUI
import Combine
import MJRefresh

class PostDetailViewController: BaseViewController {
        
    private let viewModel = PostDetailViewModel()

    lazy var tableView: UITableView = {
        let view = UITableView.init(frame: CGRect.zero, style: UITableView.Style.plain)
        view.backgroundColor = .clear
        view.separatorColor = .clear
        view.register(HomeUserCell.self, forCellReuseIdentifier: HomeUserCell.defaultReuseIdentifier)
        view.register(MainContentCell.self, forCellReuseIdentifier: MainContentCell.defaultReuseIdentifier)
        view.register(HemeRecommendCell.self, forCellReuseIdentifier: HemeRecommendCell.defaultReuseIdentifier)
        return view
    }()

    private lazy var emptyView: CCEmptyView = {
        let emptyView = CCEmptyView()
        return emptyView
    }()
        
    var postItem: PostModel? {
        didSet {
            guard let model = postItem else { return }
            self.viewModel.dataList.accept([PostDetailViewModel.CellType.postItem(model)])
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        bindUI()
    }
    
    func setupView() {
        setupNavView()
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func setupNavView() {
        
        self.navigationItem.title = "帖子"
        
        // 隐藏导航栏底部的分割线
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.shadowImage = UIImage() // 隐藏分割线
        appearance.shadowColor = nil       // 确保无颜色
        appearance.backgroundColor = UIColor.black // 可选，设置导航栏背景颜色

        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
    }
    
    func bindUI() {
        
        tableView.rx.setDelegate(self).disposed(by: disposeBag)

        self.viewModel.dataList
            .bind(to: tableView.rx.items) { tableView, index, item in
                switch item {
                case .skeleton:
                    let cell = tableView.dequeueReusableCell(withIdentifier: MainContentCell.defaultReuseIdentifier, for: IndexPath(row: index, section: 0)) as! MainContentCell
                    cell.isSkeletonVisible = true
                    return cell
                case .postItem(let post):
                    let cell = tableView.dequeueReusableCell(withIdentifier: MainContentCell.defaultReuseIdentifier, for: IndexPath(row: index, section: 0)) as! MainContentCell
                    cell.isSkeletonVisible = false
                    cell.delegate = self
                    cell.model = post
                    cell.indexPath = IndexPath(row: index, section: 0)
                    return cell
                case .userItem(let users):
                    let cell = tableView.dequeueReusableCell(withIdentifier: HomeUserCell.defaultReuseIdentifier, for: IndexPath(row: index, section: 0)) as! HomeUserCell
                    cell.model = users
                    cell.didSelectItemBlock = { [weak self] user in
                        guard let `self` = self else { return }
                        self.openUserPage(user)
                    }
                    return cell
                case .recommend(let model):
                    let cell = tableView.dequeueReusableCell(withIdentifier: HemeRecommendCell.defaultReuseIdentifier, for: IndexPath(row: index, section: 0)) as! HemeRecommendCell
                    cell.model = model.users
                    cell.didSelectItemBlock = { [weak self] user in
                        guard let `self` = self else { return }
                        self.openUserPage(user)
                    }
                    cell.hiddenBlock = { [weak self] in
                        guard let `self` = self else { return }
                        self.viewModel.hiddenFollow(indexPath: IndexPath(row: index, section: 0))
                    }
                    return cell
                default:
                    let cell = UITableViewCell()
                    cell.backgroundColor = .clear
                    return cell
                }
            }
            .disposed(by: disposeBag)
        
        self.viewModel.dataList
            .subscribe(onNext: { [weak self] cellTypes in
                guard let `self` = self else { return }
                DispatchQueue.main.async {
                    if cellTypes.isEmpty {
                        self.setEmptyOrNetErrorView(.noData)
                    } else if cellTypes.first == .error {
                        self.setEmptyOrNetErrorView(.noNetwork)
                    } else {
                        self.emptyView.removeFromSuperview()
                    }
                }
            })
            .disposed(by: disposeBag)
        
        tableView.rx.itemSelected
            .withUnretained(self)
            .subscribe(onNext: { cellType in
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

extension PostDetailViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let item = self.viewModel.dataList.value.ck_objIndex(indexPath.item) else {
            return 0
        }
        switch item {
        case .skeleton:
            return 620
        case .postItem(let post):
            let contentH = post.caption?.height(withConstrainedWidth: UIDevice.screenWidth - 20, font: .systemFont(ofSize: 14)) ?? 16
            return 570 + (contentH > 50 ? 50 : contentH)
        case .userItem(_):
            return 120
        case .recommend:
            return 330
        default:
            return 0
        }
    }
}


extension PostDetailViewController: MainContentCellDelegate {
    func didClickMore(_ data: PostModel, indexPath: IndexPath?) {
        let postMorePopView = PostMorePopView()
        postMorePopView.show(data)
        postMorePopView.trashButton.rx.tapThrottle().subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            postMorePopView.close()
            self.viewModel.requestDeletePost(params: ["postId" : data.postId ?? 0], indexPath: indexPath) { success in}
        }).disposed(by: disposeBag)
        postMorePopView.briefcaseButton.rx.tapThrottle().subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            self.openUserPage(data.user)
            postMorePopView.close()
        }).disposed(by: disposeBag)
    }
    
    func didClickLike(_ data: PostModel, indexPath: IndexPath?) {
        if !LoginManager.shared.isLogin() {
            Task {
                let loginResult = await LoginViewController.startLogin()
                if loginResult {
                    self.viewModel.fetchLikeAction(data, indexPath: indexPath)
                }
            }
        } else {
            self.viewModel.fetchLikeAction(data, indexPath: indexPath)
        }
    }
    
    func didClickMark(_ data: PostModel, indexPath: IndexPath?, markComplete: ((Bool) -> Void)?) {
        if !LoginManager.shared.isLogin() {
            Task {
                let loginResult = await LoginViewController.startLogin()
                if loginResult {
                    self.viewModel.fetchCollectAction(data, indexPath: indexPath) { favorite in
                        markComplete?(favorite)
                    }
                }
            }
        } else {
            self.viewModel.fetchCollectAction(data, indexPath: indexPath) { favorite in
                markComplete?(favorite)
            }
        }
    }
    
    func didClickComment(_ data: PostModel) {
     
    }
    
    func didClickShare(_ data: PostModel) {
  
    }
    

}



extension PostDetailViewController {
    func openUserPage(_ model: UserInfoModel?) {
        let vc = MineViewController()
        let user = LoginManager.shared.getUserInfo()
        vc.type = user?.userId == model?.userId ? .mySelf : MineType.other
        vc.userId = model?.userId ?? 0
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}


