//
//  LoginManager.swift
//  huanxi
//
//  Created by jack on 2024/7/25.
//

import Foundation
import UIKit

class LoginManager {
    static let tokenKey = "tokenKey"
        
    class func isLogin() -> Bool {
        if getToken() != nil {
            return true
        }
        return false
    }
    
    
    class func updateUserInfo(info: UserInfoModel) {
        
    }
    
    class func updateToken(token: String) {
        UserDefaults.standard.setValue(token, forKey: tokenKey)
        UserDefaults.standard.synchronize()
    }
    
    class func getToken() -> String? {
        let string = UserDefaults.standard.string(forKey: tokenKey)
        return string
    }
    
    class func removeToken() {
        UserDefaults.standard.removeObject(forKey: tokenKey)
    }
}


extension LoginManager {
    
    class func requestUserInfo() {
//        NetworkManager.shared.getRequest(urlStr: "userinfo/getUserInfo",
//                                         parameters: nil,
//                                         responseType: UserInfoModel.self) { success, message, data in
//            if success {
//
//            }
//            HUDHelper.showToast(message)
//        }
        
    }
    
    class func requestLogout() {
//        NetworkManager.shared.postRequest(urlStr: "user/logout",
//                                          parameters: nil,
//                                          responseType: String.self) { success, message, data in
//            if success {
//                LoginManager.removeToken()
//
//                let loginVC = LoginViewController()
//                let topVC = WindowHelper.topViewController()
//                loginVC.modalPresentationStyle = .fullScreen
//                topVC?.present(loginVC, animated: true)
//            }
//            HUDHelper.showToast(message)
//        }

    }
    
}
