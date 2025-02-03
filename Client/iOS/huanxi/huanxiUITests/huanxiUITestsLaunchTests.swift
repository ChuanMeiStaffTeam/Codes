//
//  huanxiUITestsLaunchTests.swift
//  huanxiUITests
//
//  Created by jack on 2024/2/18.
//

import XCTest

class huanxiUITestsLaunchTests: XCTestCase {

    override class var runsForEachTargetApplicationUIConfiguration: Bool {
        true
    }

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    func testLaunch() throws {
        let app = XCUIApplication()
        app.launch()

        // Insert steps here to perform after app launch but before taking a screenshot,
        // such as logging into a test account or navigating somewhere in the app

        let attachment = XCTAttachment(screenshot: app.screenshot())
        attachment.name = "Launch Screen"
        attachment.lifetime = .keepAlways
        add(attachment)
    }
}

/*代码功能
 
 这段代码主要用于在 iOS 应用程序启动时进行 UI 测试，并捕获启动屏幕的截图。

 代码解析

 huanxiUITestsLaunchTests 类：

 继承自 XCTestCase，表示这是一个用于 UI 测试的类。
 这个类专门用于测试应用程序的启动过程，并捕获启动屏幕的截图。
 runsForEachTargetApplicationUIConfiguration 属性：

 这个属性设置为 true，表示对于应用程序的每个 UI 配置（比如浅色模式、深色模式），都会执行一次测试。这样可以确保在不同的 UI 配置下，启动屏幕显示正常。
 setUpWithError() 方法：

 在每个测试方法执行之前调用。
 设置 continueAfterFailure = false，表示如果某个测试用例失败，则停止执行后续的测试用例。
 testLaunch() 方法：

 这个方法是主要的测试方法，用于启动应用程序并捕获启动屏幕截图。
 let app = XCUIApplication()：创建一个 XCUIApplication 对象，表示要测试的应用程序。
 app.launch()：启动应用程序。
 let attachment = XCTAttachment(screenshot: app.screenshot())：获取应用程序当前屏幕的截图，并创建一个 XCTAttachment 对象。
 attachment.name = "Launch Screen"：为截图设置一个名称。
 attachment.lifetime = .keepAlways：设置截图的保存策略，这里设置为一直保留。
 add(attachment)：将截图添加到测试报告中。
 代码的作用

 确保应用程序启动正常：通过测试应用程序的启动过程，可以确保应用程序能够正常启动，没有崩溃或异常。
 捕获启动屏幕截图：可以将启动屏幕截图保存下来，方便对比不同版本或不同配置下的启动界面。
 为后续测试做准备：在启动应用程序后，可以进行后续的 UI 测试，例如检查界面元素是否存在、是否可以点击等。
 总结

 这段代码主要用于测试 iOS 应用程序的启动过程，并捕获启动屏幕截图。它通过 XCTest 框架提供的功能，实现了对应用程序 UI 的自动化测试。*/
