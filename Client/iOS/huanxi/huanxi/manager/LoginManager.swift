//
//  LoginManager.swift
//  huanxi
//
//  Created by jack on 2024/7/25.
//

import Foundation

class LoginManager {
    static let shared = LoginManager()
    
    private init() {
        // 初始化时加载 Token 和用户信息
        self.token = UserDefaults.standard.string(forKey: tokenKey)
        
        if let data = UserDefaults.standard.data(forKey: userInfoKey) {
            self.userInfo = try? JSONDecoder().decode(UserInfoModel.self, from: data)
        }
    }
    
    private let tokenKey = "tokenKey"
    private let userInfoKey = "userInfoKey"
    
    private var token: String?
    private var userInfo: UserInfoModel?
    
    /// 判断是否已登录
    func isLogin() -> Bool {
        return token != nil
    }
    
    /// 更新 Token
    func updateToken(token: String) {
        self.token = token
        UserDefaults.standard.setValue(token, forKey: tokenKey)
    }
    
    /// 获取 Token
    func getToken() -> String? {
        return token
    }
    
    /// 移除 Token
    func removeToken() {
        self.token = nil
        UserDefaults.standard.removeObject(forKey: tokenKey)
    }
    
    /// 更新用户信息
    func updateUserInfo(info: UserInfoModel) {
        self.userInfo = info
        if let encodedData = try? JSONEncoder().encode(info) {
            UserDefaults.standard.set(encodedData, forKey: userInfoKey)
        }
    }
    
    /// 获取用户信息
    func getUserInfo() -> UserInfoModel? {
        return userInfo
    }
    
    /// 移除用户信息
    func removeUserInfo() {
        self.userInfo = nil
        UserDefaults.standard.removeObject(forKey: userInfoKey)
    }
    
    /// 退出登录
    func logout() {
        removeToken()
        removeUserInfo()
    }
}


extension LoginManager {
    class func requestCode(_ phone: String) async -> Bool {
        await withCheckedContinuation { continuation in
            NetworkManager.shared.postRequest(path: "sms/send",
                                             parameters: ["phone":phone],
                                             responseType: UpdateUserModel.self) { success, message, data in
                if success {
                } else {
                    HUDHelper.showToast(message)
                }
                continuation.resume(returning: success)
            }
        }
    }
    
    class func fetchUpdatePhoneCode(_ phone: String) async -> Bool {
        await withCheckedContinuation { continuation in
            NetworkManager.shared.postRequest(path: "sms/updatePhone",
                                             parameters: ["phone":phone],
                                             responseType: UpdateUserModel.self) { success, message, data in
                if success {
                } else {
                    HUDHelper.showToast(message)
                }
                continuation.resume(returning: success)
            }
        }
    }
    
    class func requestChangePhone(_ params: [String: Any]) async -> Bool {
        await withCheckedContinuation { continuation in
            NetworkManager.shared.postRequest(path: "userInfo/updatePhone",
                                             parameters: params,
                                             responseType: UpdateUserModel.self) { success, message, data in
                if success {
                } else {
                    HUDHelper.showToast(message)
                }
                continuation.resume(returning: success)
            }
        }
    }
    
    class func requestLogin(params: [String: Any], completion: @escaping (Bool) -> Void) {
        HUDHelper.showHUD()
        NetworkManager.shared.postRequest(path: "user/login/code",
                                          parameters: params,
                                          responseType: LoginModel.self) { success, message, data in
            HUDHelper.hideHUD()
            if success {
                if let token = data?.token {
                    LoginManager.shared.updateToken(token: token)
                }
                if let userInfo = data?.userinfo {
                    LoginManager.shared.updateUserInfo(info: userInfo)
                    HUDHelper.showToast("@\(userInfo.fullName ?? "") 登录成功")
                }
                NotificationCenter.default.post(
                    name: .refreshMainPageNotification,
                    object: nil,
                    userInfo: nil
                )
            } else {
                HUDHelper.showToast(message)
            }
            completion(success)
        }
        
    }
    
    class func requestUserInfo(completion: @escaping (Bool) -> Void) {
        NetworkManager.shared.getRequest(path: "userinfo/getUserInfo",
                                         parameters: nil,
                                         responseType: UpdateUserModel.self) { success, message, data in
            if success {
                if let userInfo = data?.user {
                    LoginManager.shared.updateUserInfo(info: userInfo)
                }
            } else {
                HUDHelper.showToast(message)
            }
            completion(success)
        }
    }
    
    class func requestOtherUserInfo(userId: String, completion: @escaping ((UserInfoModel?, Bool)?) -> Void) {
        NetworkManager.shared.postRequest(path: "userinfo/getUserById",
                                         parameters: ["userId" : userId],
                                         responseType: LoginModel.self) { success, message, data in
            if success {
                if let userInfo = data?.userinfo {
                    completion((userInfo, data?.reported ?? false))
                } else {
                    completion(nil)
                }
            } else {
                completion(nil)
                HUDHelper.showToast(message)
            }
        }
    }
    
    class func requestLogout(completion: @escaping (Bool) -> Void) {
        NetworkManager.shared.postRequest(path: "user/logout",
                                          parameters: nil,
                                          responseType: String.self) { success, message, data in
            if success {
                LoginManager.shared.logout()

                NotificationCenter.default.post(
                    name: .refreshMainPageNotification,
                    object: nil,
                    userInfo: nil
                )
                let topVC = WindowHelper.topViewController()
                topVC?.tabBarController?.selectedIndex = 0
                topVC?.navigationController?.popToRootViewController(animated: false)
            } else {
                HUDHelper.showToast(message)
            }
            completion(success)
        }
    }
    
    class func requestAccountDelete(completion: @escaping (Bool) -> Void) {
        NetworkManager.shared.deleteRequest(path: "user/account/delete",
                                          parameters: nil,
                                          responseType: String.self) { success, message, data in
            if success {
                LoginManager.shared.logout()

                NotificationCenter.default.post(
                    name: .refreshMainPageNotification,
                    object: nil,
                    userInfo: nil
                )
                let topVC = WindowHelper.topViewController()
                topVC?.tabBarController?.selectedIndex = 0
                topVC?.navigationController?.popToRootViewController(animated: false)
            } else {
                HUDHelper.showToast(message)
            }
            completion(success)
        }
    }
    
    
    
    class func fetchUpdateUserInfo(params: [String: Any]) async -> Bool {
        await withCheckedContinuation { continuation in
            NetworkManager.shared.postRequest(path: "userinfo/updateInfo",
                                             parameters: params,
                                             responseType: UpdateUserModel.self) { success, message, data in
                if success, let user = data?.user {
                    LoginManager.shared.updateUserInfo(info: user)
                } else {
                    HUDHelper.showToast(message)
                }
                continuation.resume(returning: success)
            }
        }
    }
}

/*分析 LoginManager.swift
 这段代码定义了一个名为 LoginManager 的单例类，用于管理用户登录状态和用户信息。主要功能如下：

 存储和读取 Token 及用户信息 (通过 UserDefaults)
 判断是否登录
 更新 Token 和用户信息
 移除 Token 和用户信息
 登录、登出操作
 获取其他用户的信息
 总体评价:

 代码结构清晰，易于理解。
 使用 UserDefaults 存储 Token 和用户信息方便快捷。
 网络请求部分使用了 NetworkManager 进行封装，提高了代码的可维护性。
 改进建议:

 错误处理: 目前网络请求部分没有显式的错误处理，可以考虑添加错误处理，并根据错误信息进行相应的提示。
 异步操作: 部分网络请求方法使用的是同步的方式，可以考虑使用异步的方式来提升用户体验。
 安全性: 存储在 UserDefaults 中的 Token 建议进行加密处理，以提高安全性。
 依赖注入: 如果 NetworkManager 是单独的类，可以考虑使用依赖注入的方式进行传递，提高代码的可测试性。
*/
