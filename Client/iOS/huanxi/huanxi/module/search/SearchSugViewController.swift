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
    // 保存上一次的输入内容
    var lastInputText: String = ""
    
    private let popView: SearchSugPopView = {
        let view = SearchSugPopView()
        return view
    }()

    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        // 使 textField 成为第一响应者，弹出键盘
        headerView.textField.becomeFirstResponder()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sh_prefersNavigationBarHidden = true
        setupUI()
        bindUI()
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
            .skip(1)
            .subscribe(onNext: { [weak self] text in
                guard let self = self else { return }
                let trimmedString = text?.trimmingCharacters(in: .whitespacesAndNewlines)
                self.loadData(keyword: trimmedString ?? "")
            })
            .disposed(by: disposeBag)
        headerView.textField.rx.controlEvent(.editingDidEndOnExit)
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                
                // 获取当前输入框中的文本
                let currentText = self.headerView.textField.text ?? ""
                
                let vc = SearchResultContainerVC()
                vc.keyword = currentText
                vc.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(vc, animated: true)
            })
            .disposed(by: disposeBag)
        
        self.viewModel.searchUesrs
            .subscribe(onNext: { [weak self] cellTypes in
                guard let `self` = self else { return }
                guard !cellTypes.isEmpty else { return }
                self.popView.items = cellTypes
            })
            .disposed(by: disposeBag)

        popView.onItemTap = { [weak self] user in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.openUserPage(user)
            }
        }
    }
    
    func keyboardWillHide() {
        // 键盘隐藏时，收回第一响应者
        self.view.endEditing(true)
    }
}

extension SearchSugViewController {
    private func loadData(keyword: String) {
        viewModel.requestSearchUser(keyword: keyword, completion: {success in })
    }
}

extension SearchSugViewController {
    func openUserPage(_ model: UserInfoModel?) {
        let vc = MineViewController()
        let user = LoginManager.shared.getUserInfo()
        vc.type = user?.userId == model?.userId ? .mySelf : MineType.other
        vc.userId = model?.userId ?? 0
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
