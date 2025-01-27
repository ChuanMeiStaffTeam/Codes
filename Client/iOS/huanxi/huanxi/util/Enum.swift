//
//  Enum.swift
//  huanxi
//
//  Created by rslz on 2024/11/11.
//


enum LoadingType: Int {
    case LoadStateIdle
    case LoadStateLoading
    case LoadStateAll
    case LoadStateFailed
}

enum RefreshingType: Int {
    case RefreshHeaderStateIdle
    case RefreshHeaderStatePulling
    case RefreshHeaderStateRefreshing
    case RefreshHeaderStateAll
}

enum ShartType: Int {
    case none
    case copy
    case wx
    case qq
    case facebook
    case ins
    case whatsapp
}

/*代码分析：状态枚举定义
 这段代码定义了三个枚举类型，分别用于表示不同的状态。

 1. LoadingType 枚举

 用途: 表示数据加载的状态。
 枚举值:
 LoadStateIdle: 空闲状态，没有加载任务。
 LoadStateLoading: 正在加载数据。
 LoadStateAll: 加载完成。
 LoadStateFailed: 加载失败。
 使用场景:
 在网络请求或数据加载过程中，使用该枚举来表示当前的加载状态，可以用于显示加载指示器、错误提示等。
 2. RefreshingType 枚举

 用途: 表示下拉刷新控件的状态。
 枚举值:
 RefreshHeaderStateIdle: 空闲状态，下拉刷新控件未被拉动。
 RefreshHeaderStatePulling: 用户正在下拉刷新控件。
 RefreshHeaderStateRefreshing: 正在刷新数据。
 RefreshHeaderStateAll: 包含所有状态。
 使用场景:
 在实现下拉刷新功能时，使用该枚举来表示刷新控件的不同状态，从而控制 UI 的显示和刷新逻辑。
 3. ShartType 枚举

 用途: 表示分享类型。
 枚举值:
 none: 不分享。
 copy: 复制。
 wx: 分享到微信。
 qq: 分享到QQ。
 facebook: 分享到Facebook。
 ins: 分享到Instagram。
 whatsapp: 分享到WhatsApp。
 使用场景:
 在实现分享功能时，使用该枚举来表示不同的分享平台，从而实现不同的分享逻辑。
 总结

 这三个枚举定义了一种类型安全的、可读性强的方式来表示不同的状态和选项。它们可以用于各种场景，例如网络请求、用户交互、数据展示等。

 优点:

 类型安全: 避免了使用原始值带来的类型错误。
 可读性强: 枚举名和枚举值具有自解释性。
 可扩展性: 可以根据需要添加新的枚举值。
*/
