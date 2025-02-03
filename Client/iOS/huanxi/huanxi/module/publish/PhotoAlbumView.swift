//
//  PhotoAlbumView.swift
//  huanxi
//
//  Created by jack on 2024/3/2.
//

import UIKit
import Photos

protocol PhotoAlbumViewDelegate: AnyObject {
    func didSelectImages(at indexs: [Int], isSelected: Bool)
}

class PhotoAlbumView: UIView {
    
    var images: [UIImage] = [] {
        didSet {
            collectionView.reloadData()
        }
    }
    
    var selectedAlbumIndexs: [Int] = []
    var currentPhotoIndex = 0
    
    weak var delegate: PhotoAlbumViewDelegate?
    
    private var isMultiSelectEnabled: Bool = false
    
    private let cellIdentifier = "PhotoCell"
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 1
        layout.minimumLineSpacing = 1
        layout.scrollDirection = .vertical
        let cellWidth = (UIScreen.main.bounds.width - 3) / 4
        layout.itemSize = CGSize(width: cellWidth, height: cellWidth)
        
        let collectionView = UICollectionView(frame: bounds, collectionViewLayout: layout)
        collectionView.backgroundColor = .black
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(PhotoCell.self, forCellWithReuseIdentifier: cellIdentifier)
        
        return collectionView
    }()
    
    init() {
        super.init(frame: .zero)
        
        addSubview(collectionView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func toggleMultiSelect(enabled: Bool) {
        if !enabled {
            while selectedAlbumIndexs.count > 1 {
                selectedAlbumIndexs.removeFirst()
            }
        }
        isMultiSelectEnabled = enabled
        delegate?.didSelectImages(at: selectedAlbumIndexs, isSelected: true)
        collectionView.reloadData()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        collectionView.frame = bounds
    }
}

extension PhotoAlbumView: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! PhotoCell
        let image = images[indexPath.item]
        cell.indexPath = indexPath
        cell.imgView.image = image
        cell.isMultiSelectEnabled = isMultiSelectEnabled
        cell._isSelected = currentPhotoIndex == indexPath.row
        if let index = selectedAlbumIndexs.firstIndex(of: indexPath.row) {
            cell.selectedIndex = index
        } else {
            cell.selectedIndex = -1
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        var isSelected = false
        if isMultiSelectEnabled {
            if selectedAlbumIndexs.contains(indexPath.row) {
                if selectedAlbumIndexs.count == 1 {
                    currentPhotoIndex = selectedAlbumIndexs.last ?? 0
                    selectedAlbumIndexs.removeAll { $0 == indexPath.row }
                } else {
                    selectedAlbumIndexs.removeAll { $0 == indexPath.row }
                    currentPhotoIndex = selectedAlbumIndexs.last ?? 0
                }
            } else {
                selectedAlbumIndexs.append(indexPath.row)
                isSelected = true
                currentPhotoIndex = selectedAlbumIndexs.last ?? 0
            }
        } else {
            selectedAlbumIndexs.removeAll()
            selectedAlbumIndexs.append(indexPath.row)
            isSelected = true
            currentPhotoIndex = selectedAlbumIndexs.last ?? 0
        }
        
        
        collectionView.reloadData()
        delegate?.didSelectImages(at: selectedAlbumIndexs, isSelected: isSelected)
    }
}


class PhotoCell: UICollectionViewCell {
    
    var isMultiSelectEnabled: Bool = false {
        didSet {
            selectionView.isHidden = !isMultiSelectEnabled
            if !isMultiSelectEnabled {
                selectionLabel.isHidden = true
            }
        }
    }
    
    var indexPath: IndexPath?
        
    var _isSelected: Bool = false
    var selectedIndex: Int = -1
    
    let imgView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    let currentMaskView: UIView = {
        let currentMaskView = UIView()
        currentMaskView.isHidden = true
        currentMaskView.backgroundColor = .init(white: 1, alpha: 0.2)
        return currentMaskView
    }()
    
    private let selectionView: UIImageView = {
        let selectionView = UIImageView()
        return selectionView
    }()
    
    private let selectionLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 12)
        label.backgroundColor = .init(hexString: "#009DFF")
        label.layer.cornerRadius = 8
        label.layer.masksToBounds = true
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        
        contentView.addSubview(imgView)
        contentView.addSubview(currentMaskView)
        contentView.addSubview(selectionLabel)
        contentView.addSubview(selectionView)
        
        selectionView.isHidden = true
        selectionView.image = UIImage(named: "publish_pic_unselectes")
        
        selectionLabel.isHidden = true
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        imgView.frame = contentView.bounds
        currentMaskView.frame = contentView.bounds
        selectionView.frame = CGRect(x: contentView.bounds.width - 22.5, y: 1.5, width: 21, height: 21)
        selectionLabel.frame = CGRect(x: contentView.bounds.width - 20, y: 4, width: 16, height: 16)
        
        toggleSelection()
        currentMaskView.isHidden = !_isSelected
        
    }
    
    func toggleSelection() {
        guard isMultiSelectEnabled else { return }
        
        selectionLabel.isHidden = selectedIndex < 0
        selectionLabel.text = String(selectedIndex+1)
    }
    
}


/*PhotoAlbumView

目的:

该类负责在网格视图中显示图像集合。
它使用 UICollectionView 管理图像的显示。
它处理用户交互，例如选择和取消选择图像。
它将选择更改通知给委托对象。
关键特征:

images: 要显示的 UIImage 对象数组。
selectedAlbumIndexs: 表示所选图像索引的整数数组。
currentPhotoIndex: 当前所选图像的索引。
isMultiSelectEnabled: 一个布尔标志，用于启用或禁用多图像选择。
collectionView: 用于显示图像的 UICollectionView 实例。
delegate: 对符合 PhotoAlbumViewDelegate 协议的对象的弱引用，在选择更改时收到通知。
核心功能:

toggleMultiSelect(enabled:): 启用或禁用多图像选择，更新 UI 并通知委托。
collectionView(_:numberOfItemsInSection:): 返回要在集合视图中显示的图像数量。
collectionView(_:cellForItemAt:): 为每个图像创建和配置一个 PhotoCell，根据图像数据、选择状态和多选模式设置其属性。
collectionView(_:didSelectItemAt:): 处理图像的选择或取消选择。更新 selectedAlbumIndexs 数组、currentPhotoIndex 并通知委托。
PhotoCell

目的:

该类表示 PhotoAlbumView 显示的 UICollectionView 中的单个单元格。
它显示图像并提供选择视觉提示（例如，复选标记）。
关键特征:

isMultiSelectEnabled: 一个布尔标志，指示是否启用了多图像选择。
indexPath: 单元格在集合视图中的索引路径。
_isSelected: 一个布尔标志，指示单元格当前是否被选中。
selectedIndex: 单元格在所选图像数组中的索引。
imgView: 用于显示图像的 UIImageView。
currentMaskView: 用于突出显示当前选定图像的视图。
selectionView: 用于显示选择指示器的 UIImageView。
selectionLabel: 用于在多选模式下显示所选图像索引的 UILabel。
核心功能:

toggleSelection(): 根据单元格的选择状态和多选模式更新单元格的外观。
关键观察

数据流: PhotoAlbumView 接收图像数组，在 UICollectionView 中显示它们，并管理每个图像的选择状态。当用户选择或取消选择图像时，PhotoAlbumView 更新其内部状态并通知其委托。
设计模式:
委托模式: PhotoAlbumView 使用委托模式将选择更改传达给应用程序的其他部分。
MVC (模型-视图-控制器): PhotoAlbumView 可以被视为视图组件，处理数据呈现和用户交互。
潜在改进:
图像缓存: 实现图像缓存以提高性能，尤其是对于大型数据集。
性能优化: 优化图像加载和解码以避免性能瓶颈。
可访问性: 通过向视图添加可访问性标签和特征来提高可访问性。
自定义: 允许更多自定义选项，例如单元格间距、图像纵横比和选择指示器样式。
中文翻译

PhotoAlbumView

目的:

该类负责在网格视图中显示图像集合。
它使用 UICollectionView 管理图像的显示。
它处理用户交互，例如选择和取消选择图像。
它将选择更改通知给委托对象。
关键特征:

images: 要显示的 UIImage 对象数组。
selectedAlbumIndexs: 表示所选图像索引的整数数组。
currentPhotoIndex: 当前所选图像的索引。
isMultiSelectEnabled: 一个布尔标志，用于启用或禁用多图像选择。
collectionView: 用于显示图像的 UICollectionView 实例。
delegate: 对符合 PhotoAlbumViewDelegate 协议的对象的弱引用，在选择更改时收到通知。
核心功能:

toggleMultiSelect(enabled:): 启用或禁用多图像选择，更新 UI 并通知委托。
collectionView(_:numberOfItemsInSection:): 返回要在集合视图中显示的图像数量。
collectionView(_:cellForItemAt:): 为每个图像创建和配置一个 PhotoCell，根据图像数据、选择状态和多选模式设置其属性。
collectionView(_:didSelectItemAt:): 处理图像的选择或取消选择。更新 selectedAlbumIndexs 数组、currentPhotoIndex 并通知委托。
PhotoCell

目的:

该类表示 PhotoAlbumView 显示的 UICollectionView 中的单个单元格。
它显示图像并提供选择视觉提示（例如，复选标记）。
关键特征:

isMultiSelectEnabled: 一个布尔标志，指示是否启用了多图像选择。
indexPath: 单元格在集合视图中的索引路径。
_isSelected: 一个布尔标志，指示单元格当前是否被选中。
selectedIndex: 单元格在所选图像数组中的索引。
imgView: 用于显示图像的 UIImageView。
currentMaskView: 用于突出显示当前选定图像的视图。
selectionView: 用于显示选择指示器的 UIImageView。
selectionLabel: 用于在多选模式下显示所选图像索引的 UILabel。
核心功能:

toggleSelection(): 根据单元格的选择状态和多选模式更新单元格的外观。
关键观察

数据流: PhotoAlbumView 接收图像数组，在 UICollectionView 中显示它们，并管理每个图像的选择状态。当用户选择或取消选择图像时，PhotoAlbumView 更新其内部状态并通知其委托。
设计模式:
委托模式: PhotoAlbumView 使用委托模式将选择更改传达给应用程序的其他部分。
MVC (模型-视图-控制器): PhotoAlbumView 可以被视为视图组件，处理数据呈现和用户交互。
潜在改进:
图像缓存: 实现图像缓存以提高性能，尤其是对于大型数据集。
性能优化: 优化图像加载和解码以避免性能瓶颈。
可访问性: 通过向视图添加可访问性标签和特征来提高可访问性。
 自定义: 允许更多自定义选项，例如单元格间距、图像纵横比和选择指示器样式。*/
