//
//  MainContentCell.swift
//  huanxi
//
//  Created by jack on 2024/2/28.
//

import UIKit

protocol MainContentCellDelegate: AnyObject {
    func didClickMore(_ data: PostModel)
    
    func didClickLike(_ data: PostModel)
    
    func didClickComment(_ data: PostModel)
    
    func didClickShare(_ data: PostModel)
    
    func didClickMark(_ data: PostModel)
}

class MainContentCell: UITableViewCell {
    
    static let identifier = "MainContentCell"  // 标识符，用于复用
    
    weak var delegate: MainContentCellDelegate?
    var postModel: PostModel?
    
    let icon = UIImageView()
    let nameLabel = UILabel()
    let countryLabel = UILabel()
    let moreBtn = UIButton()
    let imgView = UIImageView()
    let likeBtn = UIButton()
    let commentBtn = UIButton()
    let shareBtn = UIButton()
    let markBtn = UIButton()
    let likeNumLabel = UILabel()
    let contentLabel = UILabel()
    let dateLabel = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func configure(post: PostModel){
        postModel = post
        if let urlStr = post.user?.profilePictureUrl {
            icon.image = UIImage.init(named: urlStr)
        }
        nameLabel.text = post.user?.fullName
        if let urlStr = post.images?.first?.imageUrl {
            imgView.image = UIImage.init(named: urlStr)
        }
        countryLabel.text = post.location
        likeNumLabel.text = String(format: "%d次点赞", post.likesCount ?? 0)
        contentLabel.text = post.caption
        dateLabel.text = post.createdAt
    }
    
    func setupView() {
        
        selectionStyle = .none
        backgroundColor = .clear
        
        contentView.addSubview(icon)
        contentView.addSubview(nameLabel)
        contentView.addSubview(countryLabel)
        contentView.addSubview(moreBtn)
        contentView.addSubview(imgView)
        contentView.addSubview(likeBtn)
        contentView.addSubview(commentBtn)
        contentView.addSubview(shareBtn)
        contentView.addSubview(markBtn)
        contentView.addSubview(likeNumLabel)
        contentView.addSubview(contentLabel)
        contentView.addSubview(dateLabel)
        
        icon.image = UIImage.init(named: "main_pic_test")
        icon.layer.cornerRadius = 16
        icon.layer.masksToBounds = true
        icon.snp.makeConstraints { make in
            make.width.height.equalTo(32)
            make.left.equalTo(10)
            make.top.equalTo(10)
        }
        
        nameLabel.textColor = .white
        nameLabel.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        nameLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(8)
            make.left.equalTo(icon.snp.right).offset(10)
        }
        
        countryLabel.textColor = .white
        countryLabel.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        countryLabel.snp.makeConstraints { make in
            make.left.equalTo(icon.snp.right).offset(10)
            make.bottom.equalTo(icon.snp.bottom).offset(0)
        }
        
        moreBtn.setImage(UIImage.init(named: "main_more"), for: .normal)
        moreBtn.addTarget(self, action: #selector(moreAction), for: .touchUpInside)
        moreBtn.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-10)
            make.width.height.equalTo(24)
            make.top.equalToSuperview().offset(14)
        }
        
        imgView.image = UIImage.init(named: "main_pic_test")
        imgView.snp.makeConstraints { make in
            make.left.right.equalToSuperview().offset(0)
            make.top.equalToSuperview().offset(52)
            make.height.equalTo(410)
        }
        
        likeBtn.setImage(UIImage.init(named: "main_like"), for: .normal)
        likeBtn.addTarget(self, action: #selector(likeAction), for: .touchUpInside)
        likeBtn.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(12)
            make.width.height.equalTo(24)
            make.top.equalTo(imgView.snp.bottom).offset(10)
        }
        
        commentBtn.setImage(UIImage.init(named: "main_comment"), for: .normal)
        commentBtn.addTarget(self, action: #selector(commentAction), for: .touchUpInside)
        commentBtn.snp.makeConstraints { make in
            make.left.equalTo(likeBtn.snp.right).offset(16)
            make.width.height.equalTo(24)
            make.top.equalTo(imgView.snp.bottom).offset(10)
        }
        
        shareBtn.setImage(UIImage.init(named: "main_relay"), for: .normal)
        shareBtn.addTarget(self, action: #selector(shareAction), for: .touchUpInside)
        shareBtn.snp.makeConstraints { make in
            make.left.equalTo(commentBtn.snp.right).offset(16)
            make.width.height.equalTo(24)
            make.top.equalTo(imgView.snp.bottom).offset(10)
        }
        
        markBtn.setImage(UIImage.init(named: "main_mark"), for: .normal)
        markBtn.addTarget(self, action: #selector(markAction), for: .touchUpInside)
        markBtn.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-12)
            make.width.height.equalTo(24)
            make.top.equalTo(imgView.snp.bottom).offset(10)
        }
        
        likeNumLabel.textColor = .white
        likeNumLabel.font = .systemFont(ofSize: 14)
        likeNumLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(10)
            make.top.equalTo(markBtn.snp.bottom).offset(16)
        }
        
        contentLabel.textColor = .white
        contentLabel.font = .systemFont(ofSize: 14)
        contentLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(10)
            make.right.equalToSuperview().offset(-10)
            make.height.equalTo(16)
            make.top.equalTo(likeNumLabel.snp.bottom).offset(10)
        }
        
        dateLabel.textColor = .init(white: 1, alpha: 0.5)
        dateLabel.font = .systemFont(ofSize: 14)
        dateLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(10)
            make.bottom.equalToSuperview().offset(-3)
        }
        
    }
    
    
    
    @objc func moreAction() {
        HUDHelper.showToast("点击了更多")
        if let delegate = self.delegate, let model = postModel {
            delegate.didClickMore(model)
        }
    }
    
    @objc func likeAction() {
        if let delegate = self.delegate, let model = postModel {
            delegate.didClickLike(model)
        }
    }
    
    @objc func commentAction() {
        HUDHelper.showToast("点击了评论")
        if let delegate = self.delegate, let model = postModel {
            delegate.didClickComment(model)
        }
    }
    
    @objc func shareAction() {
        HUDHelper.showToast("点击了分享")
        if let delegate = self.delegate, let model = postModel {
            delegate.didClickShare(model)
        }
    }
    
    @objc func markAction() {
        HUDHelper.showToast("点击了标记")
        if let delegate = self.delegate, let model = postModel {
            delegate.didClickMark(model)
        }
    }
    
}

