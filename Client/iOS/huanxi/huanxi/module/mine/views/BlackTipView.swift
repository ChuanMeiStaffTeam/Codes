//
//  BlackTipView.swift
//  huanxi
//
//  Created by rslz on 2025/2/27.
//

import Foundation
import UIKit

class BlackTipView: BaseView {

    private let showImageView: UIImageView = UIImageView().then({view in
        view.image = UIImage(systemName: "nosign")?.withRenderingMode(.alwaysOriginal).withTintColor(UIColor.white_50)
    })
    
    private let defaultLbl: UILabel = UILabel().then { label in
        label.numberOfLines = 0
        label.textAlignment = .center
        label.textColor = UIColor.white_50
        label.font = UIFont.systemFont(ofSize: 16)
        label.text = "该用户已被拉黑"
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.initUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    func initUI() {
        
        self.backgroundColor = UIColor.black
        
        let finalStackView = UIStackView(arrangedSubviews: [showImageView,defaultLbl]).then { view in
            view.axis = .vertical
            view.spacing = 16.0
            view.alignment = .center
            view.distribution = .equalSpacing
        }
        
        finalStackView.snp.makeConstraints { make in
            make.height.equalTo(100)
            make.width.equalTo(UIDevice.screenWidth)
        }
        
        showImageView.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.width.equalTo(50)
        }
        self.addSubview(finalStackView)
        finalStackView.snp.makeConstraints { make in
            make.centerY.equalToSuperview().offset(-50)
            make.centerX.equalToSuperview()
        }
    }
}

