//
//  ReportReasonVC.swift
//  huanxi
//
//  Created by rslz on 2025/2/11.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

struct ReportReason: Equatable {
    let id: Int
    let name: String
}

class ReportReasonVC: BaseViewController {
    
    private let reasons: [ReportReason] = [
        ReportReason(id: 0, name: "我不喜欢"),
        ReportReason(id: 1, name: "侵犯权益"),
        ReportReason(id: 2, name: "色情低俗"),
        ReportReason(id: 3, name: "违法犯罪"),
        ReportReason(id: 4, name: "政治敏感"),
        ReportReason(id: 5, name: "违规营销"),
        ReportReason(id: 6, name: "不实信息"),
        ReportReason(id: 7, name: "网络暴力"),
        ReportReason(id: 8, name: "危害人身安全"),
        ReportReason(id: 9, name: "未成年人相关"),
        ReportReason(id: 10, name: "AI生成内容问题"),
        ReportReason(id: 11, name: "反馈不规范表达问题")
    ]
    
    private let viewModel = ReportReasonViewModel()
    private let selectedReasonSubject = BehaviorSubject<ReportReason?>(value: nil)
    // 用于存储登录结果的 continuation
    private var reportContinuation: CheckedContinuation<Bool, Never>?
    
    // Create tableView using SnapKit
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(ReportReasonCell.self)
        return tableView
    }()
    

    private let nextButton = UIButton().then({view in
        view.setTitle("提交", for: .normal)
        view.backgroundColor = .mainBlueColor.withAlphaComponent(0.5)
        view.layer.cornerRadius = 6
        view.isEnabled = false
    })
    
    var postItem: PostModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindUI()
    }
    
//    override func onBackTap() {
//        super.onBackTap()
//        self.reportContinuation?.resume(returning: false)
//    }
    
    private func setupUI() {

        self.view.addSubview(nextButton)
        // Set constraints for nextButton using SnapKit
        nextButton.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            make.bottom.equalToSuperview().offset(-UIDevice.sy_safeDistanceBottom)
            make.height.equalTo(45)
        }
        
        // Add tableView and nextButton to the view
        self.view.addSubview(tableView)
        // Set constraints for tableView using SnapKit
        tableView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.bottom.equalTo(nextButton.snp.top).offset(-10)
        }

    }
    
    private func bindUI() {
        Observable.just(reasons)
            .bind(to: tableView.rx.items(cellIdentifier: ReportReasonCell.defaultReuseIdentifier, cellType: ReportReasonCell.self)) { [weak self] (row, reason, cell) in
                cell.reason = reason
                cell.checkButton.isSelected = (try? self?.selectedReasonSubject.value()) == reason
                cell.checkButton.rx.tap
                    .subscribe(onNext: { [weak self] in
                        let isSelected = !cell.checkButton.isSelected
                        cell.checkButton.isSelected = isSelected
                        self?.selectedReasonSubject.onNext(isSelected ? reason : nil)
                    })
                    .disposed(by: cell.disposeBag)
            }
            .disposed(by: disposeBag)
        
        selectedReasonSubject
            .map { $0 != nil }
            .bind(to: nextButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        selectedReasonSubject
            .map { $0 != nil }
            .map { $0 ? .mainBlueColor : .mainBlueColor.withAlphaComponent(0.5) }
            .bind(to: nextButton.rx.backgroundColor)
            .disposed(by: disposeBag)
        
        
        nextButton.rx.tapThrottle()
            .withLatestFrom(selectedReasonSubject)
            .compactMap { $0 }
            .subscribe(onNext: { [weak self] reason in
                guard let `self` = self else { return }
                self.triggerNetworkRequest(for: reason)
            })
            .disposed(by: disposeBag)
            
    }
    
    func triggerNetworkRequest(for reason: ReportReason) {
        let params = ["postId" : "\(postItem?.postId ?? 0)", "reportType" : reason.name]
        Task {
            HUDHelper.showHUD()
            let success = await viewModel.fetchReport(params)
            HUDHelper.hideHUD()
            if success {
                self.reportContinuation?.resume(returning: true)
                self.onBackTap()
            }
        }
    }
    
    /// 异步方法，外部调用此方法以等结果
    static func startReportReason(_ post: PostModel) async -> Bool {
        await withCheckedContinuation { continuation in
            // 确保 UI 在主线程上操作
            DispatchQueue.main.async {
                let topVC = WindowHelper.topViewController()
                let reportVC = ReportReasonVC()
                reportVC.reportContinuation = continuation
                reportVC.hidesBottomBarWhenPushed = true
                reportVC.title = "举报理由"
                reportVC.postItem = post
                topVC?.navigationController?.pushViewController(reportVC, animated: true)
            }
        }
    }
}


