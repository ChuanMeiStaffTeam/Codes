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
            <p>Shanghai Chuanmei Information Technology Co., Ltd</p>
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


/*代码分析：WebVC
 这段代码实现了一个简单的网页视图控制器。

 主要功能：

 加载网页内容: 通过传入的 HTML 字符串，在 WKWebView 中展示网页内容。
 自定义标题: 可以设置网页的标题。
 返回按钮: 提供了一个返回按钮，用于返回上一级页面。
 导航代理: 实现 WKNavigationDelegate 协议，可以监听网页加载过程中的事件，如加载完成、加载失败等。
 代码结构：

 属性:
 webView: 用于显示网页内容的 WKWebView 实例。
 pageTitle: 外部传入的页面标题。
 contentStr: 外部传入的 HTML 内容。
 方法:
 viewDidLoad: 初始化视图，设置 WebView 和导航栏。
 setupWebView: 创建并配置 WebView。
 loadHTMLString: 加载 HTML 字符串。
 leftButtonTapped: 处理返回按钮点击事件。
 WKNavigationDelegate 协议方法：用于监听 WebView 的导航事件。
 代码亮点：

 封装性好: 将 WebView 的创建和配置封装成一个类，方便复用。
 可定制性强: 可以通过修改 HTML 字符串来定制显示的内容和样式。
 功能完备: 支持加载 HTML 字符串、自定义导航栏、监听导航事件。
 潜在改进：

 错误处理: 可以添加错误处理，例如当加载 HTML 失败时，显示错误提示。
 性能优化: 对于大量 HTML 内容，可以考虑使用离线缓存或优化 JavaScript 执行效率。
 交互功能: 可以添加一些交互功能，比如支持手势操作、缩放等。
 自定义样式: 可以提供更多的自定义样式选项，例如字体、颜色等。
 URL 加载: 可以支持直接加载 URL，而不是仅限于 HTML 字符串。
 JavaScript交互: 如果需要与 JavaScript 进行交互，可以实现 WKNavigationDelegate 中的相关方法。*/
