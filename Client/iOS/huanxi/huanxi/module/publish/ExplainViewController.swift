//
//  ExplainViewController.swift
//  huanxi
//
//  Created by jack on 2024/3/19.
//

import UIKit
import RxSwift

struct ExplainItem {
    
    var title: String
    var detail: String
    var type: Int
    var switchStatus: Int
    
}

class ExplainViewController: BaseViewController {
    
    var explainItems: [ExplainItem] = []
    var images: [UIImage] = []
    var locationCity: String = "上海市"
    var tags: String = ""

    let textView = UITextView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupData()
        setupView()
        setupNavView()
        requesLocation()
    }
    
    func setupData() {
        
        let tags = ExplainItem(title: "话题标签", detail: "#话题 例如：美食、旅游、设计等...", type: 1, switchStatus: 0)
//        let mark = ExplainItem(title: "标记用户", detail: "", type: 0, switchStatus: 0)
//        let address = ExplainItem(title: "添加地点", detail: "", type: 0, switchStatus: 0)
//        let wx = ExplainItem(title: "微信", detail: "", type: 1, switchStatus: 0)
//        let wb = ExplainItem(title: "微博", detail: "", type: 1, switchStatus: 0)

        explainItems.append(tags)
//        explainItems.append(mark)
//        explainItems.append(address)
//        explainItems.append(wx)
//        explainItems.append(wb)
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
        
        self.keyboardWillHide()
        
        guard let desc = textView.text, !desc.isEmpty else {
            HUDHelper.showToast("请输入说明")
            return
        }
        HUDHelper.showHUD(in: self.view, text: "图片上传中")
        // 上传图片，获取图片地址
        NetworkManager.shared.uploadMultipleImages(path: "postImage/article",
                                                   parameters: ["": ""],
                                                   images: images,
                                                   imageName: "images",
                                                   responseType: ImageResponse.self) { success, message, data in
            HUDHelper.hideHUD(in: self.view)
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
            "location": locationCity,
            "tags": self.tags,
            "imagesUrl": imagesUrl
        ] as [String : Any]
        NetworkManager.shared.postRequest(path: "postImage/createPost",
                                          parameters: params,
                                          responseType: String.self) { success, message, data in
            if success {
                HUDHelper.showToast("帖子发布成功")
                NotificationCenter.default.post(
                    name: .refreshMainPageNotification,
                    object: nil,
                    userInfo: nil
                )
                
                self.view.window?.rootViewController?.dismiss(animated: true, completion: {
                    let topVC = WindowHelper.topViewController()
                    topVC?.tabBarController?.selectedIndex = 0
                })
            } else {
                HUDHelper.showToast(message)
            }
        }
    }
    
    //ip定位
    func requesLocation() {
        Tools.fetchIPLocation { [weak self] result in
            guard let `self` = self else { return }
            switch result {
            case .success(let locationData):
                self.locationCity = locationData["regionName"] as? String ?? "上海市"
                print("Location Data: \(self.locationCity)")
            case .failure(let error):
                print("Error: \(error.localizedDescription)")
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
        keyboardWillHide()
    }
    
    @objc func keyboardWillHide() {
        // 键盘隐藏时，收回第一响应者
        self.view.endEditing(true)
    }
}



extension ExplainViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return explainItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = ExplainViewCell.init(style: .default, reuseIdentifier: "ExplainViewCell")
        cell.explainItem = explainItems[indexPath.row]
        cell.tagTextTextField.rx.text
            .distinctUntilChanged()
            .subscribe(onNext: { [weak self] text in
                guard let self = self else { return }
                let trimmedString = text?.trimmingCharacters(in: .whitespacesAndNewlines)
                self.tags = trimmedString ?? ""
//                let isBlank = trimmedString?.isEmpty ?? true
            })
            .disposed(by: disposeBag)
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
    let tagTextTextField = UITextField()
    
    var disposeBag = DisposeBag()

    var explainItem: ExplainItem! {
        didSet {
            
            titleLabel.text = explainItem.title
            
            switch explainItem.type {
            case 0:
                switchView.isHidden = true
                tagTextTextField.isHidden = true
                if explainItem.detail.count == 0 {
                    detailLabel.isHidden = true
                    arrowImgView.isHidden = false
                } else {
                    detailLabel.text = explainItem.detail
                    detailLabel.isHidden = false
                    arrowImgView.isHidden = true
                }
            case 1:
                detailLabel.isHidden = true
                arrowImgView.isHidden = true
                switchView.isHidden = true
                tagTextTextField.isHidden = false
                tagTextTextField.placeholder = explainItem.detail
                break
            default:
                tagTextTextField.isHidden = true
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
        
        tagTextTextField.textAlignment = .right
        contentView.addSubview(tagTextTextField)
        tagTextTextField.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-16)
            make.centerY.equalToSuperview().offset(0)
            make.width.equalTo(UIDevice.screenWidth/2)
            make.height.equalTo(35)
        }
        
    }
    
}


/*代码功能概览

这段代码主要实现了一个用于编辑图片并发布帖子的视图控制器 ExplainViewController。它提供了一个用户界面，允许用户：

选择图片: 从已有的图片中选择多张图片。
添加文字描述: 在文本框中输入对图片的描述。
添加标签: 在文本框中输入标签，用于分类帖子。
选择位置: 获取用户当前位置，并将其添加到帖子中。
发布帖子: 将图片、描述、标签和位置信息发送到服务器，创建新的帖子。
代码主要模块及功能

ExplainViewController:
属性: 存储图片、解释文本、标签、位置等信息。
方法:
setupView：设置界面布局，包括图片选择视图、文本输入框、标签输入框等。
setupNavView：设置导航栏，包括关闭按钮和分享按钮。
shareAction：点击分享按钮时触发，负责上传图片并创建帖子。
requesLocation：获取用户当前位置。
ExplainImagesView:
用于展示选中的图片，支持单张图片和多张图片的显示。
ExplainViewCell:
自定义的 UITableViewCell，用于展示不同的解释项（如标签、位置等）。
代码逻辑

初始化:
加载图片数据。
初始化界面布局。
获取用户位置。
用户交互:
用户选择图片。
用户在文本框中输入描述和标签。
用户点击分享按钮。
发布帖子:
上传图片到服务器。
将图片地址、描述、标签和位置信息发送到服务器，创建新的帖子。
界面更新:
根据用户输入更新界面显示。
发布成功后，刷新主页面并关闭当前视图。
代码亮点

模块化设计: 将不同的功能模块化，提高代码的可维护性。
数据绑定: 使用 RxSwift 实现文本输入框和标签的绑定。
网络请求: 使用 NetworkManager 处理图片上传和帖子创建的网络请求。
用户体验: 提供了直观的用户界面，方便用户操作。
潜在改进

错误处理: 可以添加更完善的错误处理机制，例如网络请求失败、图片上传失败等。
用户体验优化: 可以添加加载动画、提示信息等，提升用户体验。
图片编辑功能: 可以增加图片编辑功能，如裁剪、滤镜等。
标签自动补全: 可以实现标签的自动补全功能，方便用户输入。
位置选择: 可以提供更精确的位置选择方式，例如地图选择。
总结

 这段代码实现了一个功能相对完整的图片分享功能。它涵盖了图片选择、文字描述、标签添加、位置定位、网络请求等多个方面。通过进一步优化，可以打造一个更加完善的图片分享应用。*/
