//
//  SearchViewController.swift
//  huanxi
//
//  Created by jack on 2024/2/18.
//

import UIKit

class SearchViewController: BaseViewController {
 
    let searchHeaderView = SearchHeaderView(frame: CGRect.init(x: 0, y: 0, width: .screenWidth, height: .topBarHeight))
    let waterfallView = WaterfallCollectionView(frame: .zero)
        
    private let viewModel = SearchViewModel()


    override func viewDidLoad() {
        super.viewDidLoad()
        sh_prefersNavigationBarHidden = true
        setupUI()
        refrehData()
    }
    
    
    func setupUI() {
        searchHeaderView.didClickViewCallBack = { [weak self] in
            let vc = SearchResultsViewController()
            vc.hidesBottomBarWhenPushed = true
            self?.navigationController?.pushViewController(vc, animated: true)
        }
        view.addSubview(searchHeaderView)
        
        
        waterfallView.didSelectItemBlock = { [weak self] index in
            let vc = SearchDetailListViewController()
            vc.hidesBottomBarWhenPushed = true
            self?.navigationController?.pushViewController(vc, animated: true)
        }
        view.addSubview(waterfallView)
        waterfallView.snp.makeConstraints { make in
            make.top.equalTo(searchHeaderView.snp.bottom).offset(5)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview().inset(UIDevice.sy_tabBarFullHeight)
        }
    }
    
}

extension SearchViewController {
    private func refrehData() {
        viewModel.requestDefaultSearchPosts { [weak self] result in
            guard let self = self else { return }
            if result {
                self.waterfallView.items = self.viewModel.postsList
            }
        }
    }
}



