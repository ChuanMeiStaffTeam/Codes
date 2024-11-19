//
//  PostCommentsPopView.swift
//  huanxi
//
//  Created by rslz on 2024/11/11.
//

import Foundation
import Kingfisher
import UIKit

class PostSharePopView: UIView {
    var postModel: PostModel = PostModel(liked: false, collected: false)
    var names: [String] = []
    private let topLine: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.lightGray
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 2
        view.clipsToBounds = true
        return view
    }()

    private let drawerView: DrawerView = {
        let view = DrawerView()
        view.accessibilityIdentifier = "PostSharePopView"
        view.backgroundColor = UIColor.postBgColor
        view.snapPositions = [.closed, .partiallyOpen, .open]
        view.position = .partiallyOpen
        view.partiallyOpenHeight = screenHeight * 3 / 5
        return view
    }()

    private let avatarCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 16
        layout.minimumInteritemSpacing = 16
        layout.sectionInset = UIEdgeInsets(top: 20, left: 16, bottom: 16, right: 16)
        layout.itemSize = CGSize(width: 100, height: 100)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()

    private let loadMoreView: LoadMoreControl = {
        let view = LoadMoreControl(frame: CGRect(x: 0, y: 100, width: screenWidth, height: 50), surplusCount: 10)
        return view
    }()

    let shareOptionsView = ShareOptionsView()

    init() {
        super.init(frame: UIScreen.main.bounds)
        setupUI()
        setupCollectionView()
        setupShareOptions()
        loadData()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        drawerView.delegate = self

        drawerView.addSubview(topLine)
        topLine.snp.makeConstraints { make in
            make.top.equalTo(15)
            make.centerX.equalToSuperview()
            make.height.equalTo(4)
            make.width.equalTo(40)
        }

        // 添加搜索栏
        let searchBar = UISearchBar()
        searchBar.placeholder = "搜索"
        searchBar.delegate = self
        searchBar.backgroundImage = UIImage() // 去除边框
        searchBar.searchTextField.layer.cornerRadius = 10
        searchBar.searchTextField.clipsToBounds = true
        drawerView.addSubview(searchBar)
        searchBar.snp.makeConstraints { make in
            make.top.equalTo(topLine).offset(15)
            make.leading.equalTo(drawerView).offset(10)
            make.trailing.equalTo(drawerView).offset(-10)
            make.height.equalTo(40)
        }

        // 添加头像网格
        drawerView.addSubview(avatarCollectionView)
        avatarCollectionView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom).offset(10)
            make.leading.trailing.equalTo(drawerView)
            make.bottom.equalTo(200)
        }

        loadMoreView.startLoading()
        loadMoreView.onLoad = { [weak self] in
            self?.loadData()
        }
        avatarCollectionView.addSubview(loadMoreView)
    }

    private func setupCollectionView() {
        avatarCollectionView.delegate = self
        avatarCollectionView.dataSource = self
        avatarCollectionView.register(ShareAvatarCell.self, forCellWithReuseIdentifier: ShareAvatarCell.identifier)
    }

    private func setupShareOptions() {
        shareOptionsView.onTap = {
            self.drawerView.isConcealed = true
        }
    }

    func loadData() {
        // 模拟 2 秒的延迟
        DispatchQueue.global().asyncAfter(deadline: .now() + 2.0) {
            // 返回主线程更新 UI 或处理结果
            let temp = ["你的快拍", "zixuanooo", "diza", "dnsk", "jack", "rose"]
            DispatchQueue.main.async {
                self.names.append(contentsOf: temp)
                CATransaction.begin()
                CATransaction.setDisableActions(true)
                self.avatarCollectionView.reloadData()
                CATransaction.commit()
                self.loadMoreView.endLoading()
//                if response.has_more == 0 {
                self.loadMoreView.loadingAll()
//                }
            }
        }
    }

    func show(_ postModel: PostModel) {
        self.postModel = postModel
        if let window = getKeyWindow() {
            drawerView.attachTo(view: window)
            DispatchQueue.global().asyncAfter(deadline: .now() + .microseconds(500)) {
                DispatchQueue.main.async {
                    self.shareOptionsView.show()
                }
            }
        }
    }
}

extension PostSharePopView: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100, height: 100)
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return names.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ShareAvatarCell.identifier, for: indexPath) as! ShareAvatarCell
        cell.label.text = names[indexPath.row]
        let nameStr = "avatar_test_" + String(indexPath.row)
        cell.imageView.image = UIImage(named: nameStr)
        return cell
    }
}

extension PostSharePopView: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        print("开始输入")
        // 在这里处理开始输入的事件，例如显示取消按钮
        searchBar.showsCancelButton = true

        drawerView.position = .open
    }

    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        print("结束输入")
        // 在这里处理开始输入的事件，例如显示取消按钮
        searchBar.showsCancelButton = false

        drawerView.position = .partiallyOpen

        searchBar.resignFirstResponder()
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        print("取消输入")
        // 在这里处理开始输入的事件，例如显示取消按钮
        searchBar.showsCancelButton = false

        drawerView.position = .partiallyOpen

        searchBar.resignFirstResponder()
    }
}

extension PostSharePopView: DrawerViewDelegate {
    func drawerDidMove(_ drawerView: DrawerView, drawerOffset: CGFloat) {
    }

    func drawer(_ drawerView: DrawerView, didTransitionTo position: DrawerPosition) {
    }

    func drawer(_ drawerView: DrawerView, willTransitionFrom startPosition: DrawerPosition, to targetPosition: DrawerPosition) {
        if targetPosition == .closed {
            removeFromSuperview()
            shareOptionsView.dismiss()
        }
    }
}

class ShareAvatarCell: UICollectionViewCell {
    static let identifier = "ShareAvatarCell" // 标识符，用于复用
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "main_snapshot")
        imageView.layer.cornerRadius = 32.5
        imageView.layer.masksToBounds = true
        return imageView
    }()

    let label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.white
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        label.text = "用户名"
        label.textAlignment = .center
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        contentView.addSubview(imageView)
        contentView.addSubview(label)

        imageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview().offset(0)
            make.top.equalToSuperview().offset(5)
            make.width.height.equalTo(65)
        }

        label.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-5)
            make.centerX.equalToSuperview().offset(0)
            make.height.equalTo(12)
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class ShareOptionsView: UIView {
    var onTap: (() -> Void)?
    let shareItemWidth = 68
    let shareItems = [
        ["icon_share_s", "分享到...", ShartType.none],
        ["icon_share_copy", "复制链接", ShartType.copy],
        ["icon_share_wx", "微信", ShartType.wx],
        ["icon_share_qq", "QQ", ShartType.qq],
//        ["icon_share_facebook", "Facebook", ShartType.facebook],
//        ["icon_share_ins", "instagram", ShartType.ins],
//        ["icon_share_whatsapp", "WhatsApp", ShartType.whatsapp],
    ]
    let shareOptionsScrollView = UIScrollView()

    init() {
        super.init(frame: UIScreen.main.bounds)
        initSubView()
    }

    func initSubView() {
        frame = UIScreen.main.bounds
        backgroundColor = .clear

        shareOptionsScrollView.contentSize = CGSize(width: shareItemWidth * shareItems.count, height: 80)
        shareOptionsScrollView.showsHorizontalScrollIndicator = false
        shareOptionsScrollView.backgroundColor = UIColor.postBgColor
        shareOptionsScrollView.contentInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 30)
        addSubview(shareOptionsScrollView)

        for index in 0 ..< shareItems.count {
            let item = ShareItem(frame: CGRect(x: 20 + shareItemWidth * index, y: 0, width: 48, height: 90))
            let image = UIImage(named: shareItems[index][0] as! String)
            item.icon.image = image?.withPadding(UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10))
            item.label.text = shareItems[index][1] as? String
            item.tag = (shareItems[index][2] as! ShartType).rawValue + 100
            item.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onActionItemTap(sender:))))
            item.startAnimation(delayTime: TimeInterval(Double(index) * 0.03))
            shareOptionsScrollView.addSubview(item)
        }
        shareOptionsScrollView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview().offset(-25)
            make.height.equalTo(90)
        }
    }

    @objc func onActionItemTap(sender: UITapGestureRecognizer) {
        var shartType = ShartType.none
        if let type = ShartType(rawValue: (sender.view?.tag ?? 0) - 100) {
            shartType = type
        }
        switch shartType {
        case .none:
            systemShareAction()
            break
        case .copy:
            let textToCopy = "Hello, world!"
            UIPasteboard.general.string = textToCopy
            HUDHelper.showToast("已经复制到剪切板～")
            break
        default:
            break
        }

//        dismiss()
//        if let block = onTap {
//            block()
//        }
    }

    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let hitView = super.hitTest(point, with: event)
        if hitView == self {
            if hitView?.backgroundColor == .clear {
                return nil
            }
        }
        return hitView
    }

    func show() {
        if let window = getKeyWindow() {
            window.addSubview(self)
        }
    }

    func dismiss() {
        removeFromSuperview()
    }

    // 系统分享
    @objc func systemShareAction() {
        // 要分享的内容
        let textToShare = "这是一个示例文本。"
        let urlToShare = URL(string: "https://www.example.com")!
        let imageToShare = UIImage(named: "exampleImage") // 确保图片已添加到项目中

        // 将内容放入一个数组
        let itemsToShare: [Any] = [textToShare, urlToShare, imageToShare as Any]

        // 创建UIActivityViewController
        let activityViewController = UIActivityViewController(activityItems: itemsToShare, applicationActivities: nil)

        // 对于iPad设备，需要指定一个弹出位置
        if let popoverController = activityViewController.popoverPresentationController {
            popoverController.sourceView = self
            popoverController.sourceRect = CGRect(x: bounds.midX, y: bounds.midY, width: 0, height: 0)
            popoverController.permittedArrowDirections = []
        }

        if let vc = getKeyWindow()?.rootViewController {
            vc.present(activityViewController, animated: true, completion: nil)
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class ShareItem: UIView {
    var icon = UIImageView()
    var label = UILabel()
    init() {
        super.init(frame: .zero)
        initSubView()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        initSubView()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func initSubView() {
        icon.backgroundColor = .gray.withAlphaComponent(0.1)
        icon.layer.cornerRadius = 24
        icon.isUserInteractionEnabled = true
        addSubview(icon)

        label.text = "TEXT"
        label.textColor = UIColor.white_60
        label.font = UIFont.systemFont(ofSize: 13)
        label.textAlignment = .center
        addSubview(label)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        icon.snp.makeConstraints { make in
            make.width.height.equalTo(48)
            make.centerX.equalTo(self)
            make.top.equalTo(self).offset(10)
        }
        label.snp.makeConstraints { make in
            make.centerX.equalTo(self)
            make.top.equalTo(self.icon.snp.bottom).offset(10)
        }
    }

    func startAnimation(delayTime: TimeInterval) {
        let originalFrame = frame
        frame = CGRect(origin: CGPoint(x: originalFrame.minX, y: 35), size: originalFrame.size)
        UIView.animate(withDuration: 0.6, delay: delayTime, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.0, options: .curveEaseInOut, animations: {
            self.frame = originalFrame
        }) { _ in
        }
    }
}
