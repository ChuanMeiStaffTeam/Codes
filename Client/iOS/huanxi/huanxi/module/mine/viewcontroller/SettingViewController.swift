//
//  SettingViewController.swift
//  huanxi
//
//  Created by jack on 2024/7/22.
//

import UIKit

class SettingViewController: BaseViewController {
    
    let searchHeaderView = SearchHeaderView(frame: CGRect.init(x: 0, y: .topBarHeight, width: .screenWidth, height: 40))
    var dataList: [String] = []
    var iconList: [String] = []

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = false
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
    }
    
    func setupView() {
        title = "设置"
        
        dataList = ["更新消息功能", "关注和邀请好友", "你的活动", "通知", "隐私", "安全", "广告", "账户", "帮助", "关于"]
        iconList = ["set_message", "set_follow", "set_active", "set_noti", "set_sec", "set_safe", "set_ad", "set_account", "set_help", "set_about"]

        searchHeaderView.didClickViewCallBack = { [weak self] in
            
        }
        view.addSubview(searchHeaderView)
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.top.equalTo(searchHeaderView.snp.bottom).offset(0)
            make.bottom.left.right.equalToSuperview().offset(0)
        }
    }
    
    @objc func logout() {
        
        let alert = UIAlertController(title: "提示", message: "您确定要退出登录吗？", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "确定", style: .default) { _ in
            LoginManager.requestLogout()
        }
        let cancelAction = UIAlertAction(title: "取消", style: .cancel) { _ in
            
        }
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        present(alert, animated: true)
    }
    
    
    lazy var tableView: UITableView = {
        let view = UITableView.init(frame: CGRect.zero, style: UITableView.Style.plain)
        view.backgroundColor = .clear
        view.delegate = self
        view.dataSource = self
        view.register(SettingItemCell.self, forCellReuseIdentifier: "cell")
        return view
    }()
    
}



extension SettingViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = SettingItemCell.init(style: .default, reuseIdentifier: "cell")
        
        let title = dataList[indexPath.row]
        let icon = iconList[indexPath.row]
        cell.titleLabel.text = title
        cell.icon.image = UIImage.init(named: icon)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 64
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let btn = UIButton.init(type: .custom)
        btn.frame = CGRect.init(x: 0, y: 0, width: .screenWidth, height: 40)
        btn.setTitle("退出登录", for: .normal)
        btn.setTitleColor(.red, for: .normal)
        btn.titleLabel?.font = .systemFont(ofSize: 16, weight: .regular)
        btn.addTarget(self, action: #selector(logout), for: .touchUpInside)
        return btn
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 40
    }
    
}



class SettingItemCell: UITableViewCell {
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 14, weight: .regular)
        return label
    }()
    
    let icon: UIImageView = {
        let icon = UIImageView()
        icon.image = UIImage.init(named: "publish_camera")
        return icon
    }()
    
    private let arrow: UIImageView = {
        let arrow = UIImageView()
        arrow.image = UIImage.init(named: "publish_arrow")
        return arrow
    }()

    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.backgroundColor = .clear
        self.contentView.backgroundColor = .clear
        
        contentView.addSubview(titleLabel)
        contentView.addSubview(icon)
        contentView.addSubview(arrow)

        icon.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.centerY.equalToSuperview().offset(0)
            make.width.height.equalTo(20)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview().offset(0)
            make.left.equalTo(icon.snp.right).offset(12)
        }
        
        arrow.snp.makeConstraints { make in
            make.centerY.equalToSuperview().offset(0)
            make.right.equalToSuperview().offset(-16)
            make.width.height.equalTo(16)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
