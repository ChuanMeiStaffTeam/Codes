//
//  ChatTextCell.swift
//  huanxi
//
//  Created by Jack on 2024/6/7.
//

import UIKit

class ChatTextCell: UITableViewCell {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setupView() {
        selectionStyle = .none
        self.backgroundColor = .clear
//        contentView.addSubview(userView)
    }
    
}
