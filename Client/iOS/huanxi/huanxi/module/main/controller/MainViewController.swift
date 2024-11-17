//
//  MainViewController.swift
//  huanxi
//
//  Created by jack on 2024/2/18.
//

import UIKit
import SwiftUI

class MainViewController: BaseViewController {
    
    private let viewModel = MainViewModel()
    private var mainList: [MainModel] = []

    lazy var tableView: UITableView = {
        let view = UITableView.init(frame: CGRect.zero, style: UITableView.Style.plain)
        view.backgroundColor = .clear
        view.delegate = self
        view.dataSource = self
        view.register(MainUserCell.self, forCellReuseIdentifier: MainUserCell.identifier)
        view.register(MainContentCell.self, forCellReuseIdentifier: MainContentCell.identifier)
        view.register(MainRecommendCell.self, forCellReuseIdentifier: MainRecommendCell.identifier)
        return view
    }()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // dismiss手动加载的LaunchWindow
        LaunchManager.shared.dismissLaunchWindow()
        setupView()
        setupViewModel()
        LoginManager.requestUserInfo()
    }
    
    
    func setupView() {
        setupNavView()
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(0)
        }
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
        
    }
    
    private func setupViewModel() {
//        viewModel.requestHomePosts { [weak self] result in
//            guard let strongSelf = self else { return }
//            strongSelf.mainList = strongSelf.viewModel.mainList
//            DispatchQueue.main.async {
//                strongSelf.tableView.reloadData()
//            }
//        }
        self.mainList = self.viewModel.mainList
        DispatchQueue.main.async {
            self.tableView.reloadData()
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
        return mainList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let model = mainList[indexPath.row]
        if model.type == "user" {
            let cell = tableView.dequeueReusableCell(withIdentifier: MainUserCell.identifier, for: indexPath) as! MainUserCell
            return cell
        } else if model.type == "content" {
            let cell = tableView.dequeueReusableCell(withIdentifier: MainContentCell.identifier, for: indexPath) as! MainContentCell
            cell.delegate = self
            let post = self.viewModel.postsList[indexPath.row]
            cell.configure(post: post)
            return cell
        } else if model.type == "recommend" {
            let cell = tableView.dequeueReusableCell(withIdentifier: MainRecommendCell.identifier, for: indexPath) as! MainRecommendCell
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let model = mainList[indexPath.row]
        if model.type == "user" {
            return 100
        } else if model.type == "content" {
            return 585
        } else if model.type == "recommend" {
            return 330
        }
        return 0
    }
    
}


extension MainViewController: MainContentCellDelegate {
    func didClickMore(_ data: PostModel) {

    }
    
    func didClickLike(_ data: PostModel) {
        if let index = self.viewModel.postsList.firstIndex(where: { $0.postId == data.postId }) {
            var post = self.viewModel.postsList[index]
            post.liked = data.liked
            post.likesCount = data.liked ? (post.likesCount ?? 0) + 1 : (post.likesCount ?? 0) - 1
            self.viewModel.postsList[index] = post
            let indexPath = IndexPath(row: index, section: 0)
            tableView.reloadRows(at: [indexPath], with: .none)
        }
    }
    
    func didClickComment(_ data: PostModel) {
     
    }
    
    func didClickShare(_ data: PostModel) {
  
    }
    
    func didClickMark(_ data: PostModel) {
   
    }
}
