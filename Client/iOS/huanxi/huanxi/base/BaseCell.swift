//
//  BaseCell.swift
//  huanxi
//
//  Created by rslz on 2025/1/10.
//

import UIKit
import RxSwift

// MARK: - UICollectionViewCell
/// 宽度与屏幕同宽，高度自适应
class EstimatedItemHeightCell: UICollectionViewCell {
    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        self.setNeedsLayout()
        self.layoutIfNeeded()
        let size = self.contentView.systemLayoutSizeFitting(layoutAttributes.size)
        var cellFrame = layoutAttributes.frame
        cellFrame.size.height = size.height
        cellFrame.size.width = UIScreen.main.bounds.width
        layoutAttributes.frame = cellFrame
        return layoutAttributes
    }
}

class BaseCollectionViewCell: UICollectionViewCell {
    var disposeBag = DisposeBag()
}

// MARK: - UITableViewCell
class BaseTableViewCell: UITableViewCell {
    var disposeBag = DisposeBag()
}

