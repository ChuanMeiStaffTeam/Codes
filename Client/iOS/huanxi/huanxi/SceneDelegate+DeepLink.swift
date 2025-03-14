//
//  SceneDelegate+DeepLink.swift
//  huanxi
//
//  Created by rslz on 2025/3/14.
//

import Foundation

// MARK: - SceneDelegate Deep Link Handling
extension SceneDelegate {
    func handleDeepLink(_ url: URL) {
        debugPrint("Handling Deep Link: \(url.absoluteString)")
    }
}
