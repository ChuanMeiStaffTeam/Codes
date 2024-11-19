//
//  WebVC.swift
//  huanxi
//
//  Created by rslz on 2024/11/19.
//

import UIKit
import WebKit

class WebVC: BaseViewController {
    
    var webView: WKWebView!
    var pageTitle: String = "欢喜" // 外部传入的标题，默认值
    var contentStr: String = "" // 外部传入的String

    override func viewDidLoad() {
        super.viewDidLoad()
        setupWebView()
        title = pageTitle
        let leftButton = UIBarButtonItem(title: "关闭", style: .plain, target: self, action: #selector(leftButtonTapped))
        self.navigationItem.leftBarButtonItem = leftButton
        loadHTMLString(with: pageTitle, content: contentStr)
    }
    
    // 设置 WebView
    func setupWebView() {
        webView = WKWebView(frame: self.view.bounds)
        webView.navigationDelegate = self // 如果需要处理导航事件
        view.addSubview(webView)
    }
    
    // 加载 HTML 字符串，并传入标题
    func loadHTMLString(with title: String , content: String) {
        let htmlString = """
        <!DOCTYPE html>
        <html>
        <head>
            <title>\(title)</title>
            <style>
                body { font-family: -apple-system, Arial, sans-serif; padding: 16px; background-color: #f9f9f9; }
                h1 { color: #333; }
                p { color: #555; line-height: 8; }
            </style>
        </head>
        <body>
            <h1>\(content)</h1>
            <p>欢喜.happy</p>
        </body>
        </html>
        """
        
        webView.loadHTMLString(htmlString, baseURL: nil)
    }
    
    // 按钮点击事件
    @objc func leftButtonTapped() {
        if let navigationController = self.navigationController, navigationController.viewControllers.count > 1 {
            navigationController.popViewController(animated: true)
        } else {
            self.presentingViewController?.dismiss(animated: true, completion: nil)
        }
    }
}

// 如果需要监听导航事件，扩展导航代理
extension WebVC: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("WebView content loaded successfully.")
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        print("Failed to load WebView content: \(error.localizedDescription)")
    }
}
