//
//  Api.swift
//  huanxi
//
//  Created by rslz on 2024/11/4.
//

struct Api {

    //host
    static let onlineHost = ""
    static let testHost = "http://47.100.209.228:8181"
    static let baseURL = Api.testHost
    
    //首页接口
    static let homeTopData = "app/newindextop"

}

/*改进点:
 
 环境配置: 引入 isOnline 变量来控制环境，方便切换线上/测试环境。
 URL 组合: 添加 url(for path: String) 方法，方便构建完整的 URL。
 可读性: 使用更具描述性的变量名，如 onlineEnvironment, testEnvironment。
 安全性: 对于线上环境，建议使用 HTTPS 协议。
*/
