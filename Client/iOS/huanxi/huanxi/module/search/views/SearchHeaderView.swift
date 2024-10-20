//
//  SearchHeaderView.swift
//  huanxi
//
//  Created by jack on 2024/6/22.
//

import UIKit

class SearchHeaderView: UIView {
    
    var didClickViewCallBack: (() -> Void)?

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }
    
    func setupView() {
        
        backgroundColor = .black
        
        addSubview(textField)
        textField.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(12)
            make.right.equalToSuperview().offset(-12)
            make.bottom.equalToSuperview().offset(-8)
            make.height.equalTo(32)
        }
        
        let btn = UIButton(type: .custom)
        btn.addTarget(self, action: #selector(clickTextField), for: .touchUpInside)
        addSubview(btn)
        btn.snp.makeConstraints { make in
            make.edges.equalTo(textField).offset(0)
        }
    }
    
    lazy var textField: UITextField = {
        let view = UITextField.init(frame: CGRect.zero)
        view.placeholder = "搜索"
        view.setPlaceholderColor(.lightGray)
        view.layer.cornerRadius = 8
        view.layer.masksToBounds = true
        view.isEnabled = false
        view.backgroundColor = .init(hex: 0x171717)
        view.returnKeyType = .send
        view.textColor = .white
        view.font = .systemFont(ofSize: 16, weight: .medium)
        view.leftView = UIView(frame: CGRect.init(x: 0, y: 0, width: 12, height: 32))
        view.leftViewMode = .always
        return view
    }()
    
    @objc func clickTextField() {
        if let block = didClickViewCallBack {
            block()
        }
    }
    
}
