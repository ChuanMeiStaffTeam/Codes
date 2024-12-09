//
//  MainViewController.swift
//  huanxi
//
//  Created by jack on 2024/2/18.
//

import UIKit
import SwiftUI
import Combine
import MJRefresh

class MainViewController: BaseViewController {
    
    private var cancellable: AnyCancellable?

    private let viewModel = MainViewModel()

    lazy var tableView: UITableView = {
        let view = UITableView.init(frame: CGRect.zero, style: UITableView.Style.plain)
        view.backgroundColor = .clear
        view.separatorColor = .clear
        view.delegate = self
        view.dataSource = self
        view.register(MainUserCell.self, forCellReuseIdentifier: MainUserCell.identifier)
        view.register(MainContentCell.self, forCellReuseIdentifier: MainContentCell.identifier)
        view.register(MainRecommendCell.self, forCellReuseIdentifier: MainRecommendCell.identifier)
        return view
    }()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
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
//        header.lastUpdatedTimeLabel?.isHidden = true
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
    
    private func refrehData() {
        viewModel.requestHomePosts { [weak self] result in
            guard let self = self else { return }
            self.tableView.mj_header?.endRefreshing()
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    @objc func gotoDirect() {
        let vc = DirectViewController()
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.dataList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let model = self.viewModel.dataList[indexPath.row]
        if model is Array<Any> {
            let cell = tableView.dequeueReusableCell(withIdentifier: MainUserCell.identifier, for: indexPath) as! MainUserCell
            return cell
        } else if model is PostModel {
            let cell = tableView.dequeueReusableCell(withIdentifier: MainContentCell.identifier, for: indexPath) as! MainContentCell
            cell.delegate = self
            let post = self.viewModel.dataList[indexPath.row] as! PostModel
            cell.model = post
            cell.indexPath = indexPath
            return cell
        } else if model is MainModel {
            let cell = tableView.dequeueReusableCell(withIdentifier: MainRecommendCell.identifier, for: indexPath) as! MainRecommendCell
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let model = self.viewModel.dataList[indexPath.row]
        if model is Array<Any> {
            return 100
        } else if model is PostModel {
            let post = model as! PostModel
            let contentH = post.caption?.height(withConstrainedWidth: UIDevice.screenWidth - 20, font: .systemFont(ofSize: 14)) ?? 16
            return 570 + (contentH > 50 ? 50 : contentH)
        } else if model is MainModel {
            return 330
        }
        return 0
    }
    
}


extension MainViewController: MainContentCellDelegate {
    func didClickMore(_ data: PostModel) {

    }
    
    func didClickLike(_ data: PostModel, indexPath: IndexPath?) {
        
        if !LoginManager.shared.isLogin() {
            Task {
                let loginResult = await LoginViewController.startLogin()
                if loginResult {
                    if !data.liked {
                        viewModel.requestLikePost(params: ["postId" : data.postId ?? 0]) { [weak self] success in
                            guard let `self` = self else { return }
                            if success {
                                DispatchQueue.main.async {
                                    let index = indexPath?.row ?? 0
                                    var post = self.viewModel.dataList[index] as! PostModel
                                    post.liked = true
                                    post.likesCount = (post.likesCount ?? 0) + 1
                                    self.viewModel.dataList[index] = post
                                    let indexPath = IndexPath(row: index, section: 0)
                                    self.tableView.reloadRows(at: [indexPath], with: .none)
                                }
                            }
                        }
                    } else {
                        viewModel.requestCancelLikePost(params: ["postId" : data.postId ?? 0]) { [weak self] success in
                            guard let `self` = self else { return }
                            if success {
                                let index = indexPath?.row ?? 0
                                var post = self.viewModel.dataList[index] as! PostModel
                                post.liked = false
                                post.likesCount = (post.likesCount ?? 0) - 1
                                self.viewModel.dataList[index] = post
                                let indexPath = IndexPath(row: index, section: 0)
                                self.tableView.reloadRows(at: [indexPath], with: .none)
                            }
                        }
                    }
                }
            }
        } else {
            if !data.liked {
                viewModel.requestLikePost(params: ["postId" : data.postId ?? 0]) { [weak self] success in
                    guard let `self` = self else { return }
                    if success {
                        DispatchQueue.main.async {
                            let index = indexPath?.row ?? 0
                            var post = self.viewModel.dataList[index] as! PostModel
                            post.liked = true
                            post.likesCount = (post.likesCount ?? 0) + 1
                            self.viewModel.dataList[index] = post
                            let indexPath = IndexPath(row: index, section: 0)
                            self.tableView.reloadRows(at: [indexPath], with: .none)
                        }
                    }
                }
            } else {
                viewModel.requestCancelLikePost(params: ["postId" : data.postId ?? 0]) { [weak self] success in
                    guard let `self` = self else { return }
                    if success {
                        let index = indexPath?.row ?? 0
                        var post = self.viewModel.dataList[index] as! PostModel
                        post.liked = false
                        post.likesCount = (post.likesCount ?? 0) - 1
                        self.viewModel.dataList[index] = post
                        let indexPath = IndexPath(row: index, section: 0)
                        self.tableView.reloadRows(at: [indexPath], with: .none)
                    }
                }
            }
        }
    }
    
    func didClickComment(_ data: PostModel) {
     
    }
    
    func didClickShare(_ data: PostModel) {
  
    }
    
    func didClickMark(_ data: PostModel) {
   
    }
}
