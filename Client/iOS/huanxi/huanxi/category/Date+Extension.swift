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
