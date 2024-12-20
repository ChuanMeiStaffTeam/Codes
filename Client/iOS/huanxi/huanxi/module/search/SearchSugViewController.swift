//
//  SearchSugViewController.swift
//  huanxi
//
//  Created by rslz on 2024/12/19.
//

import RxSwift
import UIKit

class SearchSugViewController: BaseViewController {
    private let headerView = SearchSugHeaderView()
    private let viewModel = SearchViewModel()

    private let popView: SearchSugPopView = {
        let view = SearchSugPopView()
        view.isHidden = true
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        sh_prefersNavigationBarHidden = true
        setupUI()
        bindUI()

        headerView.textField.becomeFirstResponder()
    }

    func setupUI() {
        view.backgroundColor = .clear
        view.addSubview(headerView)
        headerView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(UIDevice.sy_navigationFullHeight)
        }

        view.addSubview(popView)
        popView.snp.makeConstraints { make in
            make.top.equalTo(headerView.snp.bottom).offset(5)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview().inset(UIDevice.sy_tabBarFullHeight)
        }
    }

    func bindUI() {
        headerView.cancleButton.rx.tapThrottle().subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            self.dismiss(animated: false)
        }).disposed(by: disposeBag)

        headerView.textField.rx.text
            .debounce(.milliseconds(300), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .subscribe(onNext: { [weak self] text in
                guard let self = self else { return }
                let trimmedString = text?.trimmingCharacters(in: .whitespacesAndNewlines)
                let isBlank = trimmedString?.isEmpty ?? true
                self.popView.isHidden = isBlank
                if !isBlank {
                    self.loadData(keyword: trimmedString ?? "")
                }
            })
            .disposed(by: disposeBag)
        headerView.textField.rx.controlEvent(.editingDidEndOnExit)
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                
                // 获取当前输入框中的文本
                let currentText = self.headerView.textField.text ?? ""
                
                let vc = SearchResultsViewController()
                vc.keyword = currentText
                vc.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(vc, animated: true)
            })
            .disposed(by: disposeBag)
        
        self.viewModel.searchUesrs
            .subscribe(onNext: { [weak self] cellTypes in
                guard let `self` = self else { return }
                self.popView.items = cellTypes
            })
            .disposed(by: disposeBag)

        popView.onItemTap = { [weak self] user in
            guard let self = self else { return }
            DispatchQueue.main.async {
                let vc = UserBriefVC()
                vc.user = user
                vc.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
}

extension SearchSugViewController {
    private func loadData(keyword: String) {
        viewModel.requestSearchUser(keyword: keyword, completion: { [weak self] success in
            
        })
    }
}
