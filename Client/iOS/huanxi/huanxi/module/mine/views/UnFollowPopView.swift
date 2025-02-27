//
//  UnFollowPopView.swift
//  huanxi
//
//  Created by rslz on 2025/2/27.
//

import Foundation
import Kingfisher
import RxCocoa
import RxSwift
import UIKit


class UnFollowPopView: BaseView {
    
    private let topLine: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.lightGray
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 2
        view.clipsToBounds = true
        return view
    }()
    
    private let titlelabel: UILabel = UILabel().then({view in
        view.textAlignment = .center
        view.textColor = .white
        view.font = UIFont.boldSystemFont(ofSize: 15)
    })

    private let drawerView: DrawerView = {
        let view = DrawerView()
        view.accessibilityIdentifier = "PostMorePopView"
        view.backgroundColor = UIColor.postBgColor
        view.snapPositions = [.closed, .open]
        view.position = .open
        view.openHeightBehavior = .fixed(height: 200)
        view.cornerRadius = 20
        return view
    }()

    
    let reportButton: UIButton = {
        let button = UIButton(type: .system)
        button.contentHorizontalAlignment = .left
        button.setTitle("取关", for: .normal)
        button.setTitleColor(.white, for: .normal)
        return button
    }()

    init() {
        super.init(frame: UIScreen.main.bounds)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {

        drawerView.addSubview(topLine)
        topLine.snp.makeConstraints { make in
            make.top.equalTo(15)
            make.centerX.equalToSuperview()
            make.height.equalTo(4)
            make.width.equalTo(40)
        }

        drawerView.addSubview(titlelabel)
        titlelabel.snp.makeConstraints { make in
            make.top.equalTo(topLine.snp.bottom).offset(5)
            make.centerX.equalToSuperview()
            make.height.equalTo(35)
        }

        // 创建 UIStackView
        let stackView = UIStackView(arrangedSubviews: [reportButton])
        stackView.axis = .vertical // 纵向排列
        stackView.alignment = .fill // 子视图填充
        stackView.distribution = .fillEqually // 高度平均分配
        stackView.spacing = 16 // 按钮之间的间距
        stackView.isUserInteractionEnabled = true
        
        // 添加 StackView 到视图
        drawerView.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.top.equalTo(titlelabel.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(15)
        }
    
    }

    func show(_ title: String?) {
        titlelabel.text = title
        if let window = getKeyWindow() {
            drawerView.attachTo(view: window)
        }
    }
    
    func close() {
        self.drawerView.isConcealed = true
    }
}
