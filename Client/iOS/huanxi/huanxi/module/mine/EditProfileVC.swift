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

