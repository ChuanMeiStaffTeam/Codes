//
//  HomeViewController.swift
//  huanxi
//
//  Created by jack on 2024/2/18.
//

import UIKit
import SwiftUI
import Combine
import MJRefresh

class HomeViewController: BaseViewController {
    
    private var cancellable: AnyCancellable?

    private let viewModel = HomeViewModel()

    lazy var tableView: UITableView = {
        let view = UITableView.init(frame: CGRect.zero, style: UITableView.Style.plain)
        view.backgroundColor = .clear
        view.separatorColor = .clear
        view.register(MainUserCell.self, forCellReuseIdentifier: MainUserCell.defaultReuseIdentifier)
        view.register(MainContentCell.self, forCellReuseIdentifier: MainContentCell.defaultReuseIdentifier)
        view.register(MainRecommendCell.self, forCellReuseIdentifier: MainRecommendCell.defaultReuseIdentifier)
        return view
    }()

    private lazy var emptyView: CCEmptyView = {
        let emptyView = CCEmptyView()
        return emptyView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        bindUI()
        refrehData()
        
        // 使用 Combine 订阅通知
        cancellable = NotificationCenter.default.publisher(for: .refreshMainPageNotification)
            .sink { notification in
                self.refrehData()
            }
    }
    
    deinit {
        // Combine 会自动取消订阅，但可以手动释放以确保安全
        cancellable?.cancel()
    }
    
    
    func setupView() {
        setupNavView()
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(0)
        }
        let header = MJRefreshNormalHeader { [weak self] in
            guard let self = self else { return }
            self.refrehData()
        }.autoChangeTransparency(true)
        .link(to: tableView)
        header.stateLabel?.isHidden = true
    }
    
    func setupNavView() {
        
        let view = UIView(frame: CGRect.init(x: 0, y: 0, width: 150, height: 40))
        view.backgroundColor = .clear
        
        let imageView = UIImageView(image: UIImage.init(named: "huanxi.jpg"))
        imageView.frame = CGRect(x: -10, y: 4, width: 72, height: 36)
        imageView.contentMode = .scaleAspectFit
        view.addSubview(imageView)
        let leftItem = UIBarButtonItem(customView: view)
        self.navigationItem.leftBarButtonItem = leftItem
        
        let button = UIButton(type: .custom)
        button.frame = CGRect(x: .screenWidth - 46, y: 7, width: 30, height: 30)
        button.setImage(UIImage.init(named: "main_relay"), for: .normal)
        button.addTarget(self, action: #selector(gotoDirect), for: .touchUpInside)
        let rightItem = UIBarButtonItem(customView: button)
        self.navigationItem.rightBarButtonItem = rightItem
        
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
                case .userItem(_):
                    let cell = tableView.dequeueReusableCell(withIdentifier: MainUserCell.defaultReuseIdentifier, for: IndexPath(row: index, section: 0)) as! MainUserCell
                    return cell
                case .recommend:
                    let cell = tableView.dequeueReusableCell(withIdentifier: MainRecommendCell.defaultReuseIdentifier, for: IndexPath(row: index, section: 0)) as! MainRecommendCell
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
                if cellTypes.isEmpty {
                    self.setEmptyOrNetErrorView(.noData)
                } else if cellTypes.first == .error {
                    self.setEmptyOrNetErrorView(.noNetwork)
                } else {
                    self.emptyView.removeFromSuperview()
                }
            })
            .disposed(by: disposeBag)
        
        tableView.rx.itemSelected
            .withUnretained(self)
            .subscribe(onNext: { cellType in
            })
            .disposed(by: disposeBag)
        
    }
    
    
    private func refrehData() {
        viewModel.requestHomePosts { [weak self] result in
            guard let self = self else { return }
            self.tableView.mj_header?.endRefreshing()
        }
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
        emptyView.reloadBlock = { [weak self] in
            guard let self = self else { return }
            self.refrehData()
        }
    }
    
    @objc func gotoDirect() {
        let vc = DirectViewController()
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}

extension HomeViewController: UITableViewDelegate {
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
            return 100
        case .recommend:
            return 330
        default:
            return 0
        }
    }
    
}


extension HomeViewController: MainContentCellDelegate {
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
            let vc = UserBriefVC()
            vc.user = data.user
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
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

