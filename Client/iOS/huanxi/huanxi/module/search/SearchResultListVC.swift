//
//  SearchResultListVC.swift
//  huanxi
//
//  Created by rslz on 2024/12/23.
//

import UIKit
import SnapKit
import JXSegmentedView

class SearchResultListVC: BaseViewController {
    
    private let viewModel = SearchResultViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        sh_prefersNavigationBarHidden = true
        setupUI()
        bindUI()
    }
    
    func setupUI() {
        
    }
    
    func bindUI() {
        
    }
}

extension SearchResultListVC: JXSegmentedListContainerViewListDelegate {
    func listView() -> UIView {
        return view
    }
}
