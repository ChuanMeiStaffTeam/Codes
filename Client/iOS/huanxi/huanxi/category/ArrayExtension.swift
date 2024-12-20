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

