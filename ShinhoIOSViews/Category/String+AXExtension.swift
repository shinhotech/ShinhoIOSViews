//
//  String+AXExtension.swift
//  FSFA
//
//  Created by Lcm on 2018/3/23.
//  Copyright © 2018年 shinho. All rights reserved.
//

import UIKit
import Security

typealias JSONObject = [String: Any]
extension String {
    var dateTime: Date? {
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone.current
        formatter.dateFormat = "yyyy.MM.dd HH:mm"
        return formatter.date(from: self)
    }
    
    var format16DateString: String? {
        guard count == 19 else { return self }
        let date = self.date(withFormat: "yyyy-MM-dd HH:mm:ss")
        return date?.string(withFormat: "yyyy.MM.dd HH:mm")
    }
    
    var orNil: String? {
        return isEmpty ? nil : self
    }
    
    var orEmpty: String {
        return isEmpty ? "" : self
    }
    
    var fen: Int? {
        guard let value = NumberFormatter().number(from: self) as? Double else { return nil }
        return Int(round(value * 100.0))
    }
    
    var noSpaceAndNewline: String {
        var temp = trimmingCharacters(in: .whitespaces)
        temp = temp.trimmingCharacters(in: .newlines)
        return temp
    }
    
    var jsonObject: Any? {
        return data(using: .utf8)?.jsonObject
    }
    
    /// 验证密码
    var isValidPassword: Bool {
        let regex = "^(?![0-9]+$)(?![a-zA-Z]+$)[0-9A-Za-z]{6,16}$"
        let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
        let isValid = predicate.evaluate(with: self)
        return isValid
    }
    
    /// 是 http 格式的 url 或 key
    var isUrlString: Bool {
        
        // d374ce6b-8579-4f60-a9a9-734b6f36c2f9.jpeg
        if !(URL(string: self)?.isFileURL ?? false), !isEmpty { return true }
        
        let predicate = NSPredicate.init(format: "SELF MATCHES %@", "(http|https):\\/\\/([\\w.]+\\/?)\\S*")
        return predicate.evaluate(with: self)
    }
    var isFileUrl: Bool {
        return !isUrlString
    }
    
    var existsPath: Bool {
        let fileManager = FileManager.default
        return fileManager.fileExists(atPath: self)
    }
    
    func size(with font: UIFont) -> CGSize {
        return (self as NSString).size(withAttributes: [.font: font])
    }
    
    func height(with font: UIFont, maxWidth: CGFloat = screenWidth) -> CGFloat {
        return (self as NSString).boundingRect(with: CGSize(width: maxWidth, height: 0), options: .usesLineFragmentOrigin, attributes: [.font: font], context: nil).height
    }
    
    func handleZeroDot() -> String {
        if let doubleNumber = self.double() {
            let formatter = NumberFormatter()
            formatter.numberStyle = NumberFormatter.Style.decimal
            formatter.maximumFractionDigits = 2
            formatter.usesGroupingSeparator = false
            return formatter.string(from: NSNumber.init(value: doubleNumber)) ?? ""
        }
        return self
    }
    
    func moneyString() -> String {
        if let doubleNumber = self.double() {
            let formatter = NumberFormatter()
            formatter.numberStyle = NumberFormatter.Style.decimal
            formatter.maximumFractionDigits = 2
            return formatter.string(from: NSNumber.init(value: doubleNumber)) ?? ""
        }
        return self
    }
    
    func sub(left: String, right: String) -> [String] {
        var results = [String]()
        let pattern = "(?<=\(left)).*?(?=\(right))"
        let regex = try? NSRegularExpression(pattern: pattern, options: [])
        let res = regex?.matches(in: self, options: [], range: NSRange.init(location: 0, length: count))
        for result in res ?? [] {
            results.append((self as NSString).substring(with: result.range))
        }
        return results
    }
    
    func jsonFormatPrint() -> String {
        var result = ""
        var level = 0
        for c in self {
            switch c {
            case "{", "[":
                level += 1
                fallthrough
            case ",":
                result.append(c)
                result.append("\n")
                result += String(repeating: "    ", count: level)
            case "]", "}":
                level -= 1
                result.append("\n")
                result += String(repeating: "    ", count: level)
                result.append(c)
            default:
                result.append(c)
            }
        }
        return result
    }
    
    /// 去掉预设值前缀
    var trimPresetPrefix: String {
        return self
    }
    
    /// 添加预设值前缀
    var addPresetPrefix: String {
        return self
    }
}

extension String {
    //Range转换为NSRange
    func nsRange(from range: Range<String.Index>) -> NSRange? {
        if let from = range.lowerBound.samePosition(in: utf16),
            let to = range.upperBound.samePosition(in: utf16) {
            return NSRange(location: utf16.distance(from: utf16.startIndex, to: from),
            length: utf16.distance(from: from, to: to))
        }
        return nil
    }
     
    //Range转换为NSRange
    func range(from nsRange: NSRange) -> Range<String.Index>? {
        guard
            let from16 = utf16.index(utf16.startIndex, offsetBy: nsRange.location,
                                     limitedBy: utf16.endIndex),
            let to16 = utf16.index(from16, offsetBy: nsRange.length,
                                   limitedBy: utf16.endIndex),
            let from = String.Index(from16, within: self),
            let to = String.Index(to16, within: self)
            else { return nil }
        return from ..< to
    }
}


extension Substring {
    var string: String {
        return String(self)
    }
}
