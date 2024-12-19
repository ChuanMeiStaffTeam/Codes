//
//  SearchSugHeaderView.swift
//  huanxi
//
//  Created by rslz on 2024/12/19.
//

import Foundation
import UIKit

class SearchSugHeaderView: UIView {

    let textField: UITextField = {
        let view = UITextField.init(frame: CGRect.zero)
        view.placeholder = "搜索"
        view.setPlaceholderColor(.lightGray)
        view.layer.cornerRadius = 8
        view.layer.masksToBounds = true
        view.backgroundColor = .init(hex: 0x171717)
        view.returnKeyType = .send
        view.textColor = .white
        view.font = .systemFont(ofSize: 16, weight: .medium)
        view.leftView = UIView(frame: CGRect.init(x: 0, y: 0, width: 12, height: 32))
        view.leftViewMode = .always
        return view
    }()
    
    let cancleButton: UIButton = {
        let button = UIButton()
        button.setTitle("取消", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = true
        
        // 配置按钮的样式
        var config = UIButton.Configuration.plain()
        config.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 12, bottom: 0, trailing: 12)
        button.configuration = config
        return button
    }()
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    func setupView() {
        
        backgroundColor = .black
        
        addSubview(cancleButton)
        cancleButton.snp.makeConstraints { make in
            make.top.equalTo(UIDevice.sy_safeDistanceTop)
            make.bottom.equalToSuperview()
            make.trailing.equalToSuperview()
        }
        
        addSubview(textField)
        textField.snp.makeConstraints { make in
            make.centerY.equalTo(cancleButton)
            make.trailing.equalTo(cancleButton.snp.leading)
            make.leading.equalToSuperview().offset(12)
            make.height.equalTo(32)
            make.width.greaterThanOrEqualTo(100)
        }
    }
}
