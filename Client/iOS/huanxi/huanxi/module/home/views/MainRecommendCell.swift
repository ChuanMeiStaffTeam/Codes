//
//  MainRecommendCell.swift
//  huanxi
//
//  Created by jack on 2024/2/28.
//

import UIKit

class MainRecommendCell: UITableViewCell {
    
    var mainRecommendView: MainRecommendView!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    func setupView() {
        selectionStyle = .none
        backgroundColor = .init(hexString: "#121212")
        
        let titleLabel = UILabel()
        titleLabel.textColor = .white
        titleLabel.font = .systemFont(ofSize: 14)
        titleLabel.text = "为你推荐"
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(15)
            make.height.equalTo(42)
        }
        
        let allBtn = UIButton(type: .custom)
        allBtn.setTitle("显示全部", for: .normal)
        allBtn.setTitleColor(.init(hexString: "#0098FD"), for: .normal)
        allBtn.titleLabel?.font = .systemFont(ofSize: 14)
        allBtn.addTarget(self, action: #selector(allAction), for: .touchUpInside)
        contentView.addSubview(allBtn)
        allBtn.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-15)
            make.height.equalTo(42)
            make.width.equalTo(60)
        }
        
        mainRecommendView = MainRecommendView.init(frame: CGRect.init(x: 0, y: 42, width: .screenWidth, height: 275))
        contentView.addSubview(mainRecommendView)
        
    }
    
    @objc func allAction() {
        HUDHelper.showToast("点击了全部")
    }
    
}
