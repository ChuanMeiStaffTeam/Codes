//
//  CustomAutoFooter.swift
//  OVTC
//
//  Created by rslz on 2025/1/23.
//

import MJRefresh

/*
 ----  没有更多啦  ----
 以上样式的CustomAutoFooter
 */
class CustomAutoFooter: MJRefreshAutoNormalFooter {

    private let stateStackView: UIStackView = UIStackView().then({view in
        view.axis = .horizontal
        view.alignment = .center
        view.distribution = .equalSpacing
    })
    
    private let leftLineView: UIView = UIView().then({view in
        view.backgroundColor = UIColor.divider
        view.isHidden = true
    })
    
    private let rightLineView: UIView = UIView().then({view in
        view.backgroundColor = UIColor.divider
        view.isHidden = true
    })
    
    override func prepare() {
        super.prepare()
        setupUI()
    }
    
    private func setupUI() {
        self.addSubview(leftLineView)
        self.addSubview(rightLineView)
    }
    
    override var state: MJRefreshState {
        set {
            let oldState = state
            if newValue == oldState { return }
            super.state = newValue
            switch state {
            case .noMoreData:
                leftLineView.isHidden = false
                rightLineView.isHidden = false
            default:
                leftLineView.isHidden = true
                rightLineView.isHidden = true
            }
        }
        get {
            super.state
        }
    }

    
    override func placeSubviews() {
        super.placeSubviews()
        stateLabel?.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(16)
            make.centerX.equalToSuperview()
            make.width.lessThanOrEqualTo(UIDevice.screenWidth - UIDevice.screenWidthScale(200))
        }
        if let label = stateLabel {
            leftLineView.snp.makeConstraints { make in
                make.right.equalTo(label.snp.left).offset(-20)
                make.centerY.equalTo(label)
                make.width.equalTo(UIDevice.screenWidthScale(33))
                make.height.equalTo(0.5)
            }
            rightLineView.snp.makeConstraints { make in
                make.left.equalTo(label.snp.right).offset(20)
                make.centerY.width.height.equalTo(leftLineView)
            }
        }
    }
}
