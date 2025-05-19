//
//  WaterfallMutiSectionFlowLayout.swift
//
//  Created by LZM on 2024/9/24.
//

import UIKit

@objc protocol WaterfallMutiSectionDelegate: NSObjectProtocol {
  // 必选delegate实现
  /// collectionItem高度
  func heightForRowAtIndexPath(collectionView collection: UICollectionView, layout: WaterfallMutiSectionFlowLayout, indexPath: IndexPath, itemWidth: CGFloat) -> CGFloat
  
  // 可选delegate实现
  /// 每个section 列数（默认2列）
  @objc optional func columnNumber(collectionView collection: UICollectionView, layout: WaterfallMutiSectionFlowLayout, section: Int) -> Int
  
  /// header高度（默认为0）
  @objc optional func referenceSizeForHeader(collectionView collection: UICollectionView, layout: WaterfallMutiSectionFlowLayout, section: Int) -> CGSize
  
  /// footer高度（默认为0）
  @objc optional func referenceSizeForFooter(collectionView collection: UICollectionView, layout: WaterfallMutiSectionFlowLayout, section: Int) -> CGSize
  
  /// 每个section 边距（默认为0）
  @objc optional func insetForSection(collectionView collection: UICollectionView, layout: WaterfallMutiSectionFlowLayout, section: Int) -> UIEdgeInsets
  
  /// 每个section item上下间距（默认为0）
  @objc optional func lineSpacing(collectionView collection: UICollectionView, layout: WaterfallMutiSectionFlowLayout, section: Int) -> CGFloat
  
  /// 每个section item左右间距（默认为0）
  @objc optional func interitemSpacing(collectionView collection: UICollectionView, layout: WaterfallMutiSectionFlowLayout, section: Int) -> CGFloat
  
  /// section头部header与上个section尾部footer间距（默认为0）
  @objc optional func spacingWithLastSection(collectionView collection: UICollectionView, layout: WaterfallMutiSectionFlowLayout, section: Int) -> CGFloat
}

class WaterfallMutiSectionFlowLayout: UICollectionViewFlowLayout {
  weak var delegate: WaterfallMutiSectionDelegate?
  
  private var sectionInsets: UIEdgeInsets = .zero
  private var columnCount: Int = 2
  private var lineSpacing: CGFloat = 0
  private var interitemSpacing: CGFloat = 0
  private var headerSize: CGSize = .zero
  private var footerSize: CGSize = .zero
  
  //存放attribute的数组
  private var attrsArray: [UICollectionViewLayoutAttributes] = []
  //存放每个section中各个列的最后一个高度
  private var columnHeights: [CGFloat] = []
  //collectionView的Content的高度
  private var contentHeight: CGFloat = 0
  //记录上个section高度最高一列的高度
  private var lastContentHeight: CGFloat = 0
  //每个section的header与上个section的footer距离
  private var spacingWithLastSection: CGFloat = 0
  
  
  override func prepare() {
    super.prepare()
    self.contentHeight = 0
    self.lastContentHeight = 0
    self.spacingWithLastSection = 0
    self.lineSpacing = 0
    self.sectionInsets = .zero
    self.headerSize = .zero
    self.footerSize = .zero
    self.columnHeights.removeAll()
    self.attrsArray.removeAll()
    
    let sectionCount = self.collectionView!.numberOfSections
    // 遍历section
    for idx in 0..<sectionCount {
      let indexPath = IndexPath(item: 0, section: idx)
      if let columnCount = self.delegate?.columnNumber?(collectionView: self.collectionView!, layout: self, section: indexPath.section) {
        self.columnCount = columnCount
      }
      if let inset = self.delegate?.insetForSection?(collectionView: self.collectionView!, layout: self, section: indexPath.section) {
        self.sectionInsets = inset
      }
      if let spacingLastSection = self.delegate?.spacingWithLastSection?(collectionView: self.collectionView!, layout: self, section: indexPath.section) {
        self.spacingWithLastSection = spacingLastSection
      }
      // 生成header
      let itemCount = self.collectionView!.numberOfItems(inSection: idx)
      let headerAttri = self.layoutAttributesForSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, at: indexPath)
      if let header = headerAttri {
        self.attrsArray.append(header)
        self.columnHeights.removeAll()
      }
      self.lastContentHeight = self.contentHeight
      // 初始化区 y值
      for _ in 0..<self.columnCount {
        self.columnHeights.append(self.contentHeight)
      }
      // 多少个item
      for item in 0..<itemCount {
        let indexPat = IndexPath(item: item, section: idx)
        let attri = self.layoutAttributesForItem(at: indexPat)
        if let attri = attri {
          self.attrsArray.append(attri)
        }
      }
      
      // 初始化footer
      let footerAttri = self.layoutAttributesForSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter, at: indexPath)
      if let footer = footerAttri {
        self.attrsArray.append(footer)
      }
    }
  }
  
  override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
    return self.attrsArray
  }
  
  override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
    if let column = self.delegate?.columnNumber?(collectionView: self.collectionView!, layout: self, section: indexPath.section) {
      self.columnCount = column
    }
    if let lineSpacing = self.delegate?.lineSpacing?(collectionView: self.collectionView!, layout: self, section: indexPath.section) {
      self.lineSpacing = lineSpacing
    }
    if let interitem = self.delegate?.interitemSpacing?(collectionView: self.collectionView!, layout: self, section: indexPath.section) {
      self.interitemSpacing = interitem
    }
    
    let attri = UICollectionViewLayoutAttributes(forCellWith: indexPath)
    let weight = self.collectionView!.frame.size.width
    let itemSpacing = CGFloat(self.columnCount - 1) * self.interitemSpacing
    let allWeight = weight - self.sectionInsets.left - self.sectionInsets.right - itemSpacing
    let cellWeight = allWeight / CGFloat(self.columnCount)
    let cellHeight: CGFloat = (self.delegate?.heightForRowAtIndexPath(collectionView: self.collectionView!, layout: self, indexPath: indexPath, itemWidth: cellWeight))!
    
    var tmpMinColumn = 0
    var minColumnHeight = self.columnHeights[0]
    for i in 0..<self.columnCount {
      let columnH = self.columnHeights[i]
      if minColumnHeight > columnH {
        minColumnHeight = columnH
        tmpMinColumn = i
      }
    }
    let cellX = self.sectionInsets.left + CGFloat(tmpMinColumn) * (cellWeight + self.interitemSpacing)
    var cellY: CGFloat = 0
    cellY = minColumnHeight
    if cellY != self.lastContentHeight {
      cellY += self.lineSpacing
    }
    
    if self.contentHeight < minColumnHeight {
      self.contentHeight = minColumnHeight
    }
    
    attri.frame = CGRect(x: cellX, y: cellY, width: cellWeight, height: cellHeight)
    self.columnHeights[tmpMinColumn] = attri.frame.maxY
    //取最大的
    for i in 0..<self.columnHeights.count {
      if self.contentHeight < self.columnHeights[i] {
        self.contentHeight = self.columnHeights[i]
      }
    }
    
    return attri
  }
  override func layoutAttributesForSupplementaryView(ofKind elementKind: String, at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
    let attri = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: elementKind, with: indexPath)
    if elementKind == UICollectionView.elementKindSectionHeader {
      if let headerSize = self.delegate?.referenceSizeForHeader?(collectionView: self.collectionView!, layout: self, section: indexPath.section) {
        self.headerSize = headerSize
      }
      self.contentHeight += self.spacingWithLastSection
      attri.frame = CGRect(x: 0, y: self.contentHeight, width: self.headerSize.width, height: self.headerSize.height)
      self.contentHeight += self.headerSize.height
      self.contentHeight += self.sectionInsets.top
    } else if elementKind == UICollectionView.elementKindSectionFooter {
      if let footerSize = self.delegate?.referenceSizeForFooter?(collectionView: self.collectionView!, layout: self, section: indexPath.section) {
        self.footerSize = footerSize
      }
      self.contentHeight += self.sectionInsets.bottom
      attri.frame = CGRect(x: 0, y: self.contentHeight, width: self.footerSize.width, height: self.footerSize.height)
      self.contentHeight += self.footerSize.height
    }
    return attri
  }
  
  override var collectionViewContentSize: CGSize {
    return CGSize(width: self.collectionView!.frame.size.width, height: self.contentHeight)
  }
}


/*代码功能
 
 这段代码实现了一个自定义的 UICollectionViewFlowLayout 子类，名为 WaterfallMutiSectionFlowLayout。它的主要目的是实现瀑布流布局，并且支持多分区、自定义列数、item 间距、分区内边距等功能。

 代码原理

 委托协议: WaterfallMutiSectionDelegate 协议定义了一系列可选的委托方法，用于自定义瀑布流的各种属性，比如列数、item 高度、分区间距等。
 布局属性: attrsArray 数组用于存储所有 item 和 supplementary view（header、footer）的布局属性。
 列高度数组: columnHeights 数组用于记录每一列的当前高度，用于确定下一个 item 的位置。
 内容高度: contentHeight 用于记录整个 collectionView 的内容高度。
 工作流程:

 准备: 在 prepare() 方法中，初始化各种属性，计算列数、内边距等。
 生成布局属性: 遍历所有 item 和 supplementary view，计算每个 item 的 frame，并添加到 attrsArray 中。
 计算列高: 在布局每个 item 时，找到当前高度最小的列，将 item 放置到该列上，并更新该列的高度。
 更新内容高度: 每次布局完一个 item 或 supplementary view 后，更新 contentHeight，以确定 collectionView 的内容大小。
 关键点

 高度灵活: 通过委托方法，可以自定义每个 item 的高度，实现各种复杂的瀑布流布局。
 多分区支持: 支持多个分区，每个分区可以有不同的列数、间距等设置。
 自定义属性: 可以自定义列数、行间距、列间距、分区内边距、header 和 footer 的大小等。
 性能优化: 通过缓存布局属性，提高了布局的效率。
 代码优点

 可扩展性强: 通过委托协议，可以方便地自定义各种布局参数。
 代码结构清晰: 代码结构清晰，易于理解和维护。
 性能良好: 采用了高效的算法，布局性能较好。
 适用场景

 图片瀑布流: 最常见的应用场景，可以实现图片的瀑布流展示。
 列表展示: 可以用来展示各种列表内容，如新闻列表、商品列表等。
 自定义布局: 可以根据不同的需求，自定义瀑布流的布局效果。
*/
