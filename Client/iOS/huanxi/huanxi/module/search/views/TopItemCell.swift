//
//  TopItemCell.swift
//  huanxi
//
//  Created by jack on 2024/6/23.
//

import UIKit
import SnapKit

class TopItemCell: UICollectionViewCell {
    static let identifier = "TopItemCell"
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .white
        return label
    }()
    
    private let underlineView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(titleLabel)
        contentView.addSubview(underlineView)
        
        titleLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.leading.trailing.equalToSuperview()
        }
        
        underlineView.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.height.equalTo(2)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with title: String, isSelected: Bool) {
        titleLabel.text = title
        underlineView.isHidden = !isSelected
        titleLabel.textColor = isSelected ? .white : .lightGray
        titleLabel.font = UIFont.systemFont(ofSize: 16, weight: (isSelected ? .medium : .regular))
    }
}
