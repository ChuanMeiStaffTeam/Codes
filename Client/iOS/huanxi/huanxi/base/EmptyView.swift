//
//  EmptyView.swift
//  huanxi
//
//  Created by rslz on 2024/12/20.
//

import UIKit
import Localize_Swift

enum CCEmptyType {
    case noNetwork
    case noData
}

class CCEmptyView: BaseView {

    let showImageView: UIImageView = UIImageView()
    
    let defaultLbl: UILabel = UILabel().then { label in
        label.numberOfLines = 0
        label.textAlignment = .center
        label.textColor = UIColor.white_60
        label.font = UIFont.systemFont(ofSize: 16)
    }
    
    let reloadLbl: UILabel = UILabel().then { label in
        label.numberOfLines = 0
        label.textAlignment = .right
        label.textColor = UIColor.linkColor
        label.font = UIFont.systemFont(ofSize: 16)
        label.text = "Click to refresh".localized()
    }
    
    let reloadImageView: UIImageView = UIImageView(image: UIImage(resource: .iconWebRefresh))
    
    lazy var reloadBtn: UIButton = {
        let button = UIButton()
        button.backgroundColor = .clear
        return button
    }()

    let reloadView = UIView()
    
    lazy var reloadBlock = { () in
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.initUI()
        reloadBtn.rx.tap.subscribe(onNext: { [weak self] _ in
            guard let `self` = self else { return }
            self.reloadBlock()
        }).disposed(by: self.disposeBag)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateType(type: CCEmptyType) {
        switch type {
        case .noNetwork:
            showImageView.image = UIImage(resource: .commonEmpty)
            defaultLbl.text = "Search_No_Wifi".localized()
            reloadView.isHidden = false
        case .noData:
            showImageView.image = UIImage(resource: .commonEmpty)
            defaultLbl.text = "No data".localized()
            reloadView.isHidden = true
        }
    }

    func initUI() {
        [reloadLbl,reloadImageView,reloadBtn].forEach({reloadView.addSubview($0)})
        reloadLbl.snp.makeConstraints { l in
            l.leading.top.bottom.equalToSuperview()
        }
        reloadImageView.snp.makeConstraints { l in
            l.leading.equalTo(reloadLbl.snp.trailing).offset(4)
            l.width.equalTo(17)
            l.height.equalTo(16)
            l.centerY.trailing.equalToSuperview()
        }
        reloadBtn.snp.makeConstraints { l in
            l.edges.equalToSuperview()
        }
        
        let finalStackView = UIStackView(arrangedSubviews: [showImageView,defaultLbl,reloadView]).then { view in
            view.axis = .vertical
            view.spacing = 16.0
            view.alignment = .center
            view.distribution = .equalSpacing
        }
        
        showImageView.snp.makeConstraints { l in
            l.height.equalTo(180)
            l.width.equalTo(226)
        }
        self.addSubview(finalStackView)
        finalStackView.snp.makeConstraints { l in
            l.edges.equalToSuperview()
        }
    }
}

