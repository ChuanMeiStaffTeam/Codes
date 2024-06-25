//
//  SearchViewController.swift
//  huanxi
//
//  Created by jack on 2024/2/18.
//

import UIKit

class SearchViewController: BaseViewController {
 
    let searchHeaderView = SearchHeaderView(frame: CGRect.init(x: 0, y: 0, width: .screenWidth, height: .topBarHeight))
    let searchTagsView = SearchTagsView(frame: CGRect.init(x: 0, y: .topBarHeight, width: .screenWidth, height: 48))
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        
        searchTagsView.reloadData(["IGTV", "旅游", "设计", "家居", "美食", "景点"])
    }
    
    
    func setupView() {
        
        searchHeaderView.didClickViewCallBack = { [weak self] in
            let vc = SearchResultsViewController()
            vc.hidesBottomBarWhenPushed = true
            self?.navigationController?.pushViewController(vc, animated: true)
        }
        view.addSubview(searchHeaderView)
        
        view.addSubview(searchTagsView)
        searchTagsView.didSelectedItemCallBack = { [weak self] text in
            let vc = SearchTagViewController()
            vc.title = text
            vc.hidesBottomBarWhenPushed = true
            self?.navigationController?.pushViewController(vc, animated: true)
        }
        
        let waterfallView = WaterfallCollectionView(frame: CGRect.init(x: 0, y: searchTagsView.bottom, width: .screenWidth, height: .screenHeight - searchTagsView.bottom - .bottomSafeAreaHeight - .tabBarHeight), numberOfColumns: 3)
        waterfallView.didSelectItemBlock = { [weak self] index in
            let vc = SearchDetailListViewController()
            vc.hidesBottomBarWhenPushed = true
            self?.navigationController?.pushViewController(vc, animated: true)
        }
        view.addSubview(waterfallView)

        // 测试数据
        let images: [String] = ["list_0", "list_1", "list_2", "list_3", "list_4", "list_5", "list_6", "list_7", "list_8", "list_0", "list_1", "list_2", "list_3", "list_4", "list_5", "list_6", "list_7", "list_8","list_0", "list_1", "list_2", "list_3", "list_4", "list_5", "list_6", "list_7", "list_8","list_0", "list_1", "list_2", "list_3", "list_4", "list_5", "list_6", "list_7", "list_8", "list_0", "list_1", "list_2", "list_3", "list_4", "list_5", "list_6", "list_7", "list_8", "list_0", "list_1", "list_2", "list_3", "list_4", "list_5", "list_6", "list_7", "list_8","list_0", "list_1", "list_2", "list_3", "list_4", "list_5", "list_6", "list_7", "list_8","list_0", "list_1", "list_2", "list_3", "list_4", "list_5", "list_6", "list_7", "list_8"]
        var heights: [CGFloat] = []
        for _ in 0..<images.count {
//            colors.append(UIColor(red: .random(in: 0...1), green: .random(in: 0...1), blue: .random(in: 0...1), alpha: 1))
            heights.append(CGFloat.random(in: 100...250))  // 随机高度
        }
        
        waterfallView.setItems(images, heights: heights)
        
    }
    
}
