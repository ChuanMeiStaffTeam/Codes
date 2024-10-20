//
//  MainView.swift
//  huanxi
//
//  Created by jack on 2024/2/28.
//

import Foundation
import UIKit
import SnapKit

protocol MainViewDelegate: AnyObject {
    func didClickMore(_ data: PostModel)
    
    func didClickLike(_ data: PostModel)
    
    func didClickComment(_ data: PostModel)
    
    func didClickShare(_ data: PostModel)
    
    func didClickMark(_ data: PostModel)
}

class MainView: UIView {
    
    let userCell = "userCell"
    let contentCell = "contentCell"
    let recommendCell = "recommendCell"

    
    var mainList: [MainModel] = []
    var data: PostsResponse?
    var delegate: MainViewDelegate?
    
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
    
    func reloadMainViewData(_ data: PostsResponse) {
        self.data = data
        tableView.reloadData()
    }
    
    lazy var tableView: UITableView = {
        let view = UITableView.init(frame: CGRect.zero, style: UITableView.Style.plain)
        view.backgroundColor = .clear
        view.delegate = self
        view.dataSource = self
        view.register(MainUserCell.self, forCellReuseIdentifier: userCell)
        view.register(MainContentCell.self, forCellReuseIdentifier: contentCell)
        view.register(MainRecommendCell.self, forCellReuseIdentifier: recommendCell)
        return view
    }()
    
}


extension MainView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var count = self.data?.list?.count ?? 0
        if self.data?.users?.count ?? 0 > 0 {
            count += 1
        }
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
//        let model = mainList[indexPath.row]
//        if model.type == "user" {
//            let cell = MainUserCell.init(style: .default, reuseIdentifier: userCell)
//            return cell
//        } else if model.type == "content" {
//            let cell = MainContentCell.init(style: .default, reuseIdentifier: contentCell)
//            cell.reloadData(indexPath: indexPath)
//            return cell
//        } else if model.type == "recommend" {
//            let cell = MainRecommendCell.init(style: .default, reuseIdentifier: recommendCell)
//            return cell
//        }
//
//        return UITableViewCell()
        
        if self.data?.users?.count ?? 0 > 0 {
            if indexPath.row == 0 {
                let cell = MainUserCell.init(style: .default, reuseIdentifier: userCell)
                cell.reloadData(self.data?.users ?? [])
                return cell
            } else {
                let cell = MainContentCell.init(style: .default, reuseIdentifier: contentCell)
                if let post = self.data?.list?[indexPath.row-1] {
                    cell.reloadData(data: post)
                    cell.delegate = self
                }
                return cell
            }
        } else {
            let cell = MainContentCell.init(style: .default, reuseIdentifier: contentCell)
            if let post = self.data?.list?[indexPath.row] {
                cell.reloadData(data: post)
                cell.delegate = self
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if self.data?.users?.count ?? 0 > 0 {
            if indexPath.row == 0 {
                return 100
            } else {
                return 585
            }
        } else {
            return 585
        }
    }
    
}

extension MainView: MainContentCellDelegate {
    func didClickMore(_ data: PostModel) {
        if let delegate = self.delegate {
            delegate.didClickMore(data)
        }
    }
    
    func didClickLike(_ data: PostModel) {
        if let delegate = self.delegate {
            delegate.didClickLike(data)
        }
    }
    
    func didClickComment(_ data: PostModel) {
        if let delegate = self.delegate {
            delegate.didClickComment(data)
        }
    }
    
    func didClickShare(_ data: PostModel) {
        if let delegate = self.delegate {
            delegate.didClickShare(data)
        }
    }
    
    func didClickMark(_ data: PostModel) {
        if let delegate = self.delegate {
            delegate.didClickMark(data)
        }
    }
}
