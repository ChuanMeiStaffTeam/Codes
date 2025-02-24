//
//  MJRefreshExtension.swift
//  huanxi
//
//  Created by rslz on 2025/2/24.
//

import Foundation
import MJRefresh

extension MJRefreshStateHeader {
    func setCustomHeadTitle() {
        self.stateLabel?.isHidden = true
        self.lastUpdatedTimeLabel?.isHidden = true
    }
}

extension MJRefreshAutoStateFooter {
   
    func setCustomNoMoreTitle(_ title: String = "NoMoreData".localized(), _ fontSize: CGFloat = 10.0 ) {
        self.isRefreshingTitleHidden = true
        self.setTitle(title, for: .noMoreData)
        self.setTitle("", for: .idle)
        self.stateLabel?.font = UIFont.systemFont(ofSize: fontSize)
        self.stateLabel?.numberOfLines = 0
        self.stateLabel?.textColor = UIColor.divider
    }
    
    open override func endRefreshingWithNoMoreData() {
        self.alpha = 1
        super.endRefreshingWithNoMoreData()
    }
    
}
