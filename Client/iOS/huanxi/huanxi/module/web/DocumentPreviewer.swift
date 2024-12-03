//
//  DocumentPreviewer.swift
//  huanxi
//
//  Created by rslz on 2024/12/3.
//

import UIKit
import QuickLook

class DocumentPreviewer: NSObject, QLPreviewControllerDataSource {

    // 单例模式（可选，方便全局使用）
    static let shared = DocumentPreviewer()

    // 文件 URL 列表
    private var fileURLs: [URL] = []

    // 回调：预览完成
    var onPreviewCompletion: (() -> Void)?

    /// 显示文件预览
    /// - Parameters:
    ///   - viewController: 调用方视图控制器，用于展示 `QLPreviewController`
    ///   - filePaths: 文件路径数组（支持本地路径和远程 URL）
    ///   - completion: 可选，预览完成后的回调
    func show(from viewController: UIViewController, filePaths: [String], completion: (() -> Void)? = nil) {
        // 清空文件列表
        fileURLs.removeAll()

        // 转换路径为 URL
        for path in filePaths {
            if let url = URL(string: path), url.isFileURL || url.scheme == "http" {
                fileURLs.append(url)
            } else if FileManager.default.fileExists(atPath: path) {
                fileURLs.append(URL(fileURLWithPath: path))
            } else {
                print("无效路径：\(path)")
            }
        }

        guard !fileURLs.isEmpty else {
            print("没有可预览的文件")
            return
        }

        // 设置回调
        onPreviewCompletion = completion

        // 初始化并展示 QLPreviewController
        let previewController = HxQLPreviewController()
        previewController.dataSource = self
        if let navigationController = viewController.navigationController {
            navigationController.pushViewController(previewController, animated: true)
        } else {
            let nav = NavigationController(rootViewController: previewController)
            viewController.present(nav, animated: true, completion: nil)
        }
    }

    // MARK: - QLPreviewControllerDataSource

    func numberOfPreviewItems(in controller: QLPreviewController) -> Int {
        return fileURLs.count
    }

    func previewController(_ controller: QLPreviewController, previewItemAt index: Int) -> QLPreviewItem {
        return fileURLs[index] as QLPreviewItem
    }

    // MARK: - Optional QLPreviewController Delegate (扩展功能)

    func previewControllerDidDismiss(_ controller: QLPreviewController) {
        // 调用回调
        onPreviewCompletion?()
    }
}
