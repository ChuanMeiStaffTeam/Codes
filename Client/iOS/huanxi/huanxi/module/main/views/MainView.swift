//
//  MainView.swift
//  huanxi
//
//  Created by jack on 2024/2/28.
//

import Foundation
import UIKit
import SnapKit

class MainView: UIView {
    
    private let viewModel = MainViewModel()
    var mainList: [MainModel] = []
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        self.clipsToBounds = true
        addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(0)
        }
    }
    
    func reloadMainViewData(_ list: [MainModel]) {
        mainList = list
        tableView.reloadData()
    }
    
    lazy var tableView: UITableView = {
        let view = UITableView.init(frame: CGRect.zero, style: UITableView.Style.plain)
        view.backgroundColor = .clear
        view.separatorColor = .clear
        view.delegate = self
        view.dataSource = self
        view.register(MainUserCell.self, forCellReuseIdentifier: "userCell")
        view.register(MainContentCell.self, forCellReuseIdentifier: "contentCell")
        view.register(MainRecommendCell.self, forCellReuseIdentifier: "recommendCell")
        return view
    }()
    
}


extension MainView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mainList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let model = mainList[indexPath.row]
        if model.type == "user" {
            let cell = MainUserCell.init(style: .default, reuseIdentifier: MainUserCell.identifier)
            return cell
        } else if model.type == "content" {
            let cell = MainContentCell.init(style: .default, reuseIdentifier: MainContentCell.identifier)
            cell.delegate = self
            let post = self.viewModel.postsList[indexPath.row]
            cell.model = post
            return cell
        } else if model.type == "recommend" {
            let cell = MainRecommendCell.init(style: .default, reuseIdentifier: MainRecommendCell.identifier)
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

extension MainView: MainContentCellDelegate {
    func didClickMore(_ data: PostModel) {

    }
    
    func didClickLike(_ data: PostModel, indexPath: IndexPath?) {
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
