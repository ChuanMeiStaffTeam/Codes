//
//  ArrayExtension.swift
//  huanxi
//
//  Created by rslz on 2024/12/21.
//

import Foundation

extension Array {
    
    mutating public func removeObject(_ obj: Element){
        let index = self.indexObj(obj)
        if index <= self.count && index > 0 {
            self.remove(at: index)
        }
        
    }
    
    public func indexObj(_  obj: Element) -> Int {
        var index = 0
        for item in self {
            if (item as AnyObject).isEqual(obj) {
                break
            }
            index += 1
        }
        
        return index >= self.count ? 0 : index
    }
    
    public func ck_objIndex(_ index: Int) -> Element? {
        if self.isEmpty {
            return nil
        }
        if index < 0 || index >= self.count {
            return self.first
        }
        return self[index]
    }
    
}

/*代码分析：Array 扩展，增强数组操作功能
 代码功能

 这段代码为 Swift 的 Array 类型添加了三个自定义的方法，以扩展数组的一些操作功能。

 removeObject(_:):

 用于从数组中移除第一个匹配到的元素。
 通过 indexObj(_:) 方法查找元素的索引，然后使用 remove(at:) 方法移除。
 需要注意: 这个方法的效率较低，尤其对于大型数组，建议使用更优化的算法，例如使用 filter 方法创建新的数组。
 indexObj(_:):

 用于查找元素在数组中的索引。
 通过遍历数组，逐个比较元素是否相等，找到第一个匹配的元素并返回其索引。
 如果未找到匹配的元素，则返回 0。
 ck_objIndex(_:):

 用于安全地获取指定索引处的元素。
 如果索引越界，则返回数组的第一个元素。
 需要注意: 返回数组的第一个元素可能不是一个好的默认行为，在实际应用中，根据具体需求可以返回 nil 或抛出异常。
 潜在问题与改进

 类型安全: indexObj(_:) 方法使用 isEqual(to:) 进行比较，对于自定义类型，可能需要重写 isEqual 方法来保证比较的正确性。
 性能: 对于大型数组，线性查找的效率较低。可以考虑使用二分查找等更高效的算法。
 错误处理: ck_objIndex(_:) 方法在索引越界时返回第一个元素，这可能导致意想不到的结果。建议返回 nil 或抛出异常。
 泛型: 可以使用泛型来提高代码的通用性，使其适用于各种类型的数组。*/

