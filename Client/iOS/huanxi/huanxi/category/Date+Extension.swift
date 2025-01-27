//
//  Date+Extension.swift
//  huanxi
//
//  Created by rslz on 2024/11/11.
//

import Foundation

extension Date {
    
    /// 日期格式枚举
    enum DateFormat: String {
        case standard = "yyyy-MM-dd HH:mm:ss"
        case shortDate = "yyyy-MM-dd"
        case fullDate = "yyyy-MM-dd HH:mm:ss.SSS"
        case custom = ""
    }
    
    /// 帖子时间线
    static func formatTime(timeInterval:TimeInterval) -> String {
        let date = Date.init(timeIntervalSince1970: timeInterval)
        let formatter = DateFormatter.init()
        if date.isToday() {
            if date.isJustNow() {
                return "刚刚"
            } else {
                formatter.dateFormat = "HH:mm"
                return formatter.string(from: date)
            }
        } else {
            if date.isYestoday() {
                formatter.dateFormat = "昨天"
                return formatter.string(from: date)
            } else if date.isCurrentWeek() {
                formatter.dateFormat = date.dateToWeekday()
                return formatter.string(from: date)
            } else {
                if date.isCurrentYear() {
                    formatter.dateFormat = "MM-dd  HH:mm"
                } else {
                    formatter.dateFormat = "yy-MM-dd  HH:mm"
                }
                return formatter.string(from: date)
            }
        }
    }
    
    /// 将日期字符串转换为时间戳
    /// - Parameters:
    ///   - dateString: 日期字符串
    ///   - format: 日期格式，使用 DateFormat 枚举
    ///   - customFormat: 如果选择 .custom，则需要传入具体的日期格式
    ///   - timeZone: 时区，默认为本地时区
    /// - Returns: 时间戳 (Int)，如果转换失败返回 nil
    static func convertToTimestamp(
        dateString: String,
        format: DateFormat,
        customFormat: String? = nil,
        timeZone: TimeZone = .current
    ) -> Int? {
        let dateFormatter = DateFormatter()
        
        switch format {
        case .custom:
            guard let custom = customFormat, !custom.isEmpty else {
                print("自定义格式不能为空")
                return nil
            }
            dateFormatter.dateFormat = custom
        default:
            dateFormatter.dateFormat = format.rawValue
        }
        
        dateFormatter.timeZone = timeZone
        
        if let date = dateFormatter.date(from: dateString) {
            return Int(date.timeIntervalSince1970)
        } else {
            return nil
        }
    }
    
    func isJustNow() -> Bool {
        let now = Date.init().timeIntervalSince1970
        return fabs(now - self.timeIntervalSince1970) < 60 * 2 ? true : false
    }
    
    func isCurrentWeek() -> Bool {
        let nowDate = Date.init().dateFormatYMD()
        let selfDate = self.dateFormatYMD()
        let calendar = Calendar.current
        let cmps = calendar.dateComponents([.day], from: selfDate, to: nowDate)
        return cmps.day ?? 0 <= 7
    }
    
    func isCurrentYear() -> Bool {
        let calendar = Calendar.current
        let nowComponents = calendar.dateComponents([.year], from: Date.init())
        let selfComponents = calendar.dateComponents([.year], from: self)
        return selfComponents.year == nowComponents.year
    }
    
    func dateToWeekday() -> String {
        let weekdays = ["", "星期天", "星期一", "星期二", "星期三", "星期四", "星期五", "星期六"]
        var calendar = Calendar.init(identifier: Calendar.Identifier.gregorian)
        let timeZone = TimeZone.init(identifier: "Asia/Shanghai")
        calendar.timeZone = timeZone!
        let theComponents = calendar.dateComponents([.weekday], from: self)
        return weekdays[theComponents.weekday ?? 0]
    }
    
    func isToday() -> Bool {
        let calendar = Calendar.current
        let nowComponents = calendar.dateComponents([.day, .month, .year], from: Date.init())
        let selfComponents = calendar.dateComponents([.day, .month, .year], from: self)
        return nowComponents.year == selfComponents.year && nowComponents.month == selfComponents.month && nowComponents.day == selfComponents.day
    }
    
    func isYestoday() -> Bool {
        let nowDate = Date.init().dateFormatYMD()
        let selfDate = self.dateFormatYMD()
        let calendar = Calendar.current
        let cmps = calendar.dateComponents([.day], from: selfDate, to: nowDate)
        return cmps.day == 1
    }
    
    func dateFormatYMD() -> Date {
        let fmt = DateFormatter.init()
        fmt.dateFormat = "yyyy-MM-dd"
        let selfStr = fmt.string(from: self)
        return fmt.date(from: selfStr)!
    }
}

/*代码分析：Date 扩展，日期格式化处理与时间线计算
这段代码为 Date 类添加了一些扩展方法，方便我们处理日期格式化、时间戳转换以及日期相关的判断逻辑。

核心功能：

DateFormat 枚举: 定义了常用的日期格式字符串，例如标准格式（yyyy-MM-dd HH:mm:ss）、简短日期格式（yyyy-MM-dd）等。
formatTime(timeInterval:): 根据给定的时间间隔（单位：秒），格式化成易于阅读的帖子时间线字符串，比如 "刚刚"、"HH:mm"、"昨天"、"星期几 HH:mm" 等。
convertToTimestamp(dateString:format:customFormat:timeZone:): 将日期字符串转换为时间戳 (Int)。支持自定义日期格式和时区。
其他判断方法: 提供了判断日期是否是当天、昨天、是否在当前周、当前年等方法。
代码优势：

封装常用功能: 将日期格式化、时间戳转换等常用操作封装成方法，提高代码的可读性和可重用性。
易于理解: 方法名和逻辑都比较清晰易懂。
灵活性: 支持自定义日期格式和时区。
使用场景：

时间显示: 可以将时间戳转换为易于用户阅读的格式，比如帖子列表中的发布时间。
日期筛选: 可以判断日期是否属于某个时间范围，比如筛选最近一周的数据。
时间线计算: 可以根据当前时间和过去的时间计算出合适的描述性文字，比如 "刚刚"、"昨天" 等。*/
