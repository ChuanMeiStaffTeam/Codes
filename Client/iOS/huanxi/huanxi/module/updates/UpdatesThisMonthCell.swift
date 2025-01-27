//
//  UpdatesThisMonthCell.swift
//  huanxi
//
//  Created by jack on 2024/3/28.
//

import UIKit

class UpdatesThisMonthCell: UITableViewCell {
    
    var followBlock: (()->Void)?
    
    let icon = UIImageView()
    let contentLabel = UILabel()
    let timeLabel = UILabel()
    let followBtn = UIButton(type: .custom)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupView()
        reloadData()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func reloadData() {
        icon.image = UIImage.init(named: "main_recommend_text")
        contentLabel.text = "jeffreywongvb开始关注你了哦"
        timeLabel.text = "4周"
        followBtn.setTitle("已关注", for: .normal)
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
            make.left.equalTo(icon.snp.right).offset(16);
        }
        
        timeLabel.textColor = .init(hexString: "#777777")
        timeLabel.font = .systemFont(ofSize: 14)
        contentView.addSubview(timeLabel)
        timeLabel.snp.makeConstraints { make in
            make.bottom.equalTo(icon.snp.bottom).offset(0)
            make.left.equalTo(icon.snp.right).offset(16);
        }
        
        followBtn.setTitleColor(.white, for: .normal)
        followBtn.titleLabel?.font = .systemFont(ofSize: 14)
        followBtn.layer.cornerRadius = 4
        followBtn.layer.masksToBounds = true
        followBtn.layer.borderWidth = 1
        followBtn.addTarget(self, action: #selector(followAction), for: .touchUpInside)
        followBtn.layer.borderColor = UIColor.init(hexString: "#333333").cgColor
        contentView.addSubview(followBtn)
        followBtn.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-16)
            make.centerY.equalToSuperview().offset(0)
            make.height.equalTo(28)
            make.width.equalTo(followBtn.intrinsicContentSize.width+30)
        }
        
    }
    
    @objc func followAction() {
        if let block = followBlock {
            block()
        }
    }
    
}

/*代码功能：

这段代码定义了一个自定义的 UITableViewCell，名为 UpdatesThisMonthCell，主要用于展示本月内的更新信息。它通常会出现在社交媒体应用的动态列表中，显示用户最近的活动或关注的其他用户的一些动态。

主要功能点：

UI 布局: 使用 SnapKit 对 cell 内部的子视图（头像、内容文本、时间文本、关注按钮）进行布局，使其在不同屏幕尺寸下都能保持良好的显示效果。
数据展示: 通过 reloadData 方法设置 cell 的内容，包括头像图片、更新内容、更新时间以及关注按钮的状态。
交互功能: 提供了一个 followBtn 按钮，用户点击后可以触发 followBlock 回调，实现关注或取消关注的功能。
代码结构：

类名: UpdatesThisMonthCell，明确表示这个类用于展示本月内的更新。
属性:
followBlock: 一个闭包，用于在点击关注按钮时执行自定义操作。
icon: 用于显示头像的 UIImageView。
contentLabel: 用于显示更新内容的 UILabel。
timeLabel: 用于显示更新时间的 UILabel。
followBtn: 用于关注或取消关注的 UIButton。
方法:
init(style:reuseIdentifier:): 初始化方法，设置 cell 的样式和重用标识符。
reloadData：更新 cell 的内容，包括头像、内容和时间。
setupView: 配置 cell 的子视图，设置约束和样式。
followAction: 关注按钮的点击事件处理函数，触发 followBlock 回调。
代码逻辑:

初始化: 创建 cell 时，会调用 setupView 方法来设置子视图的布局和样式。
更新数据: 当需要显示新的数据时，调用 reloadData 方法更新 cell 的内容。
显示内容: cell 的内容包括头像、更新内容、更新时间和关注按钮，这些信息通过 icon, contentLabel, timeLabel 和 followBtn 显示。
用户交互: 点击关注按钮时，会触发 followBlock 回调，可以实现关注或取消关注的功能。
潜在改进:

数据源: 当前代码中，reloadData 方法直接硬编码了数据。在实际应用中，应该通过数据源来动态设置 cell 的内容。
自定义样式: 可以提供更多的自定义选项，比如允许用户自定义 cell 的外观。
性能优化: 如果有大量的数据需要展示，可以考虑使用异步加载图片、复用 cell 等方式来优化性能。
可访问性: 考虑为视障用户提供更好的访问性，比如使用语义化的标签和设置适当的对比度。*/
