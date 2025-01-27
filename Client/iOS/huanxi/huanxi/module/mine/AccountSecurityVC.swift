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


/*代码功能

显示一个列表，包含两项：
手机号，显示当前登录用户的手机号
注销账号
点击“手机号”可以跳转到修改手机号的界面 (ChangePhoneVC)
点击“注销账号”会弹出确认对话框，询问用户是否确定注销
如果用户确认注销，则调用 LoginManager.requestAccountDelete 方法注销账号
代码优缺点

优点：

功能清晰简洁，易于理解
注销账号前进行确认，防止误操作
代码使用了较少的强制解包 (ck_objIndex)
缺点：

没有对注销账号的结果进行处理，比如提示注销成功/失败
没有考虑网络错误等情况
改进建议

在 LoginManager.requestAccountDelete 的回调函数中处理注销的结果，并提示用户注销成功/失败
可以考虑在注销账号之前，增加额外的验证步骤，比如输入密码
总而言之，这段代码实现了基本的账户安全设置功能。通过改进，可以提供更完善的用户体验。*/
