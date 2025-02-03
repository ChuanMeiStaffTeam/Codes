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
        NIMSDK.shared().loginManager.login("test02", token: "123456") { error in
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


/*代码功能
 
 这段代码实现了一个聊天列表页面。主要功能包括：

 登录云信IM： 使用 NIMSDK 登录云信 IM 服务。
 加载聊天记录： 从本地模拟数据中加载聊天记录，并展示在 UITableView 中。
 搜索功能： 通过 searchView 实现简单的搜索功能（目前功能未实现）。
 聊天列表展示： 使用自定义的 DirectChatCell 来展示每一条聊天记录。
 跳转聊天页面： 点击聊天记录，跳转到聊天详情页面。
 代码结构

 DirectViewController 类：

 属性：
 searchView：搜索框。
 chatList：存储聊天记录的数组。
 方法：
 viewDidLoad：初始化视图，加载数据，登录云信 IM。
 loginIM：登录云信 IM。
 loadData：加载本地模拟聊天数据。
 setupView：设置视图的布局。
 setupNavView：设置导航栏。
 tableView：聊天列表的 UITableView。
 tableView(_:numberOfRowsInSection:)：返回聊天记录的数量。
 tableView(_:cellForRowAt:)：配置聊天列表的 cell。
 tableView(_:heightForRowAt:)：设置 cell 的高度。
 tableView(_:didSelectRowAt:)：处理点击聊天记录事件。
 DirectChatCell 类：

 自定义的 cell，用于展示一条聊天记录。
 reloadData(model) 方法用于根据数据模型更新 cell 的内容。
 代码流程

 加载视图： viewDidLoad 方法中，初始化视图，加载数据，登录云信 IM。
 显示聊天列表： loadData 方法从本地模拟数据中加载聊天记录，并更新 tableView。
 用户交互： 点击聊天记录，跳转到聊天详情页面。
 代码分析

 云信 IM 登录： 使用 NIMSDK 登录云信 IM，以便后续进行实时聊天等功能。
 数据加载： 目前使用本地模拟数据，实际应用中应该从服务器获取聊天记录。
 UITableView 配置： 使用 UITableView 展示聊天记录，自定义 cell 来展示聊天内容。
 搜索功能： 目前搜索功能还未实现，需要添加搜索逻辑和过滤数据。
 用户交互： 点击聊天记录时，跳转到聊天详情页面，需要实现聊天详情页面的逻辑。
 改进建议

 数据源： 将聊天数据从本地模拟数据改为从云端获取，可以使用云信 IM 提供的 API 获取聊天记录。
 搜索功能： 实现搜索功能，可以根据聊天内容、发送者等信息进行搜索。
 实时更新： 实现聊天消息的实时更新，可以使用云信 IM 提供的实时消息推送功能。
 消息发送： 实现发送消息的功能，将消息发送到云信 IM 服务器。
 错误处理： 添加错误处理机制，比如网络请求失败、登录失败等。
 界面优化： 可以对界面进行优化，比如添加更多交互效果、使用更美观的 UI。
 总结

 这段代码实现了聊天列表的基本功能，但还有很多可以改进的地方。通过完善数据源、添加搜索功能、实现实时更新等，可以打造一个功能更完善的聊天应用。

*/
