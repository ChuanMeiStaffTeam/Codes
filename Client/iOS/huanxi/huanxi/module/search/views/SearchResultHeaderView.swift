//
//  SearchResultHeaderView.swift
//  huanxi
//
//  Created by jack on 2024/6/23.
//

import UIKit

class SearchResultHeaderView: UIView {
    
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
    
    let backButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage.init(systemName: "chevron.backward")?.withRenderingMode(.alwaysOriginal), for: .normal)
        button.tintColor = .white
        // 配置按钮的样式
        var config = UIButton.Configuration.plain()
        config.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 15)
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
        
        addSubview(backButton)
        backButton.snp.makeConstraints { make in
            make.top.equalTo(UIDevice.sy_safeDistanceTop)
            make.bottom.equalToSuperview()
            make.left.equalToSuperview()
        }
        
        addSubview(textField)
        textField.snp.makeConstraints { make in
            make.centerY.equalTo(backButton)
            make.leading.equalTo(backButton.snp.trailing)
            make.trailing.equalToSuperview().inset(12)
            make.height.equalTo(35)
            make.width.greaterThanOrEqualTo(100)
        }
    }
}
