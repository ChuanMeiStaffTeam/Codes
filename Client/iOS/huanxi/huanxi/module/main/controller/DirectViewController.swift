//
//  DirectViewController.swift
//  huanxi
//
//  Created by Jack on 2024/6/4.
//

import UIKit
import NIMSDK

class DirectViewController: BaseViewController {
    
    let searchView = UITextField()
    var chatList = Array<ChatModel>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        loadData()
        
        loginIM()
        
    }
    
    func loginIM() {
        NIMSDK.shared().loginManager.login("test01", token: "123456") { error in
            if error == nil {
                HUDHelper.showToast("云信IM登录成功")
            }
        }
    }
    
    
    func loadData() {
        
        let names = ["zixuanooo", "diza", "dnsk", "jack", "rose", "zixuanooo", "diza", "dnsk", "jack", "rose"]
        let icons = ["icon0", "icon1", "icon2", "icon3", "icon4", "icon5", "icon0", "icon1", "icon2", "icon3"]
        let contents = ["电话就是不丢吃不都吃不饿还问", "元旦快乐哈哈哈哈哈😄", "评论123哈说的话说的", "i为u你是看见当年参加考试", "建军节说的那就是承诺", "几句话素材你说你刺猬", "u你说的没时间", "OK从事记单词哦接送", "的产业化丢吃呢", "ID农村建设的奶茶"]
        
        for (index, name) in names.enumerated() {
            let model = ChatModel(name: name, icon: icons[index], content: contents[index])
            chatList.append(model)
        }
        tableView.reloadData()
    }
    
    func setupView() {
        
        setupNavView()
        
        searchView.frame = CGRect(x: 16, y: .navigationBarHeight, width: .screenWidth - 32, height: 36)
        searchView.placeholder = "搜索"
        searchView.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 36))
        searchView.leftViewMode = .always
        searchView.backgroundColor = .init(hexString: "#797979")
        searchView.layer.cornerRadius = 6
        searchView.layer.masksToBounds = true
        view.addSubview(searchView)
        
        view.addSubview(tableView)
        tableView.frame = CGRect(x: 0, y: searchView.bottom + 10, width: view.width, height: view.height - searchView.bottom)
        
    }
    
    
    func setupNavView() {
        self.title = "聊天"

        let button = UIButton(type: .custom)
        button.frame = CGRect(x: .screenWidth - 46, y: 7, width: 30, height: 30)
        button.setImage(UIImage.init(named: "direct_rightitem"), for: .normal)
        let rightItem = UIBarButtonItem(customView: button)
        self.navigationItem.rightBarButtonItem = rightItem
        
    }
    
    
    lazy var tableView: UITableView = {
        let view = UITableView.init(frame: CGRect.zero, style: UITableView.Style.plain)
        view.backgroundColor = .clear
        view.delegate = self
        view.dataSource = self
        view.register(DirectChatCell.self, forCellReuseIdentifier: "DirectChatCell")
        return view
    }()
}


extension DirectViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chatList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = DirectChatCell.init(style: .default, reuseIdentifier: "DirectChatCell")
        let model = chatList[indexPath.row]
        cell.reloadData(model)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 72
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = ChatViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}
