//
//  MainViewModel.swift
//  huanxi
//
//  Created by jack on 2024/2/28.
//

import Foundation

class MainViewModel {
    
    var mainList: [MainModel] = []
    
    required init() {
        configData()
    }
    
    func configData() {
        
        let u = MainUserModel.init(title: "用户名", icon: "")
        
        let user = MainModel(type: "user", users: [u, u, u, u,])
        let content = MainModel(type: "content", users: [])
        let recommend = MainModel(type: "recommend", users: [])

        mainList = [user, content, content, content, content, content, content, recommend, content]
    }
    
    
    
}
