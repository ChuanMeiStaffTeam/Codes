//
//  ReportReasonCell.swift
//  huanxi
//
//  Created by rslz on 2025/2/11.
//

import UIKit

class ReportReasonCell: BaseTableViewCell {
    
    var reason: ReportReason? {
        didSet {
            textLabel?.text = reason?.name
        }
    }
    
    // 选择框的按钮
    let checkButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(systemName: "circle")?.withRenderingMode(.alwaysOriginal).withTintColor(.white), for: .normal)  // 默认圆圈
        button.setImage(UIImage(systemName: "checkmark.circle.fill")?.withRenderingMode(.alwaysOriginal).withTintColor(.white), for: .selected)  // 选中时的图标
        return button
    }()

    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        // 配置选择框
        contentView.addSubview(checkButton)
        checkButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            checkButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            checkButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            checkButton.widthAnchor.constraint(equalToConstant: 30),
            checkButton.heightAnchor.constraint(equalToConstant: 30)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
