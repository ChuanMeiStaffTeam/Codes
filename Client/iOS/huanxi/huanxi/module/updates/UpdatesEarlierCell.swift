//
//  UpdatesEarlierCell.swift
//  huanxi
//
//  Created by jack on 2024/3/28.
//

import UIKit

class UpdatesEarlierCell: UITableViewCell {
        
    let icon = UIImageView()
    let contentLabel = UILabel()
    let timeLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupView()
        reloadData()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func reloadData() {
        icon.image = UIImage.init(named: "main_pic_test")
        contentLabel.text = "关注 Hannah,hong_longjie 和其他用户，查看他们的照片和视频"
        timeLabel.text = "5周"
    }
    
    func setupView() {
        selectionStyle = .none
        self.backgroundColor = .clear

        icon.layer.cornerRadius = 20
        icon.layer.masksToBounds = true
        contentView.addSubview(icon)
        icon.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.width.height.equalTo(40)
            make.centerY.equalToSuperview().offset(0)
        }
        
        contentLabel.textColor = .white
        contentLabel.font = .boldSystemFont(ofSize: 14)
        contentView.addSubview(contentLabel)
        contentLabel.snp.makeConstraints { make in
            make.top.equalTo(icon.snp.top).offset(0)
            make.left.equalTo(icon.snp.right).offset(16)
            make.right.equalToSuperview().offset(-16)
        }
        
        timeLabel.textColor = .init(hexString: "#777777")
        timeLabel.font = .systemFont(ofSize: 14)
        contentView.addSubview(timeLabel)
        timeLabel.snp.makeConstraints { make in
            make.bottom.equalTo(icon.snp.bottom).offset(0)
            make.left.equalTo(icon.snp.right).offset(16)
        }
        
    }
    
}

/*代码功能：
 
 这段代码定义了一个名为 UpdatesEarlierCell 的自定义 UITableViewCell 类，用于在列表中显示较早的更新信息。它通常用在社交媒体应用中，展示用户一段时间前的活动或信息。

 主要功能点：

 UI 布局: 使用 SnapKit 对 cell 内部的子视图（头像、内容文本、时间文本）进行布局，使其在不同屏幕尺寸下都能保持良好的显示效果。
 数据展示: 通过 reloadData 方法设置 cell 的内容，包括头像图片、更新内容和更新时间。
 自定义外观: 可以通过修改样式属性（如字体颜色、大小、背景色等）来定制 cell 的外观。
 代码结构：

 类名: UpdatesEarlierCell，明确表示这个类用于展示较早的更新。
 属性:
 icon: 用于显示头像的 UIImageView。
 contentLabel: 用于显示更新内容的 UILabel。
 timeLabel: 用于显示更新时间的 UILabel。
 方法:
 init(style:reuseIdentifier:): 初始化方法，设置 cell 的样式和重用标识符。
 reloadData：更新 cell 的内容，包括头像、内容和时间。
 setupView: 配置 cell 的子视图，设置约束和样式。
 代码逻辑:

 初始化: 创建 cell 时，会调用 setupView 方法来设置子视图的布局和样式。
 更新数据: 当需要显示新的数据时，调用 reloadData 方法更新 cell 的内容。
 显示内容: cell 的内容包括头像、更新内容和更新时间，这些信息通过 icon, contentLabel 和 timeLabel 显示。
 潜在改进：

 数据源: 当前代码中，reloadData 方法直接硬编码了数据。在实际应用中，应该通过数据源来动态设置 cell 的内容。
 交互: 可以添加一些交互功能，比如点击头像跳转到用户个人页面，或者点击内容展开更多信息。
 性能优化: 如果有大量的数据需要展示，可以考虑使用异步加载图片、复用 cell 等方式来优化性能。
 可定制性: 可以提供更多的自定义选项，比如允许用户自定义 cell 的外观。*/
