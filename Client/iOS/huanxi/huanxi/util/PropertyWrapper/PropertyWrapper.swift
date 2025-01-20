//
//  PropertyWrapper.swift
//  OVTC
//
//  Created by rslz on 2025/1/7.
//

// MARK: - 限制输入的最大长度
@propertyWrapper
struct LimitedLength {
    private var value: String
    private let maxLength: Int
    
    var wrappedValue: String {
        get { value }
        set { value = String(newValue.prefix(maxLength)) }
    }
    
    init(wrappedValue: String, maxLength: Int) {
        self.maxLength = maxLength
        self.value = String(wrappedValue.prefix(maxLength))
    }
}
