//
//  SearchTagsView.swift
//  huanxi
//
//  Created by jack on 2024/6/22.
//

import UIKit

class SearchTagsView: UIView {
    
    var didSelectedItemCallBack: ((String) -> Void)?
    
    private let scrollView = UIScrollView()
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }
    
    func setupView() {
        
        addSubview(scrollView)
        scrollView.frame = bounds
    }
    
    
    func reloadData(_ items: Array<String>) {
        
        for subview in scrollView.subviews {
            subview.removeFromSuperview()
        }
        
        var totalWidth = 16.0
        for item in items {
            if item.isEmpty {
                break
            }
            let btn = UIButton(type: .custom)
            let width = calculateBtnWidth(text: item)
            btn.frame = CGRect.init(x: totalWidth, y: self.height / 2.0 - 16, width: width, height: 32)
            btn.setTitle(item, for: .normal)
            btn.setTitleColor(.white, for: .normal)
            btn.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
            btn.layer.cornerRadius = 8
            btn.layer.masksToBounds = true
            btn.layer.borderWidth = 0.5
            btn.layer.borderColor = UIColor.white.cgColor
            btn.addTarget(self, action: #selector(clickAction(_ :)), for: .touchUpInside)
            scrollView.addSubview(btn)
            totalWidth = totalWidth + 16 + width
        }
        
        scrollView.contentSize = CGSize.init(width: totalWidth, height: 0)
    }
    
    func calculateBtnWidth(text: String) ->CGFloat {
        if text.isEmpty {
            return 0
        }
        let width = TextSizeCalculator.calculateWidth(for: text,
                                                      with: UIFont.systemFont(ofSize: 15, weight: .semibold),
                                                      fixedHeight: 20)
        return width + 32
    }
    
    @objc func clickAction(_ btn: UIButton) {
        if let callBack = didSelectedItemCallBack, let title = btn.titleLabel?.text {
            callBack(title)
        }
    }
    
}


