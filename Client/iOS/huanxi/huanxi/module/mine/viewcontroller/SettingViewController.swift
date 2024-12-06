//
//  SettingViewController.swift
//  huanxi
//
//  Created by jack on 2024/7/22.
//

import UIKit

class SettingViewController: BaseViewController {
    
    var dataList: [String] = []

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
        
        dataList = ["账号管理", "广告接入", "语言", "用户协议", "隐私政策", "账户注销"]

        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.top.bottom.left.right.equalToSuperview().offset(0)
        }
    }
    
    @objc func logout() {
        
        let alert = UIAlertController(title: "提示", message: "您确定要退出登录吗？", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "确定", style: .default) { _ in
            LoginManager.requestLogout { success in
            }
        }
        let cancelAction = UIAlertAction(title: "取消", style: .cancel) { _ in
            
        }
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        present(alert, animated: true)
    }
    
    @objc func logoff() {
        let alert = UIAlertController(title: "提示", message: "账号注销后，您的信息将被清空且无法找回，您确定要注销账户吗？", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "确定", style: .default) { _ in
            LoginManager.requestAccountDelete { success in
            }
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
        view.separatorStyle = .none
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
        cell.titleLabel.text = title
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 64
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let bgView: UIView = UIView()
        bgView.frame = CGRect.init(x: 0, y: 0, width: .screenWidth, height: 60)

        let btn = UIButton.init(type: .custom)
//        btn.backgroundColor = UIColor.black_forground
        btn.frame = CGRect.init(x: 0, y: 20, width: .screenWidth, height: 40)
        btn.setTitle("退出登录", for: .normal)
        btn.setTitleColor(.red, for: .normal)
        btn.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        btn.addTarget(self, action: #selector(logout), for: .touchUpInside)
        bgView.addSubview(btn)
        return bgView
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            let vc = BindPhoneViewController()
            self.navigationController?.pushViewController(vc, animated: true)
        case 1:
            let vc = CompanyViewController()
            self.navigationController?.pushViewController(vc, animated: true)
        case 2:
            let vc = LanguageViewController()
            self.navigationController?.pushViewController(vc, animated: true)
        case 3,4:
            let docxName = indexPath.row == 3 ? "欢喜用户协议" : "欢喜隐私协议"
            let filePath = Bundle.main.path(forResource: docxName, ofType: "docx") ?? ""
            DocumentPreviewer.shared.show(from: self, filePaths: [filePath]) {
                print("文件预览完成")
            }
        case 5:
            logoff()
        default:
            break
        }

        
    }
    
}



class SettingItemCell: UITableViewCell {
    
    let bgView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 16, weight: .regular)
        return label
    }()
    
    let arrow: UIImageView = {
        let arrow = UIImageView()
        arrow.image = UIImage.init(named: "publish_arrow")
        return arrow
    }()
    

    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        self.backgroundColor = .clear
        self.contentView.backgroundColor = .clear
        
        contentView.addSubview(bgView)
        bgView.snp.makeConstraints { make in
            make.edges.equalTo(UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
        }
        
        bgView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(16)
        }
        
        bgView.addSubview(arrow)
        arrow.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-16)
            make.width.height.equalTo(12)
        }
        
        let line = UIView()
        line.backgroundColor = UIColor.init(hexString: "#666666")
        bgView.addSubview(line)
        line.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.bottom.equalToSuperview().offset(0)
            make.right.equalToSuperview().offset(0)
            make.height.equalTo(0.5)
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
