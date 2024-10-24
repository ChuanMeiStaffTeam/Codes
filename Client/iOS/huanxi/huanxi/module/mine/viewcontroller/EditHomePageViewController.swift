//
//  EditHomePageViewController.swift
//  huanxi
//
//  Created by Jack on 2024/5/20.
//

import UIKit

struct AvatarResponse: Codable {
    let avatar: String?
}

class EditHomePageViewController: BaseViewController {
    
    let iconImgView = UIImageView()
    let changeIconBtn = UIButton(type: .custom)
    
    var nameTF = UITextField()
    var accountTF = UITextField()
    var webUrlTF = UITextField()
    var bioTF = UITextField()
    
    var originUser: UserInfoModel?

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
//        requestUserInfo()
    }
    
    func requestUserInfo() {
        NetworkManager.shared.getRequest(urlStr: "userinfo/getUserInfo",
                                         parameters: nil,
                                         responseType: UserInfoResponse.self) { success, message, data in
            if success, let user = data?.user {
                self.updateData(user)
            }
            HUDHelper.showToast(message)
        }
    }
    
    func updateData(_ info: UserInfoModel) {
        originUser = info
        if let urlStr = info.profilePictureUrl {
            iconImgView.kf.setImage(with: URL.init(string: urlStr))
        }
        
        nameTF.text = info.fullName
        accountTF.text = info.username
        webUrlTF.text = info.websiteUrl
        bioTF.text = info.bio
        
    }
    
    func setupView() {
        
        let backBtn = UIButton(type: .custom)
        backBtn.setTitle("取消", for: .normal)
        backBtn.setTitleColor(.white, for: .normal)
        backBtn.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        backBtn.addTarget(self, action: #selector(backAction), for: .touchUpInside)
        view.addSubview(backBtn)
        backBtn.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.top.equalToSuperview().offset(CGFloat.topSafeAreaHeight)
            make.height.equalTo(40)
        }
        
        let titleLabel = UILabel()
        titleLabel.text = "编辑主页"
        titleLabel.font = .systemFont(ofSize: 16, weight: .medium)
        titleLabel.textColor = .white
        view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview().offset(0)
            make.centerY.equalTo(backBtn).offset(0)
        }
        
        let completeBtn = UIButton(type: .custom)
        completeBtn.setTitle("完成", for: .normal)
        completeBtn.setTitleColor(.mainBlueColor, for: .normal)
        completeBtn.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        completeBtn.addTarget(self, action: #selector(completeAction), for: .touchUpInside)
        view.addSubview(completeBtn)
        completeBtn.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-16)
            make.top.equalToSuperview().offset(CGFloat.topSafeAreaHeight)
            make.height.equalTo(40)
        }
        
        
        iconImgView.image = UIImage(named: "main_recommend_text")
        view.addSubview(iconImgView)
        iconImgView.layer.cornerRadius = 40
        iconImgView.layer.masksToBounds = true
        iconImgView.snp.makeConstraints { make in
            make.centerX.equalToSuperview().offset(0)
            make.top.equalTo(titleLabel.snp.bottom).offset(24)
            make.width.height.equalTo(80)
        }
        
        changeIconBtn.setTitle("更换头像", for: .normal)
        changeIconBtn.setTitleColor(.mainBlueColor, for: .normal)
        changeIconBtn.titleLabel?.font = .systemFont(ofSize: 12)
        changeIconBtn.addTarget(self, action: #selector(changeIcon), for: .touchUpInside)
        view.addSubview(changeIconBtn)
        changeIconBtn.snp.makeConstraints { make in
            make.centerX.equalToSuperview().offset(0)
            make.top.equalTo(iconImgView.snp.bottom).offset(12)
        }
        
        
        createLine(left: 0, top: .topSafeAreaHeight + 200)
        
        var itemTop = .topSafeAreaHeight + 200
        nameTF = createItem(title: "姓名", value: "小摩", top: itemTop)
        itemTop = itemTop + 46
        
        accountTF = createItem(title: "账号", value: "xiaomo", top: itemTop)
        accountTF.isUserInteractionEnabled = false
        itemTop = itemTop + 46
        
        webUrlTF = createItem(title: "网站", value: "www.baidu.com", top: itemTop)
        itemTop = itemTop + 46
        
        bioTF = createItem(title: "个性签名", value: "设计+协作，摹客就够了！", top: itemTop, lineHidden: true)
        itemTop = itemTop + 46
        
//        createLine(left: 0, top: itemTop)
//        let titleLabel1 = UILabel(frame: CGRect(x: 20, y: itemTop, width: 100, height: 46))
//        titleLabel1.text = "切换为专业账户"
//        titleLabel1.textColor = .mainBlueColor
//        titleLabel1.font = .systemFont(ofSize: 14)
//        view.addSubview(titleLabel1)
//
//
//        itemTop = itemTop + 46
        createLine(left: 0, top: itemTop)
//        let titleLabel2 = UILabel(frame: CGRect(x: 20, y: itemTop, width: 100, height: 46))
//        titleLabel2.text = "个人信息设置"
//        titleLabel2.textColor = .mainBlueColor
//        titleLabel2.font = .systemFont(ofSize: 14)
//        view.addSubview(titleLabel2)
        
        
    }
    
    func createLine(left: CGFloat, top: CGFloat) {
        let line = UIView(frame: CGRect(x: left, y: top, width: .screenWidth - left, height: 0.5))
        line.backgroundColor = .gray
        view.addSubview(line)
    }
    
    func createItem(title: String, value: String, top: CGFloat, lineHidden: Bool = false) -> UITextField {
        let titleLabel = UILabel(frame: CGRect(x: 20, y: top, width: 100, height: 46))
        titleLabel.text = title
        titleLabel.textColor = .white
        titleLabel.font = .systemFont(ofSize: 14)
        view.addSubview(titleLabel)
        
        let valueTF = UITextField(frame: CGRect(x: 120, y: top, width: 200, height: 46))
        valueTF.text = value
        valueTF.textColor = .white
        valueTF.font = .systemFont(ofSize: 14)
        view.addSubview(valueTF)
        
        if !lineHidden {
            createLine(left: 120, top: top + 45)
        }
        return valueTF
    }
    
    
    @objc func backAction() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func changeIcon() {
        // 设置图片选择器
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        // 只允许选择照片
        imagePicker.mediaTypes = ["public.image"]
        // 模态展示图片选择器
        present(imagePicker, animated: true)
    }
    
    
    @objc func completeAction() {
        backAction()
//        let params = [
//            "fullName": nameTF.text,
//            "websiteUrl": webUrlTF.text,
//            "bio": bioTF.text
//        ]
//
//        NetworkManager.shared.postRequest(urlStr: "userinfo/updateInfo",
//                                         parameters: params,
//                                         responseType: UserInfoResponse.self) { success, message, data in
//            if success, let user = data?.user {
//                self.updateData(user)
//            }
//            HUDHelper.showToast(message)
//        }
//
        
    }
}

 
extension EditHomePageViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
 
    // 实现代理方法来处理选中的图片
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        // 获取选中的图片
        if let image = info[.originalImage] as? UIImage {
            // 处理图片，例如显示在UIImageView上
            // imageView.image = image
            self.iconImgView.image = image
            // 上传单张图片
//            NetworkManager.shared.uploadSingleImage(urlStr: "userinfo/updateAvatar",
//                                                    parameters: ["": ""],
//                                                    image: image,
//                                                    responseType: AvatarResponse.self) { success, message, data in
//                if success {
//                    self.iconImgView.image = image
//                } else {
//                }
//                HUDHelper.showToast(message)
//            }
        }
        // 关闭图片选择器
        picker.dismiss(animated: true)
    }
 
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        // 用户取消选择图片时的处理
        picker.dismiss(animated: true)
    }
}
