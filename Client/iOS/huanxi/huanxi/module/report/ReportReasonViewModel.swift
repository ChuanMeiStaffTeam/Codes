//
//  ReportReasonViewModel.swift
//  huanxi
//
//  Created by rslz on 2025/2/11.
//

import UIKit
import RxRelay

class ReportReasonViewModel {
    
    func fetchReport(_ params: [String: Any]) async -> Bool {
        await withCheckedContinuation { continuation in
            NetworkManager.shared.postRequest(
                path: "reports/repost",
                parameters: params,
                responseType: String.self
            ) { success, message, data in
                if success {
                } else {
                    HUDHelper.showToast(message)
                }
                continuation.resume(returning: success)
            }
        }
    }
}
