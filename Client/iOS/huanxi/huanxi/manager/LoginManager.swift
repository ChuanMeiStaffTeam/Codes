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
        NetworkManager.shared.postRequest(path: "user/login/code",
                                          parameters: params,
                                          responseType: LoginModel.self) { success, message, data in
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
    
    class func requestOtherUserInfo(userId: String, completion: @escaping (UserInfoModel?) -> Void) {
        NetworkManager.shared.postRequest(path: "userinfo/getUserById",
                                         parameters: ["userId" : userId],
                                         responseType: UserInfoModel.self) { success, message, data in
            if success {
                if let userInfo = data {
                    completion(userInfo)
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
