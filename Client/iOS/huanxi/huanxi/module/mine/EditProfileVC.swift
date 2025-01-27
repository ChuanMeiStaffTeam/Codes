//
//  EditUserInfoVC.swift
//  huanxi
//
//  Created by rslz on 2025/1/10.
//

import UIKit

class EditProfileVC: BaseViewController {

    lazy var tableView: UITableView = {
        let view = UITableView.init(frame: CGRect.zero, style: UITableView.Style.plain)
        view.backgroundColor = .clear
        view.separatorStyle = .none
        view.delegate = self
        view.dataSource = self
        view.rowHeight = UITableView.automaticDimension
        view.estimatedRowHeight = 64
        view.register(SettingItemCell.self)
        return view
    }()

    private let avatarImgView: UIImageView = UIImageView().then({view in
        view.image = UIImage(resource: .avatarDefault)
        view.layer.cornerRadius = 40
        view.layer.masksToBounds = true
    })
    
    private var dataList: [SetModel] = []
        
    private let viewModel = MineViewModel()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "编辑资料"
        setupUI()
    }
    
    func setupUI() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.top.bottom.left.right.equalToSuperview().offset(0)
        }
        
        let headerView = UIView()
        headerView.frame = CGRect(x: 0, y: 0, width: UIDevice.screenWidth, height: 120)
        headerView.addSubview(avatarImgView)
        avatarImgView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.height.equalTo(80)
        }
        tableView.tableHeaderView = headerView
        
        avatarImgView.rx.tapGestureThrottle().subscribe { [weak self]_ in
            guard let `self` = self else { return }
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .photoLibrary
            imagePicker.mediaTypes = ["public.image"]
            present(imagePicker, animated: true)
            
        }.disposed(by: disposeBag)
    }
    
    func reloadData() {
        let user = LoginManager.shared.getUserInfo()
        
        dataList = [
            SetModel(title: "名字", subTitle: user?.fullName ?? "", type: MineViewModel.ProfileType.name.rawValue),
            SetModel(title: "欢喜号", subTitle: user?.username ?? "", type: MineViewModel.ProfileType.account.rawValue),
            SetModel(title: "主页", subTitle: user?.websiteUrl ?? "", type: MineViewModel.ProfileType.webSite.rawValue),
            SetModel(title: "个性签名", subTitle: user?.bio ?? "", type: MineViewModel.ProfileType.bio.rawValue),
        ]
        
        if let urlStr = user?.profilePictureUrl {
            avatarImgView.kf.setImage(with: URL.init(string: urlStr))
        }
        
        tableView.reloadData()
    }
}

extension EditProfileVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let model = dataList.ck_objIndex(indexPath.row) else { return UITableViewCell() }
        let cell: SettingItemCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
        cell.model = model
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let model = dataList.ck_objIndex(indexPath.row) else { return }
        let vc = InputProfileVC()
        vc.initialText = model.subTitle
        vc.type = MineViewModel.ProfileType(rawValue:model.type)!
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

 
extension EditProfileVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage {
            Task{
                HUDHelper.showHUD(view, text: "")
                let success = await self.viewModel.uploadAvatar(image)
                HUDHelper.hideHUD(view)
                if success {
                    self.avatarImgView.image = image
                }
            }
        }
        picker.dismiss(animated: true)
    }
 
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
}

/*代码功能
 
 这段代码实现了一个编辑用户资料的界面。用户可以在此界面查看和修改其个人信息，例如名字、用户名、主页链接和个性签名。同时还可以更换头像。

 代码结构

 类:
 EditProfileVC: 编辑资料的视图控制器，负责界面的搭建、数据加载和用户交互处理。
 属性:
 tableView: 显示用户资料列表的表格视图。
 avatarImgView: 显示用户头像的图像视图。
 dataList: 存储用户资料信息的数组。
 viewModel: 用于获取和更新用户资料的视图模型。
 方法:
 viewDidLoad: 设置界面的标题和布局。
 viewWillAppear: 在界面即将显示时加载用户资料数据。
 reloadData: 加载用户资料数据并刷新表格视图。
 其他方法用于处理表格视图的数据源和代理，响应用户点击头像和资料条目等操作。
 代码逻辑

 界面加载时，首先设置标题和布局。
 在即将显示界面时或数据更新时，调用 reloadData 方法加载用户资料数据。
 从 LoginManager 获取当前登录用户信息。
 根据用户信息创建 SetModel 对象并添加到 dataList 数组中，每个 SetModel 对象表示一个资料条目。
 如果有头像地址，则使用 Kingfisher 加载并设置头像。
 刷新表格视图。
 点击表格视图的资料条目时，会根据选中的条目类型打开一个新的 InputProfileVC 界面，用于编辑对应的资料内容。
 点击头像时，会打开照片选择器，可以选择一张新的头像图片。
 选择图片后，会异步调用 viewModel.uploadAvatar 方法上传图片到服务器。
 上传成功后，更新头像视图的图片。
 总体而言，这段代码清晰地实现了编辑用户资料的功能，并使用了异步任务来处理头像上传操作，提升了用户体验。*/
