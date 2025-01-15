//
//  SettingViewController.swift
//  huanxi
//
//  Created by jack on 2024/7/22.
//

import UIKit

class SettingViewController: BaseViewController {
    
    private let dataList: [SetModel] = [
        SetModel(title: "账号与安全"),
        SetModel(title: "广告接入"),
        SetModel(title: "语言"),
        SetModel(title: "用户协议"),
        SetModel(title: "隐私政策"),
    ]

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    func setupView() {
        title = "设置"
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



extension SettingViewController: UITableViewDelegate, UITableViewDataSource {
    
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
            let vc = AccountSecurityVC()
            guard let model = dataList.ck_objIndex(indexPath.row) else { return }
            vc.title = model.title
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
        default:
            break
        }

        
    }
    
}




