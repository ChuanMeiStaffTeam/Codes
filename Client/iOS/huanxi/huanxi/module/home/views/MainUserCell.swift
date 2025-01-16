//
//  MainUserCell.swift
//  huanxi
//
//  Created by jack on 2024/2/28.
//

import UIKit

class MainUserCell: UITableViewCell {
    
    var model: MainUserModel? {
        didSet {
            
        }
    }
    
    let userView = MainUserView(frame: CGRect.init(x: 0, y: 0, width: .screenWidth, height: 100))
    
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
        contentView.addSubview(userView)
    }
    
}
