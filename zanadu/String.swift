//
//  String.swift
//  Atlas
//
//  Created by liudeng on 16/6/28.
//  Copyright © 2016年 Atlas. All rights reserved.
//

import Foundation

extension String{
    
    func CGFloatValue() -> CGFloat? {
        guard let doubleValue = Double(self) else {
            return nil
        }
        
        return CGFloat(doubleValue)
    }
    
    public func contains(_ other: String) -> Bool {
        // rangeOfString returns nil if other is empty, destroying the analogy with (ordered) sets.
        if other.isEmpty {
            return true
        }
        return self.range(of: other) != nil
    }
    
    public func startsWith(_ other: String) -> Bool {
        // rangeOfString returns nil if other is empty, destroying the analogy with (ordered) sets.
        if other.isEmpty {
            return true
        }
        if let range = self.range(of: other,
                                          options: NSString.CompareOptions.anchored) {
            return range.lowerBound == self.startIndex
        }
        return false
    }
    
    public func endsWith(_ other: String) -> Bool {
        // rangeOfString returns nil if other is empty, destroying the analogy with (ordered) sets.
        if other.isEmpty {
            return true
        }
        if let range = self.range(of: other,
                                          options: [NSString.CompareOptions.anchored, NSString.CompareOptions.backwards]) {
            return range.upperBound == self.endIndex
        }
        return false
    }
    
    func escape() -> String {
        let raw: NSString = self as NSString
        let str = CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                          raw,
                                                          "[]." as CFString!,":/?&=;+!@#$()',*" as CFString!,
                                                          CFStringConvertNSStringEncodingToEncoding(String.Encoding.utf8.rawValue))
        return str as! String
    }
    
    func unescape() -> String {
        let raw: NSString = self as NSString
        let str = CFURLCreateStringByReplacingPercentEscapes(kCFAllocatorDefault, raw, "[]." as CFString!)
        return str as! String
    }
    
    /**
     Ellipsizes a String only if it's longer than `maxLength`
     
     "ABCDEF".ellipsize(4)
     // "AB…EF"
     
     :param: maxLength The maximum length of the String.
     
     :returns: A String with `maxLength` characters or less
     */
    func ellipsize(maxLength: Int) -> String {
        if (maxLength >= 2) && (self.characters.count > maxLength) {
            let index1 = self.characters.index(self.startIndex, offsetBy: (maxLength + 1) / 2) // `+ 1` has the same effect as an int ceil
            let index2 = self.characters.index(self.endIndex, offsetBy: maxLength / -2)
            
            return self.substring(to: index1) + "…\u{2060}" + self.substring(from: index2)
        }
        return self
    }
    
    fileprivate var stringWithAdditionalEscaping: String {
        return self.replacingOccurrences(of: "|", with: "%7C", options: NSString.CompareOptions(), range: nil)
    }
    
    public var asURL: URL? {
        // Firefox and NSURL disagree about the valid contents of a URL.
        // Let's escape | for them.
        // We'd love to use one of the more sophisticated CFURL* or NSString.* functions, but
        // none seem to be quite suitable.
        return URL(string: self) ??
            URL(string: self.stringWithAdditionalEscaping)
    }
    
    /// Returns a new string made by removing the leading String characters contained
    /// in a given character set.
    public func stringByTrimmingLeadingCharactersInSet(_ set: CharacterSet) -> String {
        var trimmed = self
        while trimmed.rangeOfCharacter(from: set)?.lowerBound == trimmed.startIndex {
            trimmed.remove(at: trimmed.startIndex)
        }
        return trimmed
    }

}
