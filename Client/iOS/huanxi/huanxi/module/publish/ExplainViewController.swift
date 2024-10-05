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
    var images: [UIImage] = []
    
    let textView = UITextView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupData()
        setupView()
        setupNavView()
    }
    
    func setupData() {
        
        let mark = ExplainItem(title: "标记用户", detail: "", type: 0, switchStatus: 0)
        let address = ExplainItem(title: "添加地点", detail: "", type: 0, switchStatus: 0)
        let wx = ExplainItem(title: "微信", detail: "", type: 1, switchStatus: 0)
        let wb = ExplainItem(title: "微博", detail: "", type: 1, switchStatus: 0)

        explainItems.append(mark)
        explainItems.append(address)
        explainItems.append(wx)
        explainItems.append(wb)
    }
    
    func setupView() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview().offset(0)
            make.top.equalToSuperview().offset(.topSafeAreaHeight+40)
        }
        
        let headerView = UIView()
        headerView.frame = CGRect.init(x: 0, y: 0, width: .screenWidth, height: 330)
        tableView.tableHeaderView = headerView
        
        let explainImagesView = ExplainImagesView()
        explainImagesView.frame = CGRect.init(x: 0, y: 0, width: CGFloat.screenWidth, height: 250)
        headerView.addSubview(explainImagesView)
        
        explainImagesView.images = images
        
        textView.addPlaceholder("添加说明...")
        headerView.addSubview(textView)
        textView.backgroundColor = .clear
        textView.frame = CGRect.init(x: 16, y: 260, width: CGFloat.screenWidth - 32, height: 60)
        textView.font = .systemFont(ofSize: 16)
        textView.textColor = .white
    }
    
    func setupNavView() {
        let closeBtn = UIButton(type: .custom)
        closeBtn.setImage(UIImage.init(named: "publish_close"), for: .normal)
        closeBtn.addTarget(self, action: #selector(closeAction), for: .touchUpInside)
        view.addSubview(closeBtn)
        closeBtn.snp.makeConstraints { make in
            make.height.width.equalTo(20)
            make.left.equalToSuperview().offset(16)
            make.top.equalToSuperview().offset(CGFloat.topSafeAreaHeight+10)
        }
        
        
        let shareBtn = UIButton(type: .custom)
        shareBtn.setTitle("分享", for: .normal)
        shareBtn.setTitleColor(.mainBlueColor, for: .normal)
        shareBtn.titleLabel?.font = .systemFont(ofSize: 16)
        shareBtn.addTarget(self, action: #selector(shareAction), for: .touchUpInside)
        view.addSubview(shareBtn)
        shareBtn.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-16)
            make.centerY.equalTo(closeBtn.snp.centerY).offset(0)
            make.width.equalTo(40)
            make.height.equalTo(40)
        }
    }
    
    @objc func closeAction() {
        dismiss(animated: true)
    }
    
    @objc func shareAction() {
        
        guard let desc = textView.text, !desc.isEmpty else {
            HUDHelper.showToast("请输入说明")
            return
        }
        HUDHelper.showHUD(self.view, text: "图片上传中")
        // 上传图片，获取图片地址
        NetworkManager.shared.uploadMultipleImages(urlStr: "postImage/article",
                                                   parameters: ["": ""],
                                                   images: images,
                                                   imageName: "images",
                                                   responseType: ImageResponse.self) { success, message, data in
            HUDHelper.hideHUD(self.view)
            if success {
                self.requestPost(desc: desc, imagesUrl: data?.list ?? [])
                HUDHelper.showToast("图片上传成功")
            } else {
                HUDHelper.showToast(message)
            }
        }
    }
    
    func requestPost(desc: String, imagesUrl: [String]) {
        let params = [
            "caption": desc,
            "location": "上海市",
            "imagesUrl": imagesUrl
        ] as [String : Any]
        NetworkManager.shared.postRequest(urlStr: "postImage/createPost",
                                          parameters: params,
                                          responseType: String.self) { success, message, data in
            if success {
                HUDHelper.showToast("帖子发布成功")
                self.view.window?.rootViewController?.dismiss(animated: true)
            } else {
                HUDHelper.showToast(message)
            }
            
        }
    }
    
    
    lazy var tableView: UITableView = {
        let view = UITableView.init(frame: CGRect.zero, style: UITableView.Style.plain)
        view.backgroundColor = .clear
        view.delegate = self
        view.dataSource = self
        view.register(ExplainViewCell.self, forCellReuseIdentifier: "ExplainViewCell")
        view.keyboardDismissMode = .onDrag
        return view
    }()
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
}



extension ExplainViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return explainItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = ExplainViewCell.init(style: .default, reuseIdentifier: "ExplainViewCell")
        cell.explainItem = explainItems[indexPath.row]
        return cell
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
        self.backgroundColor = .clear
        self.contentView.backgroundColor = .black
        selectionStyle = .none
        
        titleLabel.textColor = .white
        titleLabel.font = .systemFont(ofSize: 16)
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(12)
            make.centerY.equalToSuperview().offset(0)
        }
        
        arrowImgView.image = .init(named: "publish_arrow")
        contentView.addSubview(arrowImgView)
        arrowImgView.snp.makeConstraints { make in
            make.height.width.equalTo(16)
            make.right.equalToSuperview().offset(-16)
            make.centerY.equalToSuperview().offset(0)
        }
        
        detailLabel.textColor = .white
        detailLabel.font = .systemFont(ofSize: 14)
        contentView.addSubview(detailLabel)
        detailLabel.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-16)
            make.centerY.equalToSuperview().offset(0)
        }
        
        switchView.isOn = false
        contentView.addSubview(switchView)
        switchView.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-16)
            make.centerY.equalToSuperview().offset(0)
        }
        
        
    }
    
}
