//
//  AccountSecurityVC.swift
//  huanxi
//
//  Created by rslz on 2025/1/10.
//

import UIKit

class AccountSecurityVC: BaseViewController {
    
    private let dataList: [SetModel] = [
        SetModel(title: "手机号", subTitle: LoginManager.shared.getUserInfo()?.phoneNumber ?? ""),
        SetModel(title: "注销账号"),
    ]
        
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    func setupView() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.top.bottom.left.right.equalToSuperview().offset(0)
        }
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
        view.register(SettingItemCell.self)
        return view
    }()
    
}



extension AccountSecurityVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let model = dataList.ck_objIndex(indexPath.row) else { return UITableViewCell() }
        let cell: SettingItemCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
        cell.model = model
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 64
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            let vc = ChangePhoneVC()
            self.navigationController?.pushViewController(vc, animated: true)
        case 1:
            logoff()
        default:
            break
        }
    }
}





