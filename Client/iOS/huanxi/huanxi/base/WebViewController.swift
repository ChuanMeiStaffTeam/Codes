//
//  WebViewController.swift
//  huanxi
//
//  Created by jack on 2024/9/13.
//

import UIKit
import WebKit

class WebViewController: BaseViewController {
    

    let webView = WKWebView()
    var urlStr: String?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = false
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
    }
    
    func setupView() {
        
        view.addSubview(webView)
        webView.snp.makeConstraints { make in
            make.edges.equalToSuperview().offset(0)
        }
        
        if let url = URL.init(string: urlStr ?? "") {
            webView.load(URLRequest.init(url: url))

        }
        
    }
    
}

