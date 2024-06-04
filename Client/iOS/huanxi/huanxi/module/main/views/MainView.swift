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
    
    let userCell = "userCell"
    let contentCell = "contentCell"
    let recommendCell = "recommendCell"

    
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
        return mainList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let model = mainList[indexPath.row]
        if model.type == "user" {
            let cell = MainUserCell.init(style: .default, reuseIdentifier: userCell)
            return cell
        } else if model.type == "content" {
            let cell = MainContentCell.init(style: .default, reuseIdentifier: contentCell)
            cell.reloadData(indexPath: indexPath)
            return cell
        } else if model.type == "recommend" {
            let cell = MainRecommendCell.init(style: .default, reuseIdentifier: recommendCell)
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
