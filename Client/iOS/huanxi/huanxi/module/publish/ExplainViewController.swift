//
//  ExplainViewController.swift
//  huanxi
//
//  Created by jack on 2024/3/19.
//

import UIKit

struct ExplainItem {
    
    var title: String
    var detail: String
    var type: Int
    var switchStatus: Int
    
}

class ExplainViewController: BaseViewController {
    
    var explainItems: [ExplainItem] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupData()
        setupView()
    }
    
    func setupData() {
        
        let mark = ExplainItem(title: "标记用户", detail: "", type: 1, switchStatus: 0)
        let address = ExplainItem(title: "添加地点", detail: "", type: 1, switchStatus: 0)
        let wx = ExplainItem(title: "微信", detail: "", type: 2, switchStatus: 0)
        let wb = ExplainItem(title: "微博", detail: "", type: 2, switchStatus: 0)

        explainItems.append(mark)
        explainItems.append(address)
        explainItems.append(wx)
        explainItems.append(wb)
    }
    
    func setupView() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(0)
        }
    }
    
    lazy var tableView: UITableView = {
        let view = UITableView.init(frame: CGRect.zero, style: UITableView.Style.plain)
        view.backgroundColor = .clear
        view.delegate = self
        view.dataSource = self
        view.register(ExplainViewCell.self, forCellReuseIdentifier: "ExplainViewCell")
        return view
    }()
    
    
}



extension ExplainViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return explainItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = ExplainViewCell.init(style: .default, reuseIdentifier: "ExplainViewCell")
        cell.explainItem = explainItems[indexPath.row]
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 54
    }
    
    
}


class ExplainViewCell: UITableViewCell {
    
    let titleLabel = UILabel()
    let detailLabel = UILabel()
    let arrowImgView = UIImageView()
    let switchView = UISwitch()
    
    var explainItem: ExplainItem! {
        didSet {
            
            titleLabel.text = explainItem.title
            if explainItem.type == 0 {
                switchView.isHidden = true
                if explainItem.detail.count == 0 {
                    detailLabel.isHidden = true
                    arrowImgView.isHidden = false
                } else {
                    detailLabel.text = explainItem.detail
                    detailLabel.isHidden = false
                    arrowImgView.isHidden = true
                }
            } else {
                detailLabel.isHidden = true
                arrowImgView.isHidden = true
                switchView.isHidden = false
                switchView.isOn = explainItem.switchStatus == 1
            }
            
        }
    }
    

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


    func setupView() {
        
        
        
        
    }
    
}
