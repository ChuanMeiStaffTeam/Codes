//
//  DrawerView.swift
//  DrawerView
//
//  Created by Mikko Välimäki on 2017-10-28.
//  版权所有 © 2017 Mikko Välimäki. 保留所有权利。
//

import UIKit
import Dispatch

let LOGGING = false

let dateFormat = "yyyy-MM-dd hh:mm:ss.SSS"
let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = dateFormat
    formatter.locale = Locale.current
    formatter.timeZone = TimeZone.current
    return formatter
}()

@objc public enum DrawerPosition: Int {
    case closed = 0 // 关闭
    case collapsed = 1 // 折叠
    case partiallyOpen = 2 // 部分打开
    case open = 3 // 完全打开
}

extension DrawerPosition: CustomStringConvertible {

    public var description: String {
        switch self {
        case .closed: return "closed" // 关闭
        case .collapsed: return "collapsed" // 折叠
        case .partiallyOpen: return "partiallyOpen" // 部分打开
        case .open: return "open" // 完全打开
        }
    }
}

fileprivate extension DrawerPosition {

    static var allPositions: [DrawerPosition] {
        return [.closed, .collapsed, .partiallyOpen, .open] // 所有抽屉位置
    }

    static let activePositions: [DrawerPosition] = allPositions
        .filter { $0 != .closed } // 过滤掉关闭的状态

    static let openPositions: [DrawerPosition] = [
        .open,
        .partiallyOpen
    ] // 打开状态集合
}

let kVelocityTreshold: CGFloat = 0 // 速度阈值

// 垂直偏移量用于通过弹簧动画覆盖底部。
let kVerticalLeeway: CGFloat = 10.0

let kDefaultCornerRadius: CGFloat = 9.0 // 默认圆角半径

let kDefaultShadowRadius: CGFloat = 1.0 // 默认阴影半径

let kDefaultShadowOpacity: Float = 0.05 // 默认阴影不透明度

let kDefaultBorderColor = UIColor(white: 0.2, alpha: 0.2) // 默认边框颜色

let kDefaultOverlayBackgroundColor = UIColor.black // 默认覆盖背景颜色

let kOverlayOpacity: CGFloat = 0.5 // 覆盖层不透明度


@objc public protocol DrawerViewDelegate {

    @objc optional func drawer(_ drawerView: DrawerView, willTransitionFrom startPosition: DrawerPosition, to targetPosition: DrawerPosition)
    // 当抽屉从一个位置过渡到目标位置时调用

    @objc optional func drawer(_ drawerView: DrawerView, didTransitionTo position: DrawerPosition)
    // 当抽屉过渡到某个位置时调用

    @objc optional func drawerDidMove(_ drawerView: DrawerView, drawerOffset: CGFloat)
    // 当抽屉移动时调用

    @objc optional func drawerWillBeginDragging(_ drawerView: DrawerView)
    // 当抽屉开始拖动时调用

    @objc optional func drawerWillEndDragging(_ drawerView: DrawerView)
    // 当抽屉即将停止拖动时调用
}

private struct ChildScrollViewInfo {
    var scrollView: UIScrollView
    var scrollWasEnabled: Bool
    var gestureRecognizers: [UIGestureRecognizer] = []
}

@IBDesignable open class DrawerView: UIView {

    // MARK: - 公共类型

    /// InsetAdjustmentBehavior 描述插入调整的行为。通常用于考虑设备的安全区域。
    public enum InsetAdjustmentBehavior: Equatable {
        /// 自动计算底部插入量。
        case automatic
        /// 从父视图的安全区域计算底部插入量。
        case superviewSafeArea
        /// 使用固定值作为底部插入量。
        case fixed(CGFloat)
        /// 不进行自动插入调整。
        case never
    }

    public enum ContentVisibilityBehavior {
        /// 隐藏被底部插入量剪裁的任何内容。
        case automatic
        /// 类似于 automatic，但只隐藏完全位于底部插入量以下的内容。
        case allowPartial
        /// 指定要隐藏的具体视图。
        case custom(() -> [UIView])
        /// 不使用底部插入量。
        case never
    }

    public enum OverlayVisibilityBehavior {
        /// 仅在最顶层位置显示覆盖层。
        case topmostPosition
        /// 在完全或部分打开时显示覆盖层。
        case whenOpen
        /// 不显示覆盖层。
        case disabled
    }

    public enum OpenHeightBehavior {
        /// 默认情况下，抽屉完全展开。
        case none
        /// 使用 `systemLayoutSizeFitting` 来确定抽屉的高度。
        case fitting
        /// 使用固定高度。
        case fixed(height: CGFloat)
    }

    public enum BackgroundEffectStyle {
        case none // 无效果
        case visualEffect(UIVisualEffect) // 使用视觉效果
        case systemDefault // 系统默认效果
    }

    // MARK: - 视觉属性

    /// 抽屉视图的圆角半径。
    @IBInspectable public var cornerRadius: CGFloat = kDefaultCornerRadius {
        didSet {
            updateVisuals() // 更新视觉效果
        }
    }

    /// 抽屉视图的阴影半径。
    @IBInspectable public var shadowRadius: CGFloat = kDefaultShadowRadius {
        didSet {
            updateVisuals() // 更新视觉效果
        }
    }

    /// 抽屉视图的阴影不透明度。
    @IBInspectable public var shadowOpacity: Float = kDefaultShadowOpacity {
        didSet {
            updateVisuals() // 更新视觉效果
        }
    }

    /// 抽屉视图背景的使用效果。如果设置为 nil，则不使用任何效果。
    public var backgroundEffect: BackgroundEffectStyle = .systemDefault {
        didSet {
            updateVisuals() // 更新视觉效果
        }
    }

    public var borderColor: UIColor = kDefaultBorderColor {
        didSet {
            updateVisuals() // 更新视觉效果
        }
    }

    public var insetAdjustmentBehavior: InsetAdjustmentBehavior = .automatic {
        didSet {
            setNeedsLayout() // 标记需要布局
        }
    }

    public var contentVisibilityBehavior: ContentVisibilityBehavior = .automatic {
        didSet {
            setNeedsLayout() // 标记需要布局
        }
    }

    public var overlayVisibilityBehavior: OverlayVisibilityBehavior = .topmostPosition {
        didSet {
            updateVisuals() // 更新视觉效果
        }
    }

    public var overlayBackgroundColor: UIColor = kDefaultOverlayBackgroundColor {
        didSet {
            updateVisuals() // 更新视觉效果
        }
    }

    public var overlayOpacity: CGFloat = kOverlayOpacity {
        didSet {
            setPosition(currentPosition, animated: false, notifyDelegate: false)
            // 设置抽屉位置，但不通知委托
        }
    }

    public var openHeightBehavior: OpenHeightBehavior = .none {
        didSet {
            setNeedsRespositioning() // 标记需要重新定位
        }
    }

    public var automaticallyAdjustChildContentInset: Bool = true {
        didSet {
            safeAreaInsetsDidChange() // 当安全区域变化时调用
        }
    }

    public override var isHidden: Bool {
        didSet {
            self.overlay?.isHidden = isHidden // 更新覆盖层的隐藏状态
        }
    }

    public var isConcealed: Bool {
        get {
            return _isConcealed // 返回是否被隐藏
        }
        set {
            setConcealed(newValue, animated: false)
        }
    }

    public func setConcealed(_ concealed: Bool, animated: Bool, completion: ((Bool) -> Void)? = nil) {
        _isConcealed = concealed
        setPosition(currentPosition, animated: animated, completion: completion)
    }

    public func removeFromSuperview(animated: Bool, completion: ((Bool) -> Void)? = nil) {
        setPosition(.closed, animated: animated) { _ in
            self.removeFromSuperview()
            self.overlay?.removeFromSuperview()
            completion?(true)
        }
    }

    // MARK: - 公共属性

    @IBOutlet
    public weak var delegate: DrawerViewDelegate?

    /// 用于处理抽屉拖动的手势识别器。
    public lazy var panGestureRecognizer: UIPanGestureRecognizer = {
        var panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
        panGestureRecognizer.maximumNumberOfTouches = 2
        panGestureRecognizer.minimumNumberOfTouches = 1
        return panGestureRecognizer
    }()
    
    /// 开启或关闭抽屉时弹簧动画的阻尼比率。
    public var animationSpringDampingRatio: CGFloat = 0.8

    /// 布尔值，指示活动抽屉是否应该在滚动到底部后关闭。
    public var childScrollViewsPanningCanDismissDrawer = true

    /// 布尔值，指示抽屉是否启用。当禁用时，抽屉的所有用户交互都被禁用。但对内容的用户交互仍然可能。
    public var enabled: Bool = true

    /// 抽屉的位置偏移量。偏移量从底部测量，零表示抽屉顶部位于其父视图的底部。隐藏的抽屉将具有与关闭相同的偏移量。
    public var drawerOffset: CGFloat {
        guard let superview = superview else {
            return 0
        }

        if self.isConcealed {
            let closedSnapPosition = self.snapPosition(for: .closed, inSuperView: superview)
            return convertScrollPositionToOffset(closedSnapPosition)
        } else {
            return convertScrollPositionToOffset(self.currentSnapPosition)
        }
    }

    public func visibleHeight(forPosition position: DrawerPosition) -> CGFloat {
        guard let superview = superview else {
            return 0
        }

        let snapPosition = self.snapPosition(for: position, inSuperView: superview)
        return convertScrollPositionToOffset(snapPosition)
    }

    // 为 Interface Builder 提供支持，其他情况下请不要使用。
    @IBOutlet
    public var containerView: UIView? {
        willSet {
            // TODO: 检查是否已从 nib 初始化。
            if self.superview != nil {
                abort(reason: "Superview 已设置，请使用普通 UIView 方法设置视图层级")
            }
        }
        didSet {
            if let containerView = containerView {
                self.attachTo(view: containerView)
            }
        }
    }

    /// 将抽屉附加到给定视图。抽屉将更新其约束以匹配目标视图的边界。
    ///
    /// - 参数 view: 包含抽屉的视图。
    public func attachTo(view: UIView) {

        if self.superview == nil {
            self.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(self)
        } else if self.superview !== view {
            log("无效状态；调用 attachTo(view:) 时 superview 已设置")
        }

        topConstraint = self.topAnchor.constraint(equalTo: view.topAnchor, constant: self.topMargin)
        heightConstraint = self.heightAnchor.constraint(greaterThanOrEqualTo: view.heightAnchor, multiplier: 1, constant: -self.topSpace)
        let bottomConstraint = self.bottomAnchor.constraint(greaterThanOrEqualTo: view.bottomAnchor)

        let constraints = [
            self.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            self.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            topConstraint,
            heightConstraint,
            bottomConstraint
        ]

        for constraint in constraints {
            constraint?.isActive = true
        }

        setNeedsRespositioning()
        updateVisuals()
    }

    // TODO: 使用尺寸类管理位置。

    /// 抽屉在其全高时的顶部边距。
    public var topMargin: CGFloat = 68.0 {
        didSet {
            self.updateSnapPosition(animated: false)
        }
    }

    /// 折叠时的抽屉高度。
    public var collapsedHeight: CGFloat = 68.0 {
        didSet {
            self.updateSnapPosition(animated: false)
        }
    }

    /// 部分打开时的抽屉高度。
    public var partiallyOpenHeight: CGFloat = 264.0 {
        didSet {
            self.updateSnapPosition(animated: false)
        }
    }

    /// 抽屉的当前状态。
    public var position: DrawerPosition {
        get {
            return currentPosition
        }
        set {
            self.setPosition(newValue, animated: false)
        }
    }

    /// 用户可交互的抽屉状态列表。请注意，编程上仍然可以设置为任何状态，此列表仅定义抽屉的吸附状态。
    public var snapPositions: [DrawerPosition] = DrawerPosition.activePositions {
        didSet {
            if !snapPositions.contains(self.position) {
                // 当前状态不在列表中，默认为最关闭的状态。
                self.setInitialPosition()
            }
            self.heightConstraint?.constant = -self.topSpace
        }
    }

    public var drawerAnimationDuration: Double = 0.5
    /// 用于自动隐藏子视图的不透明度（0 到 1）。公开此属性以便您可以与自定义视图匹配不透明度。
    public private(set) var currentChildOpacity: CGFloat = 1.0

    // MARK: - 私有属性

    fileprivate var overlayTapRecognizer: UITapGestureRecognizer!

    private var panOrigin: CGFloat = 0.0

    private var horizontalPanOnly: Bool = true

    private var drawerPanStarted: Bool = false

    private var previousAnimator: UIViewPropertyAnimator? = nil

    private var currentPosition: DrawerPosition = .collapsed

    private var topConstraint: NSLayoutConstraint? = nil

    private var heightConstraint: NSLayoutConstraint? = nil

    fileprivate var childScrollViews: [ChildScrollViewInfo] = []

    private var overlay: Overlay?

    /// 延迟移除覆盖层。需要在动画后延迟移除覆盖层。
    private var shouldRemoveOverlay: Bool = false

    private let borderView = UIView()

    private let backgroundView = UIVisualEffectView(effect: nil)

    private var willConceal: Bool = false

    private var _isConcealed: Bool = false

    private var orientationChanged: Bool = false

    private var lastWarningDate: Date?

    private let embeddedView: UIView?

    private var hiddenChildViews: [UIView]?

    private var needsRespositioning = false

    private var overlayBottomConstraint: NSLayoutConstraint?

    // MARK: - 初始化

    init() {
        self.embeddedView = nil
        super.init(frame: CGRect())
        self.setup()
    }

    private init(embeddedView: UIView?) {
        self.embeddedView = embeddedView
        super.init(frame: CGRect())
        self.setup()
    }

    override init(frame: CGRect) {
        self.embeddedView = nil
        super.init(frame: frame)
        self.setup()
    }

    required public init?(coder aDecoder: NSCoder) {
        self.embeddedView = nil
        super.init(coder: aDecoder)
        self.setup()
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    /// 使用给定视图的内容初始化抽屉。提供的视图作为子视图添加到抽屉中，并通过自动布局从所有边约束。
    convenience public init(withView view: UIView) {
        self.init(embeddedView: view)

        view.frame = self.bounds
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(view)

        for c in [
            view.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            view.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            view.heightAnchor.constraint(equalTo: self.heightAnchor),
            view.topAnchor.constraint(equalTo: self.topAnchor)
        ] {
            c.isActive = true
        }
    }

    func embed(view: UIView) {
        view.backgroundColor = .clear
        view.frame = self.bounds
        view.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(view)
        NSLayoutConstraint.activate([
            view.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            view.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            view.heightAnchor.constraint(equalTo: self.heightAnchor),
            view.topAnchor.constraint(equalTo: self.topAnchor)
        ])
    }

    private func setup() {
        #if swift(>=4.2)
        NotificationCenter.default.addObserver(
            self,
            selector:
 #selector(handleOrientationChange),
            name: UIDevice.orientationDidChangeNotification,
            object: nil)
        #else
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleOrientationChange),
            name: NSNotification.Name.UIDeviceOrientationDidChange,
            object: nil)
        #endif

        panGestureRecognizer.delegate = self
        self.addGestureRecognizer(panGestureRecognizer)

        self.translatesAutoresizingMaskIntoConstraints = false

        setupBackgroundView()
        setupBorderView()

        updateVisuals()
    }

    private func setupBackgroundView() {
        backgroundView.frame = self.bounds
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        backgroundView.clipsToBounds = true

        self.insertSubview(backgroundView, at: 0)

        let backgroundViewConstraints = [
            backgroundView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: kVerticalLeeway),
            backgroundView.topAnchor.constraint(equalTo: self.topAnchor)
        ]

        for constraint in backgroundViewConstraints {
            constraint.isActive = true
        }

        self.backgroundColor = UIColor.clear
    }

    private func setupBorderView() {
        borderView.translatesAutoresizingMaskIntoConstraints = false
        borderView.clipsToBounds = true
        borderView.isUserInteractionEnabled = false
        borderView.backgroundColor = UIColor.clear
        borderView.layer.cornerRadius = 10

        self.addSubview(borderView)

        let borderViewConstraints = [
            borderView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: -0.5),
            borderView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0.5),
            borderView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: kVerticalLeeway),
            borderView.topAnchor.constraint(equalTo: self.topAnchor, constant: -0.5)
        ]

        for constraint in borderViewConstraints {
            constraint.isActive = true
        }
    }

    // MARK: - View methods
    private func setNeedsRespositioning() {
        needsRespositioning = true
        self.setNeedsLayout()
    }

    private func removeOverlayIfNeeded() {
        if self.shouldRemoveOverlay, let overlay = self.overlay {
            overlay.removeFromSuperview()
            self.overlay = nil
            self.shouldRemoveOverlay = false
        }
    }

    public override func layoutSubviews() {
        super.layoutSubviews()

        // NB: For some reason the subviews of the blur
        // background don't keep up with sudden change.
        for view in self.backgroundView.subviews {
            view.frame.origin.y = 0
        }

        removeOverlayIfNeeded()

        if self.orientationChanged || needsRespositioning {
            self.updateSnapPosition(animated: false)
            self.orientationChanged = false
            needsRespositioning = false
        }
    }

    @objc func handleOrientationChange() {
        self.orientationChanged = true
        self.setNeedsLayout()
    }

    // MARK: - Scroll position methods

    /// Set the position of the drawer.
    ///
    /// - parameter position The position to be set.
    /// - parameter animated Wheter the change should be animated or not.
    public func setPosition(_ position: DrawerPosition, animated: Bool, completion: ((Bool) -> Void)? = nil) {

        // Don't notify about position if concealing the drawer. Notify only if position changed.
        let visiblePosition = (_isConcealed ? .closed : position)
        let notifyDelegate = !_isConcealed && (currentPosition != visiblePosition)
        self.setPosition(position, animated: animated, notifyDelegate: notifyDelegate, completion: completion)
    }

    private func setPosition(_ position: DrawerPosition, animated: Bool, notifyDelegate: Bool, completion: ((Bool) -> Void)? = nil) {
        // Get the next available position. Closed position is always supported.
        let visiblePosition = (_isConcealed ? .closed : position)

        if notifyDelegate {
            self.delegate?.drawer?(self, willTransitionFrom: currentPosition, to: position)
        }

        self.currentPosition = position

        let nextSnapPosition: CGFloat

        if let superview = self.superview {
            nextSnapPosition = snapPosition(for: visiblePosition, inSuperView: superview)
            self.scrollToPosition(nextSnapPosition, animated: animated, notifyDelegate: true) { finished in
                if notifyDelegate {
                    self.delegate?.drawer?(self, didTransitionTo: visiblePosition)
                }
                completion?(finished)
            }
        } else {
            // No superview, so only notify.
            if notifyDelegate {
                self.delegate?.drawer?(self, didTransitionTo: visiblePosition)
            }
            completion?(false)
        }
    }

    private func scrollToPosition(_ scrollPosition: CGFloat, animated: Bool, notifyDelegate: Bool, completion: ((Bool) -> Void)? = nil) {

        if previousAnimator?.isRunning == true {
            previousAnimator?.stopAnimation(false)
            if let state = previousAnimator?.state, state == .stopped {
                previousAnimator?.finishAnimation(at: .current)
            }
            previousAnimator = nil
        }

        if animated {
            // Create the animator.
            let animator = UIViewPropertyAnimator(
                duration: drawerAnimationDuration,
                timingParameters: UISpringTimingParameters(dampingRatio: animationSpringDampingRatio))
            animator.addAnimations {
                self.setScrollPosition(scrollPosition, notifyDelegate: notifyDelegate)
            }
            animator.addCompletion({ pos in
                if pos == .end {
                    self.superview?.layoutIfNeeded()
                    self.layoutIfNeeded()
                    self.setNeedsUpdateConstraints()
                } else if pos == .current {
                    // Animation was cancelled, update the constraints to match view's frame.
                    // NOTE: This is a workaround as there seems to be no way of creating
                    // a spring-based animation with .beginFromCurrentState option. Also it
                    // seemded that the option didn't work as expected, so we need to do this
                    // here manually.
                    if let f = self.layer.presentation()?.frame {
                        self.setScrollPosition(f.minY, notifyDelegate: false)
                    }
                }

                self.removeOverlayIfNeeded()

                if let completion = completion {
                    DispatchQueue.main.async {
                        completion(pos == .end)
                    }
                }
            })

            // Add extra height to make sure that bottom doesn't show up.
            self.superview?.layoutIfNeeded()

            animator.startAnimation()
            previousAnimator = animator
        } else {
            self.setScrollPosition(scrollPosition, notifyDelegate: notifyDelegate)
        }
    }

    private func updateScrollPosition(whileDraggingAtPoint dragPoint: CGFloat, notifyDelegate: Bool) {
        guard let superview = superview else {
            log("ERROR: Cannot set position, no superview defined")
            return
        }

        let positions = self.snapPositions
            .compactMap { self.snapPosition(for: $0, inSuperView: superview) }
            .sorted()

        let position: CGFloat
        if let lowerBound = positions.first, dragPoint < lowerBound {
            position = lowerBound - damp(value: lowerBound - dragPoint, factor: 20)
        } else if let upperBound = positions.last, dragPoint > upperBound {
            position = upperBound + damp(value: dragPoint - upperBound, factor: 20)
        } else {
            position = dragPoint
        }

        self.setScrollPosition(position, notifyDelegate: notifyDelegate)
    }

    private func updateSnapPosition(animated: Bool) {
        if panGestureRecognizer.state.isTracking == false {
            self.setPosition(currentPosition, animated: animated)
        }
    }

    private func setScrollPosition(_ scrollPosition: CGFloat, notifyDelegate: Bool) {
        self.topConstraint?.constant = scrollPosition
        self.setOverlayOpacity(forScrollPosition: scrollPosition)
        self.setShadowOpacity(forScrollPosition: scrollPosition)
        self.setChildOpacity(forScrollPosition: scrollPosition)

        if notifyDelegate {
            let drawerOffset = convertScrollPositionToOffset(scrollPosition)
            self.delegate?.drawerDidMove?(self, drawerOffset: drawerOffset)
        }

        self.superview?.layoutIfNeeded()
    }

    private func setInitialPosition() {
        self.position = self.snapPositionsDescending.last ?? .collapsed
    }

    // MARK: - Pan handling

    @objc private func handlePan(_ sender: UIPanGestureRecognizer) {
        let isFullyExpanded = self.snapPositionsDescending.last == self.position

        switch sender.state {
        case .began:
            self.delegate?.drawerWillBeginDragging?(self)

            self.previousAnimator?.stopAnimation(true)

            // Get the actual position of the view.
            let frame = self.layer.presentation()?.frame ?? self.frame
            self.panOrigin = frame.origin.y
            self.horizontalPanOnly = true
            self.drawerPanStarted = false

            updateScrollPosition(whileDraggingAtPoint: panOrigin, notifyDelegate: true)

        case .changed:

            let translation = sender.translation(in: self)
            let velocity = sender.velocity(in: self)
            if velocity.y == 0 {
                break
            }

            // If scrolling upwards a scroll view, ignore the events.
            if self.childScrollViews.count > 0 {

                // Collect the active pan gestures with their respective scroll views.
                let simultaneousPanGestures = self.childScrollViews
                    .filter { $0.scrollWasEnabled }
                    .flatMap { scrollInfo -> [(pan: UIPanGestureRecognizer, scrollView: UIScrollView)] in
                        // Filter out non-pan gestures
                        scrollInfo.gestureRecognizers.compactMap { recognizer in
                            (recognizer as? UIPanGestureRecognizer).map { ($0, scrollInfo.scrollView) }
                        }
                    }
                    .filter { $0.pan.isActive() }

                // TODO: Better support for scroll views that don't have directional scroll lock enabled.
                let ableToDetermineHorizontalPan =
                    simultaneousPanGestures.count > 0 && simultaneousPanGestures
                        .allSatisfy { self.ableToDetermineHorizontalPan($0.scrollView) }

                if simultaneousPanGestures.count > 0 && !ableToDetermineHorizontalPan && shouldWarn(&lastWarningDate) {
                    NSLog("WARNING (DrawerView): One subview of DrawerView has not enabled directional lock. Without directional lock it is ambiguous to determine if DrawerView should start panning.")
                }

                if ableToDetermineHorizontalPan {
                    let panningVertically = simultaneousPanGestures.count > 0
                        && simultaneousPanGestures
                            .allSatisfy {
                                let pan = $0.pan.translation(in: self)
                                return !(pan.x != 0 && pan.y == 0)
                    }

                    if panningVertically {
                        self.horizontalPanOnly = false
                    }

                    if self.horizontalPanOnly {
                        log("Vertical pan cancelled due to directional lock")
                        break
                    }
                }


                let activeScrollViews = simultaneousPanGestures
                    .compactMap { $0.pan.view as? UIScrollView }

                let childReachedTheTop = activeScrollViews.contains { $0.contentOffset.y <= 0 }
                let childScrollEnabled = activeScrollViews.contains { $0.isScrollEnabled }

                let scrollingToBottom = velocity.y < 0

                let shouldScrollChildView: Bool
                if !childScrollEnabled {
                    shouldScrollChildView = false
                } else if !childReachedTheTop && !scrollingToBottom {
                    shouldScrollChildView = true
                } else if childReachedTheTop && !scrollingToBottom {
                    shouldScrollChildView = !childScrollViewsPanningCanDismissDrawer
                } else if !isFullyExpanded {
                    shouldScrollChildView = false
                } else {
                    shouldScrollChildView = true
                }

                // Disable child view scrolling
                if !shouldScrollChildView && childScrollEnabled {

                    drawerPanStarted = true
                    sender.setTranslation(CGPoint.zero, in: self)

                    // Scrolling downwards and content was consumed, so disable
                    // child scrolling and catch up with the offset.
                    let frame = self.layer.presentation()?.frame ?? self.frame
                    let minContentOffset = activeScrollViews.map { $0.contentOffset.y }.min() ?? 0

                    if minContentOffset < 0 {
                        self.panOrigin = frame.origin.y - minContentOffset
                    } else {
                        self.panOrigin = frame.origin.y
                    }

                    // Also animate to the proper scroll position.
                    log("Animating to target position...")

                    self.previousAnimator?.stopAnimation(true)
                    self.previousAnimator = UIViewPropertyAnimator.runningPropertyAnimator(
                        withDuration: 0.2,
                        delay: 0.0,
                        options: [.allowUserInteraction, .beginFromCurrentState],
                        animations: {
                            // Disabling the scroll removes negative content offset
                            // in the scroll view, so make it animate here.
                            log("Disabled child scrolling")
                            activeScrollViews.forEach { $0.isScrollEnabled = false }
                            let pos = self.panOrigin
                            self.updateScrollPosition(whileDraggingAtPoint: pos, notifyDelegate: true)
                    }, completion: nil)
                } else if !shouldScrollChildView && abs(translation.y) > 0 {
                    // Scroll only if we're not scrolling the subviews.
                    drawerPanStarted = true
                    let pos = panOrigin + translation.y
                    updateScrollPosition(whileDraggingAtPoint: pos, notifyDelegate: true)
                }
            } else if abs(translation.y) > 0 {
                drawerPanStarted = true
                let pos = panOrigin + translation.y
                updateScrollPosition(whileDraggingAtPoint: pos, notifyDelegate: true)
            }

        case.failed:
            log("ERROR: UIPanGestureRecognizer failed")
            fallthrough
        case .ended:
            let velocity = sender.velocity(in: self)
            log("Ending with vertical velocity \(velocity.y)")

            let activeScrollViews = self.childScrollViews.filter { sv in
                sv.scrollView.isScrollEnabled &&
                    sv.scrollView.gestureRecognizers?.contains { $0.isActive() } ?? false
            }

            if activeScrollViews.contains(where: { $0.scrollView.contentOffset.y > 0 }) {
                // Let it scroll.
                log("Let child view scroll.")
            } else if drawerPanStarted {
                self.delegate?.drawerWillEndDragging?(self)

                // Check velocity and snap position separately:
                // 1) A treshold for velocity that makes drawer slide to the next state
                // 2) A prediction that estimates the next position based on target offset.
                // If 2 doesn't evaluate to the current position, use that.
                let targetOffset = self.frame.origin.y + velocity.y / 100
                let targetPosition = positionFor(offset: targetOffset)

                // The positions are reversed, reverse the sign.
                let advancement = velocity.y > 0 ? -1 : 1

                let nextPosition: DrawerPosition
                if targetPosition == self.position && abs(velocity.y) > kVelocityTreshold,
                    let advanced = self.snapPositionsDescending.advance(from: targetPosition, offset: advancement) {
                    nextPosition = advanced
                } else {
                    nextPosition = targetPosition
                }
                self.setPosition(nextPosition, animated: true)
            }

            self.childScrollViews.forEach { $0.scrollView.isScrollEnabled = $0.scrollWasEnabled }
            self.childScrollViews = []

            drawerPanStarted = false

        default:
            break
        }
    }

    @objc private func onTapOverlay(_ sender: UITapGestureRecognizer) {
        if sender.state == .ended {
            if let prevPosition = self.snapPositionsDescending.advance(from: self.position, offset: -1) {
                self.setPosition(prevPosition, animated: true, notifyDelegate: true)
            }
        }
    }

    // MARK: - Dynamically evaluated properties

    private func snapPositions(for positions: [DrawerPosition], inSuperView superview: UIView)
        -> [(position: DrawerPosition, snapPosition: CGFloat)]  {
            return positions
                // Group the info on position together. For the sake of
                // robustness, hide the ones without snap position.
                .map { p in (
                    position: p,
                    snapPosition: self.snapPosition(for: p, inSuperView: superview)
                    )
            }
    }

    public var bottomInset: CGFloat {
        let bottomInset: CGFloat
        switch insetAdjustmentBehavior {
        case .automatic:
            // Evaluate how much of superview is behind the window safe area.
            if #available(iOS 11.0, *), let window = self.window, let superview = superview {
                let bounds = superview.convert(superview.bounds, to: window)
                bottomInset = max(0, window.safeAreaInsets.bottom - (window.bounds.maxY - bounds.maxY))
            } else {
                bottomInset = 0
            }
        case .superviewSafeArea:
            if #available(iOS 11.0, *) {
                bottomInset = superview?.safeAreaInsets.bottom ?? 0
            } else {
                bottomInset = 0
            }
        case .fixed(let inset):
            bottomInset = inset
        case .never:
            bottomInset = 0
        }
        return bottomInset
    }

    fileprivate func snapPosition(for position: DrawerPosition, inSuperView superview: UIView) -> CGFloat {
        switch position {
        case .open:
            if let height = self.openHeight {
                return max(self.topMargin, superview.bounds.height - bottomInset - height)
            } else {
                return self.topMargin
            }
        case .partiallyOpen:
            return superview.bounds.height - bottomInset - self.partiallyOpenHeight
        case .collapsed:
            return superview.bounds.height - bottomInset - self.collapsedHeight
        case .closed:
            // When closed, the safe area is ignored since the
            // drawer should not be visible.
            return superview.bounds.height
        }
    }

    private func opacityFactor(for position: DrawerPosition) -> CGFloat? {
        let topmost = (self.topmostPosition ?? .closed).rawValue

        switch (position, overlayVisibilityBehavior) {
        case (_, .disabled):
            return nil
        case (_, .topmostPosition):
            return (position.rawValue >= topmost) ? 1 : 0
        case (.open, .whenOpen):
            fallthrough
        case (.partiallyOpen, .whenOpen):
            return 1
        case (.collapsed, _):
            return 0
        case (.closed, _):
            return 0
        }
    }

    private var topmostPosition: DrawerPosition? {
        return self.snapPositionsDescending.last
    }

    private func shadowOpacityFactor(for position: DrawerPosition) -> Float {
        switch position {
        case .open:
            return self.shadowOpacity
        case .partiallyOpen:
            return self.shadowOpacity
        case .collapsed:
            return self.shadowOpacity
        case .closed:
            return 0
        }
    }

    private func positionFor(offset: CGFloat) -> DrawerPosition {
        guard let superview = superview else {
            return DrawerPosition.collapsed
        }
        let distances = self.snapPositions
            .compactMap { pos in (pos: pos, y: snapPosition(for: pos, inSuperView: superview)) }
            .sorted { (p1, p2) -> Bool in
                return abs(p1.y - offset) < abs(p2.y - offset)
        }

        return distances.first.map { $0.pos } ?? DrawerPosition.collapsed
    }

    // MARK: - Visuals handling

    private func updateVisuals() {
        updateLayerVisuals(self.layer)
        updateBorderVisuals(self.borderView)
        updateOverlayVisuals(self.overlay)
        updateBackgroundVisuals(self.backgroundView)
        heightConstraint?.constant = -self.topSpace
        overlayBottomConstraint?.constant = self.cornerRadius

        self.setNeedsDisplay()
    }

    public override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        if #available(iOS 13.0, *) {
            if traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
                updateVisuals()
            }
        }
    }

    private func roundTopRightLeftCorners(_ layer: CALayer) {
        if #available(iOS 11.0, *) {
            layer.maskedCorners = [
                .layerMaxXMinYCorner, // top right
                .layerMinXMinYCorner  // top left
            ]
        }
        layer.masksToBounds = false
        layer.cornerRadius = self.cornerRadius
    }

    private func updateLayerVisuals(_ layer: CALayer) {
        layer.shadowRadius = shadowRadius
        layer.shadowOpacity = shadowOpacity
        roundTopRightLeftCorners(layer)
    }

    private func updateBorderVisuals(_ borderView: UIView) {
        borderView.layer.cornerRadius = self.cornerRadius
        borderView.layer.borderColor = self.borderColor.cgColor
        borderView.layer.borderWidth = 0.5
    }

    private func updateOverlayVisuals(_ overlay: Overlay?) {
        overlay?.backgroundColor = self.overlayBackgroundColor
        overlay?.cornerRadius = self.cornerRadius
    }

    private func updateBackgroundVisuals(_ backgroundView: UIVisualEffectView) {
        backgroundView.effect = self.backgroundEffect
            .effect(inTraitCollection: self.traitCollection)
        if #available(iOS 11.0, *) {
            backgroundView.layer.cornerRadius = self.cornerRadius
            backgroundView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        } else {
            // Fallback on earlier versions
            let mask: CAShapeLayer = {
                let m = CAShapeLayer()
                let frame = backgroundView.bounds.insetBy(top: 0, bottom: -kVerticalLeeway, left: 0, right: 0)
                let path = UIBezierPath(roundedRect: frame, byRoundingCorners: [.topLeft, .topRight], cornerRadii: CGSize(width: self.cornerRadius, height: self.cornerRadius))
                m.path = path.cgPath
                return m
            }()
            backgroundView.layer.mask = mask
        }
    }

    public override func safeAreaInsetsDidChange() {
        if automaticallyAdjustChildContentInset {
            let bottomInset = self.bottomInset
            self.adjustChildContentInset(self, bottomInset: bottomInset)
            self.setNeedsRespositioning()
            self.setNeedsLayout()
       }
    }

    private func adjustChildContentInset(_ view: UIView, bottomInset: CGFloat) {
        for childView in view.subviews {
            if let scrollView = childView as? UIScrollView {
                // Do not recurse into child views if content
                // inset can be set on the superview.
                let convertedBounds = scrollView.convert(scrollView.bounds, to: self)
                let distanceFromBottom = self.bounds.height - convertedBounds.maxY
                scrollView.contentInset.bottom = max(bottomInset - distanceFromBottom, 0)
            } else {
                adjustChildContentInset(childView, bottomInset: bottomInset)
            }
        }
    }

    private func createOverlay() -> Overlay? {
        guard let superview = self.superview else {
            log("ERROR: Could not create overlay.")
            return nil
        }

        let overlay = Overlay(frame: superview.bounds)
        overlay.isHidden = self.isHidden
        overlay.translatesAutoresizingMaskIntoConstraints = false
        overlay.alpha = 0.0
        overlayTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(onTapOverlay))
        overlay.addGestureRecognizer(overlayTapRecognizer)

        superview.insertSubview(overlay, belowSubview: self)

        let overlayBottomConstraint = overlay.bottomAnchor.constraint(
            equalTo: self.topAnchor,
            constant: self.cornerRadius)

        NSLayoutConstraint.activate([
            overlay.leadingAnchor.constraint(equalTo: superview.leadingAnchor),
            overlay.trailingAnchor.constraint(equalTo: superview.trailingAnchor),
            overlay.heightAnchor.constraint(equalTo: superview.heightAnchor),
            overlayBottomConstraint,
        ])

        self.overlayBottomConstraint = overlayBottomConstraint

        updateOverlayVisuals(overlay)

        return overlay
    }

    private func setOverlayOpacity(forScrollPosition position: CGFloat) {
        guard let superview = self.superview else {
            log("ERROR: Could not set up overlay.")
            return
        }

        let opacityFactor: CGFloat
        switch (self.overlayVisibilityBehavior) {
        case .disabled:
            opacityFactor = 0
        case .topmostPosition, .whenOpen:
            let values = snapPositions(for: DrawerPosition.allPositions, inSuperView: superview)
              .compactMap { pos -> (position: CGFloat, value: CGFloat)? in
                guard let opacityFactor = self.opacityFactor(for: pos.position) else {
                    return nil
                }
                return (
                    position: pos.snapPosition,
                    value: opacityFactor
                )
            }

            if values.count > 0 {
                opacityFactor = interpolate(
                    values: values,
                    position: position)
            } else {
                opacityFactor = 0
            }
        }

        if opacityFactor > 0 {
            self.overlay = self.overlay ?? createOverlay()
            self.overlay?.alpha = opacityFactor * overlayOpacity
            self.shouldRemoveOverlay = false
        } else {
            self.overlay?.alpha = 0
            self.shouldRemoveOverlay = true
        }
    }

    private func setShadowOpacity(forScrollPosition position: CGFloat) {
        guard let superview = self.superview else {
            log("ERROR: Could not set up shadow.")
            return
        }

        let values = snapPositions(for: DrawerPosition.allPositions, inSuperView: superview)
            .map {(
                position: $0.snapPosition,
                value: CGFloat(self.shadowOpacityFactor(for: $0.position))
                )}

        let shadowOpacity = interpolate(
            values: values,
            position: position)

        self.layer.shadowOpacity = Float(shadowOpacity)
    }

    private func setChildOpacity(forScrollPosition position: CGFloat) {
        guard let superview = self.superview else {
            return
        }

        // TODO: This method doesn't take into account if a child view opacity was changed while it is hidden.

        if self.bottomInset > 0 {

            // Measure the distance to collapsed position.
            let snap = self.snapPosition(for: .collapsed, inSuperView: superview)
            let alpha = min(1, (snap - position) / self.bottomInset)

            if alpha < 1 {
                // Ask only once when beginning to hide child views.
                let viewsToHide = self.hiddenChildViews ?? self.childViewsToHide()
                self.hiddenChildViews = viewsToHide

                // Update the alpha async to avoid any glitches.
                DispatchQueue.main.async {
                    viewsToHide.forEach { view in
                        view.alpha = max(alpha, 0)
                    }
                }

            } else {
                if let hiddenViews = self.hiddenChildViews {
                    DispatchQueue.main.async {
                        hiddenViews.forEach { view in
                            view.alpha = 1
                        }
                    }
                }
                self.hiddenChildViews = nil
            }

            currentChildOpacity = alpha
        }
    }

    // MARK: - Helpers

    private func childViewsToHide() -> [UIView] {
        guard let superview = self.superview else {
            return []
        }

        var allowPartial = false
        switch self.contentVisibilityBehavior {
        case .allowPartial:
            allowPartial = true
            fallthrough
        case .automatic:
            // Hide all the views that are not completely above the horizon.
            let snap = self.snapPosition(for: .collapsed, inSuperView: superview)
            return (embeddedView ?? self).subviews.filter {
                $0 !== self.backgroundView && $0 !== self.borderView
                    && (allowPartial ? $0.frame.minY > snap : $0.frame.maxY > snap)
            }
        case .custom(let handler):
            return handler()
        case .never:
            return []

        }
    }

    private var topSpace: CGFloat {
        let topPosition = self.snapPositions
            .sortedBySnap(in: self, ascending: true)
            .first?.snap

        return topPosition ?? 0
    }

    private var openHeight: CGFloat? {
        guard let superview = self.superview else {
            return nil
        }
        switch self.openHeightBehavior {
        case .none:
            return nil
        case .fitting:
            let fittingSize = self.systemLayoutSizeFitting(
                CGSize(width: superview.bounds.size.width, height: 0),
                withHorizontalFittingPriority: .required,
                verticalFittingPriority: .defaultLow)
            return fittingSize.height
        case .fixed(let height):
            return height
        }
    }

    private var currentSnapPosition: CGFloat {
        return self.topConstraint?.constant ?? 0
    }

    private func convertScrollPositionToOffset(_ position: CGFloat) -> CGFloat {
        guard let superview = self.superview else {
            return 0
        }

        return superview.bounds.height - position
    }

    private func ableToDetermineHorizontalPan(_ scrollView: UIScrollView) -> Bool {
        let hasDirectionalLock = (scrollView is UITableView) || scrollView.isDirectionalLockEnabled
        // If vertical scroll is not possible, or directional lock is
        // enabled, we are able to detect if view was panned horizontally.
        return !scrollView.canScrollVertically || hasDirectionalLock
    }

    private func shouldWarn(_ lastWarningDate: inout Date?) -> Bool {
        let warn: Bool
        if let date = lastWarningDate {
            warn = date.timeIntervalSinceNow > 30
        } else {
            warn = true
        }
        lastWarningDate = Date()
        return warn
    }
}

// MARK: - Extensions

extension DrawerView: UIGestureRecognizerDelegate {

    override public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if gestureRecognizer === panGestureRecognizer || gestureRecognizer === overlayTapRecognizer {
            return enabled
        }
        return true
    }

    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {

        if gestureRecognizer === self.panGestureRecognizer {
            if let scrollView = otherGestureRecognizer.view as? UIScrollView {

                if let index = self.childScrollViews.firstIndex(where: { $0.scrollView === scrollView }) {
                    // Existing scroll view, update it.
                    let scrollInfo = self.childScrollViews[index]
                    self.childScrollViews[index].gestureRecognizers = scrollInfo.gestureRecognizers + [otherGestureRecognizer]
                } else {
                    // New entry.
                    self.childScrollViews.append(ChildScrollViewInfo(
                        scrollView: scrollView,
                        scrollWasEnabled: scrollView.isScrollEnabled,
                        gestureRecognizers: []))
                }
                return true
            } else if otherGestureRecognizer.view is UITextField {
                return true
            }
        }

        return false
    }

    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRequireFailureOf otherGestureRecognizer: UIGestureRecognizer) -> Bool {

        if gestureRecognizer === self.panGestureRecognizer {
            if otherGestureRecognizer.view is UIScrollView {
                // If the gesture recognizer is from a scroll view, do not fail as
                // we need to work in parallel
                return false
            }

            if otherGestureRecognizer.view is UITextField {
                return false
            }
        }

        return false
    }

}

// MARK: - Public Extensions

public extension DrawerView {

    var snapPositionsDescending: [DrawerPosition] {
        return self.snapPositions
            .sortedBySnap(in: self, ascending: false)
            .map { $0.position }
    }

    func getNextPosition(offsetBy offset: Int) -> DrawerPosition? {
        return snapPositionsDescending.advance(from: self.position, offset: offset)
    }
}


// MARK: - Private Extensions

extension DrawerView.BackgroundEffectStyle {

    func effect(inTraitCollection traitCollection: UITraitCollection) -> UIVisualEffect? {
        switch self {
        case .none: return nil
        case let .visualEffect(effect): return effect
        case .systemDefault:
            let darkMode: Bool
            if #available(iOS 12.0, *) {
                darkMode = (traitCollection.userInterfaceStyle == .dark)
            } else {
                darkMode = false
            }
            return darkMode
                ? UIBlurEffect(style: .dark)
                : UIBlurEffect(style: .light)
        }
    }
}

fileprivate extension CGRect {

    func insetBy(top: CGFloat = 0, bottom: CGFloat = 0, left: CGFloat = 0, right: CGFloat = 0) -> CGRect {
        return CGRect(
            x: self.origin.x + left,
            y: self.origin.y + top,
            width: self.size.width - left - right,
            height: self.size.height - top - bottom)
    }
}

public extension BidirectionalCollection where Element == DrawerPosition {

    /// A simple utility function that goes through a collection of `DrawerPosition` items. Note
    /// that positions are treated in the same order they are provided in the collection.
    func advance(from position: DrawerPosition, offset: Int) -> DrawerPosition? {
        guard !self.isEmpty else {
            return nil
        }

        if let index = self.firstIndex(of: position) {
            let nextIndex = self.index(index, offsetBy: offset)
            return self.indices.contains(nextIndex) ? self[nextIndex] : nil
        } else {
            return nil
        }
    }

}

fileprivate extension Collection where Element == DrawerPosition {

    func sortedBySnap(in drawerView: DrawerView, ascending: Bool) -> [(position: DrawerPosition, snap: CGFloat)] {
        guard let superview = drawerView.superview else {
            return []
        }

        return self
            .map { ($0, drawerView.snapPosition(for: $0, inSuperView: superview))}
            .sorted(by: {
                ascending
                    ? $0.snap < $1.snap
                    : $0.snap > $1.snap
            })
    }
}

fileprivate extension UIGestureRecognizer {

    func isActive() -> Bool {
        return self.isEnabled && (self.state == .changed || self.state == .began)
    }
}

fileprivate extension UIScrollView {

    var canScrollVertically: Bool {
        return self.contentSize.height > self.bounds.height
    }
}

fileprivate extension UIGestureRecognizer.State {

    var isTracking: Bool {
        return self == .began || self == .changed
    }
}

#if !swift(>=4.1)
fileprivate extension Array {

    // Backwards support for compactMap.
    public func compactMap<ElementOfResult>(_ transform: (Element) throws -> ElementOfResult?) rethrows -> [ElementOfResult] {
        return try self.flatMap(transform)
    }
}
#endif

// MARK: - Private functions

fileprivate func damp(value: CGFloat, factor: CGFloat) -> CGFloat {
    return factor * (log10(value + factor/log(10)) - log10(factor/log(10)))
}

fileprivate func abort(reason: String) -> Never  {
    NSLog("DrawerView: \(reason)")
    abort()
}

fileprivate func log(_ message: String) {
    if LOGGING {
        print("\(dateFormatter.string(from: Date())): \(message)")
    }
}
