//
//  UpdatesViewController.swift
//  huanxi
//
//  Created by jack on 2024/2/18.
//

import UIKit

class UpdatesViewController: BaseViewController {
    
    let vm = MainViewModel()
    var mainView: MainView!

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        self.navigationController?.isNavigationBarHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        
//        mainView.reloadMainViewData(vm.mainList)
        vm.requestHomePosts { [weak self] result in
            
            if let data = self?.vm.data {
                self?.mainView.reloadMainViewData(data)
            }
        }
    }
    
    
    func setupView() {
        setupNavView()
        
        mainView = MainView(frame: CGRect.init(x: 0, y: 0, width: .screenWidth, height: .screenHeight - .bottomSafeAreaHeight - .tabBarHeight))
        view.addSubview(mainView)
        
    }
    
    func setupNavView() {
        
        let view = UIView(frame: CGRect.init(x: 0, y: 0, width: 150, height: 40))
        view.backgroundColor = .clear
        
        let imageView = UIImageView(image: UIImage.init(named: "huanxi.jpg"))
        imageView.frame = CGRect(x: 39, y: 0, width: 72, height: 36)
        imageView.contentMode = .scaleAspectFill
        view.addSubview(imageView)
//        let leftItem = UIBarButtonItem(customView: imageView)
        self.navigationItem.titleView = view
        
        let button = UIButton(type: .custom)
        button.frame = CGRect(x: .screenWidth - 46, y: 7, width: 30, height: 30)
        button.setImage(UIImage.init(named: "main_relay"), for: .normal)
        button.addTarget(self, action: #selector(gotoDirect), for: .touchUpInside)
        let rightItem = UIBarButtonItem(customView: button)
//        self.navigationItem.rightBarButtonItem = rightItem
        
    }
    
    
    @objc func gotoDirect() {
        let vc = DirectViewController()
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}

/*
class UpdatesViewController: BaseViewController {
    
    let updatesThisMonthCell = "UpdatesThisMonthCell"
    let updatesEarlierCell = "UpdatesEarlierCell"
    let updatesRecommendCell = "UpdatesRecommendCell"

    var dataList: [Int] = [1, 5, 3];
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        setupView()
    }
    
    
    func setupView() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview().offset(0)
        }
    }
    
    
    lazy var tableView: UITableView = {
        let view = UITableView.init(frame: CGRect.zero, style: UITableView.Style.plain)
        view.backgroundColor = .clear
        view.delegate = self
        view.dataSource = self
        view.register(UpdatesThisMonthCell.self, forCellReuseIdentifier: updatesThisMonthCell)
        view.register(UpdatesEarlierCell.self, forCellReuseIdentifier: updatesEarlierCell)
        view.register(UpdatesRecommendCell.self, forCellReuseIdentifier: updatesRecommendCell)
        return view
    }()
}

extension UpdatesViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        
        var text = "为您推荐"
        if section == 0 {
            text = "本月"
        } else if section == 1 {
            text = "更早之前"
        }
        let titleLabel = UILabel(frame: .init(x: 16, y: 0, width: 200, height: 40))
        titleLabel.textColor = .white
        titleLabel.font = .systemFont(ofSize: 14, weight: .medium)
        titleLabel.text = text
        headerView.addSubview(titleLabel)
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = dataList[section]
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            let cell = UpdatesThisMonthCell.init(style: .default, reuseIdentifier: updatesThisMonthCell)
            cell.followBlock = {
                HUDHelper.showToast("点击了关注")
            }
            return cell
        } else if indexPath.section == 1 {
            let cell = UpdatesEarlierCell.init(style: .default, reuseIdentifier: updatesEarlierCell)
            return cell
        } else {
            let cell = UpdatesRecommendCell.init(style: .default, reuseIdentifier: updatesRecommendCell)
            cell.followBlock = {
                HUDHelper.showToast("点击了关注")
            }
            cell.closeBlock = {
                HUDHelper.showToast("点击了关闭")
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 2 {
            return 82
        }
        return 64
    }
    
    
}

*/
