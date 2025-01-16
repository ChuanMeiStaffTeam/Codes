//
//  PostMorePopView.swift
//  huanxi
//
//  Created by rslz on 2024/12/17.
//

import Foundation
import Kingfisher
import RxCocoa
import RxSwift
import UIKit

class PostMorePopView: BaseView {
    var postModel: PostModel = PostModel(liked: false)

    var onDeleteTap: (()->Void)?
    var onBriefTap: (()->Void)?

    
    private let topLine: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.lightGray
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 2
        view.clipsToBounds = true
        return view
    }()

    private let drawerView: DrawerView = {
        let view = DrawerView()
        view.accessibilityIdentifier = "PostMorePopView"
        view.backgroundColor = UIColor.postBgColor
        view.snapPositions = [.closed, .open]
        view.position = .open
        view.openHeightBehavior = .fixed(height: 150)
        view.cornerRadius = 20
        return view
    }()

    let trashButton: UIButton = {
        let button = UIButton(type: .system)
        button.isHidden = true
        button.contentHorizontalAlignment = .left
        button.setTitle("删除", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.setImage(UIImage(systemName: "trash.circle")?.withRenderingMode(.alwaysOriginal), for: .normal)
        return button
    }()

    let briefcaseButton: UIButton = {
        let button = UIButton(type: .system)
        button.contentHorizontalAlignment = .left
        button.setTitle("查看简介", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.setImage(UIImage(systemName: "briefcase.circle")?.withRenderingMode(.alwaysOriginal), for: .normal)
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
        drawerView.delegate = self

        drawerView.addSubview(topLine)
        topLine.snp.makeConstraints { make in
            make.top.equalTo(15)
            make.centerX.equalToSuperview()
            make.height.equalTo(4)
            make.width.equalTo(40)
        }

        [trashButton, briefcaseButton].forEach({ $0.setImgPosition(postion: .Left, spacing: 10) })

        // 创建 UIStackView
        let stackView = UIStackView(arrangedSubviews: [trashButton, briefcaseButton])
        stackView.axis = .vertical // 纵向排列
        stackView.alignment = .fill // 子视图填充
        stackView.distribution = .fillEqually // 高度平均分配
        stackView.spacing = 16 // 按钮之间的间距
        stackView.isUserInteractionEnabled = true
        
        // 添加 StackView 到视图
        drawerView.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.top.equalTo(topLine.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(15)
        }
    
    }
    
    /*
    private func bindUI() {
        trashButton.rx.tapThrottle().subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            self.drawerView.isConcealed = true
            if let block = self.onDeleteTap {
                  block()
            }
        }).disposed(by: disposeBag)
        
        briefcaseButton.rx.tapThrottle().subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            self.drawerView.isConcealed = true
            if let block = self.onBriefTap {
                  block()
            }
        }).disposed(by: disposeBag)
    }
     */

    @objc func trashButtonTap() {
        self.drawerView.isConcealed = true
        if let block = self.onDeleteTap {
              block()
        }
    }
    
    func show(_ postModel: PostModel) {
        self.postModel = postModel
        if let userInfo = LoginManager.shared.getUserInfo() {
            trashButton.isHidden = postModel.userId != userInfo.userId
        }
        if let window = getKeyWindow() {
            drawerView.attachTo(view: window)
        }
    }
    
    func close() {
        self.drawerView.isConcealed = true
    }
}

extension PostMorePopView: DrawerViewDelegate {
    func drawerDidMove(_ drawerView: DrawerView, drawerOffset: CGFloat) {
    }

    func drawer(_ drawerView: DrawerView, didTransitionTo position: DrawerPosition) {
    }
    func drawer(_ drawerView: DrawerView, willTransitionFrom startPosition: DrawerPosition, to targetPosition: DrawerPosition) {
        if targetPosition == .closed {
        }
    }
}
