//
//  PrivateViewController.swift
//  huanxi
//
//  Created by jack on 2024/9/13.
//

import UIKit

class PrivateViewController: BaseViewController {
    
    let scrollView = UIScrollView(frame: CGRect.init(x: 0, y: .topBarHeight, width: .screenWidth, height: .screenHeight - .topBarHeight))
    let imageView = UIImageView()

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = false
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
    }
    
    func setupView() {
        title = "隐私政策"
        
        scrollView.bounces = false
        view.addSubview(scrollView)
        
        let image = UIImage.init(named: "private.jpeg")
        let height: CGFloat = .screenWidth / image!.size.width * image!.size.height

        imageView.image = image
        scrollView.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.left.top.equalToSuperview().offset(0)
            make.width.equalTo(CGFloat.screenWidth)
            make.height.equalTo(height)
        }
        
        scrollView.contentSize = CGSize.init(width: .screenWidth, height: height)
        
    }
    
}
