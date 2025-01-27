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


/*代码分析：DocumentPreviewer
 功能概述

 这段代码定义了一个名为 DocumentPreviewer 的类，用于管理文档预览功能。它通过 QLPreviewController 提供了一个简单而强大的文档预览解决方案。

 核心功能

 文件路径转换: 将传入的路径字符串转换为 URL 对象，支持本地文件和远程 URL。
 预览控制器初始化: 创建 QLPreviewController 实例，并设置数据源。
 数据源设置: 实现 QLPreviewControllerDataSource 协议，提供预览文件列表。
 预览完成回调: 提供 onPreviewCompletion 回调，在预览完成时执行自定义操作。
 代码解读

 fileURLs 属性: 存储要预览的文件的 URL 列表。
 show 方法:
 将文件路径转换为 URL 并添加到 fileURLs 数组。
 初始化 QLPreviewController 实例，设置数据源。
 根据当前视图控制器是否在导航控制器中，决定是 push 还是 present 预览控制器。
 QLPreviewControllerDataSource 协议:
 numberOfPreviewItems：返回要预览的文件数量。
 previewController(_:previewItemAt:)：返回指定索引的预览项。
 onPreviewCompletion 回调:
 在预览控制器关闭时调用，用于执行自定义操作。
 优点

 封装性好: 将文档预览功能封装成一个类，方便使用。
 灵活: 支持本地文件和远程 URL 的预览。
 可扩展性强: 可以通过自定义 QLPreviewControllerDataSource 实现更复杂的预览功能。
 易用性: 提供了简单的接口，方便调用。
 潜在改进

 错误处理: 可以添加错误处理，例如当文件路径无效或预览失败时，提示用户。
 支持更多文件类型: 可以通过自定义 QLPreviewItem 来支持更多类型的文件。
 自定义外观: 可以通过设置 QLPreviewController 的属性来定制外观。
 进度指示: 对于较大的文件，可以显示加载进度。
 多线程: 对于大量文件的预览，可以考虑使用多线程来提高性能。
*/
