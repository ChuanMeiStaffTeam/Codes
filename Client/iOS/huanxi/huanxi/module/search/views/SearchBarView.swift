//
//  SearchBarView.swift
//  huanxi
//
//  Created by jack on 2024/6/23.
//

import UIKit
import SnapKit

class SearchBarView: UIView, UITextFieldDelegate {
    var onSearch: ((String) -> Void)?
    
    private let searchTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "搜索"
        textField.borderStyle = .roundedRect
        textField.returnKeyType = .search
        return textField
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
    }
    
    private func setupViews() {
        addSubview(searchTextField)
        
        // 使用 SnapKit 设置布局
        searchTextField.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(8)
        }
        
        searchTextField.delegate = self
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if let text = textField.text {
            onSearch?(text)
        }
        return true
    }
}
