//
//  SettingItemCell.swift
//  huanxi
//
//  Created by rslz on 2025/1/10.
//

import UIKit

class SettingItemCell: UITableViewCell {
    
    let bgView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 16, weight: .regular)
        return label
    }()
    
    let subTitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.white_60
        label.font = .systemFont(ofSize: 13, weight: .regular)
        return label
    }()
    
    let arrow: UIImageView = {
        let arrow = UIImageView()
        arrow.image = UIImage.init(named: "publish_arrow")
        return arrow
    }()
    

    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        self.backgroundColor = .clear
        self.contentView.backgroundColor = .clear
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI() {
        contentView.addSubview(bgView)
        bgView.snp.makeConstraints { make in
            make.edges.equalTo(UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
            make.height.equalTo(64)
        }
        
        bgView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(16)
        }
        
        bgView.addSubview(arrow)
        arrow.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-16)
            make.width.height.equalTo(12)
        }
        
        bgView.addSubview(subTitleLabel)
        subTitleLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalTo(arrow.snp.left).offset(-10)
            make.leading.greaterThanOrEqualTo(titleLabel.snp.trailing).offset(20)
        }
        
        let line = UIView()
        line.backgroundColor = UIColor.init(hexString: "#666666")
        bgView.addSubview(line)
        line.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.bottom.equalToSuperview().offset(0)
            make.right.equalToSuperview().offset(0)
            make.height.equalTo(0.5)
        }
    }
    
    var model: SetModel? {
        didSet {
            titleLabel.text = model?.title
            subTitleLabel.text = model?.subTitle
        }
    }
    
}
