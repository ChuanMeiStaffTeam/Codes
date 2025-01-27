//
//  Interpolation.swift
//  DrawerView
//
//  Created by Mikko Välimäki on 2018-03-10.
//  Copyright © 2018 Mikko Välimäki. All rights reserved.
//

import Foundation

internal func interpolate<T: FloatingPoint>(values: [(position: T, value: T)], position: T) -> T {

    let sorted = values.sorted { (p1, p2) -> Bool in p1.position < p2.position }

    let prev = sorted.last(where: { $0.position <= position })
    let next = sorted.first(where: { $0.position > position })

    if let a = prev, let b = next {
        let n = (position - a.position) / (b.position - a.position)
        return a.value + (b.value - a.value) * n
    } else if let a = prev ?? next {
        return a.value
    } else {
        return 0
    }
}

fileprivate extension Array {

    func last(where predicate: (Element) throws -> Bool) rethrows -> Element? {
        return try self.filter(predicate).last
    }
}

/*一般来说，这段代码实现了一个线性插值的功能。

代码功能分析：

interpolate 函数：
该函数用于在给定的一组有序数据点中，根据输入的 position 值，计算出对应的插值结果。
输入的 values 参数是一个包含多个元组的数组，每个元组包含一个 position 值和一个对应的 value 值。
函数会首先对 values 数组按照 position 进行排序。
然后找到输入的 position 所在的两个相邻点。
最后，根据这两个相邻点和 position 的相对位置，利用线性插值公式计算出对应的 value。
Array 扩展：
为 Array 类型添加了一个 last(where:) 方法，用于查找数组中满足指定条件的最后一个元素。
代码用途：

动画曲线： 可以用来定义自定义的动画曲线，通过给定一系列控制点，然后根据需要的时间点计算出对应的动画值。
数据平滑： 可以用来对原始数据进行平滑处理，减少噪声的影响。
查找表： 可以用来从一个预先计算好的值表中查找对应的数据。

代码优化建议：

缓存排序结果： 如果 values 数组的内容不经常改变，可以考虑将排序后的结果缓存起来，避免重复排序。
边界处理： 可以对输入的 position 值进行边界检查，防止数组越界。
性能优化： 如果需要处理大量数据，可以考虑使用更快的排序算法或优化插值计算。  */
