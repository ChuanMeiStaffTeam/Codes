//
//  InfiniteCarousel.swift
//  huanxi
//
//  Created by Jack on 2024/6/25.
//

import UIKit

protocol InfiniteCarouselDelegate: AnyObject {
    func carousel(_ carousel: InfiniteCarousel, didScrollToIndex index: Int)
}

class InfiniteCarousel: UIView, UIScrollViewDelegate {
    // 数据源
    private var images: [UIImage] = []
    
    // 视图组件
    private var scrollView: UIScrollView!
    private var pageControl: UIPageControl!
    
    // 定时器
    private var timer: Timer?
    
    // 代理
    weak var delegate: InfiniteCarouselDelegate?
    
    // 当前索引
    private var currentIndex: Int = 0
    
    // 初始化方法
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
    }
    
    // 设置视图
    private func setupViews() {
        // 初始化 UIScrollView
        scrollView = UIScrollView(frame: bounds)
        scrollView.isPagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.delegate = self
        addSubview(scrollView)
        
        // 初始化 UIPageControl
        pageControl = UIPageControl()
        pageControl.currentPageIndicatorTintColor = .black
        pageControl.pageIndicatorTintColor = .lightGray
        addSubview(pageControl)
    }
    
    // 设置图片数组
    func setImages(_ images: [UIImage]) {
        self.images = images
        setupScrollView()
        setupPageControl()
        startTimer()
    }
    
    // 设置 UIScrollView 内容
    private func setupScrollView() {
        for subview in scrollView.subviews {
            subview.removeFromSuperview()
        }
        
        let totalImages = images.count * 3
        scrollView.contentSize = CGSize(width: frame.width * CGFloat(totalImages), height: frame.height)
        
        for i in 0..<totalImages {
            let imageView = UIImageView(frame: CGRect(x: frame.width * CGFloat(i), y: 0, width: frame.width, height: frame.height))
            imageView.image = images[i % images.count]
            scrollView.addSubview(imageView)
        }
        
        scrollView.contentOffset = CGPoint(x: frame.width * CGFloat(images.count), y: 0)
    }
    
    // 设置 UIPageControl
    private func setupPageControl() {
        pageControl.numberOfPages = images.count
        pageControl.currentPage = 0
        pageControl.frame = CGRect(x: 0, y: frame.height - 30, width: frame.width, height: 30)
        bringSubviewToFront(pageControl)
    }
    
    // 启动定时器
    private func startTimer() {
        stopTimer()
        timer = Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(scrollToNext), userInfo: nil, repeats: true)
    }
    
    // 停止定时器
    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    // 滚动到下一个
    @objc private func scrollToNext() {
        let nextOffset = scrollView.contentOffset.x + frame.width
        scrollView.setContentOffset(CGPoint(x: nextOffset, y: 0), animated: true)
    }
    
    // UIScrollViewDelegate 方法
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        updateCurrentIndex()
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        updateCurrentIndex()
    }
    
    private func updateCurrentIndex() {
        let pageWidth = scrollView.frame.width
        let offset = scrollView.contentOffset.x
        let totalImages = images.count
        currentIndex = Int((offset + pageWidth / 2) / pageWidth) % totalImages
        
        // 更新当前页
        pageControl.currentPage = currentIndex % totalImages
        
        // 调整偏移量
        if currentIndex == totalImages * 2 {
            scrollView.contentOffset = CGPoint(x: pageWidth * CGFloat(totalImages), y: 0)
        } else if currentIndex == totalImages - 1 {
            scrollView.contentOffset = CGPoint(x: pageWidth * CGFloat(totalImages * 2 - 1), y: 0)
        }
        
        delegate?.carousel(self, didScrollToIndex: currentIndex % totalImages)
    }
    
    // 移除定时器
    deinit {
        stopTimer()
    }
}
