//
//  ObjectExtension.swift
//  EBuddyTest
//
//  Created by Dicky Geraldi on 25/12/24.
//

import Foundation

public extension String {
    func capitalizingFirstLetter() -> String {
        return prefix(1).capitalized + dropFirst()
    }
    func trim() -> String {
        return trimmingCharacters(in: CharacterSet.whitespaces)
    }

    func range(from nsRange: NSRange) -> Range<String.Index>? {
        guard
            let from16 = utf16.index(utf16.startIndex, offsetBy: nsRange.location, limitedBy: utf16.endIndex),
            let to16 = utf16.index(from16, offsetBy: nsRange.length, limitedBy: utf16.endIndex),
            let from = String.Index(from16, within: self),
            let to = String.Index(to16, within: self)
        else { return nil }
        return from ..< to
    }

    func trunc(length: Int, trailing: String = "…") -> String {
        return (self.count > length) ? self.prefix(length) + trailing : self
    }

    func isNumeric() -> Bool {
        return (!isEmpty && rangeOfCharacter(from: CharacterSet.decimalDigits.inverted) == nil)
    }
    func convertToDictionary() -> Any? {
        let data = self.data(using: .utf8)!
        do {
            let output = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
            return output
        } catch {
            print(error)
        }
        return nil
    }
}

public extension Dictionary {
    var jsonStringRepresentation: String? {
        guard let theJSONData = try? JSONSerialization.data(withJSONObject: self,
                                                            options: [.prettyPrinted]) else {
            return nil
        }

        return String(data: theJSONData, encoding: .ascii)
    }
}

func randomString(length: Int) -> String {
    let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
    return String((0..<length).map{ _ in letters.randomElement()! })
}

extension Double {
    func formattedRateString() -> String {
        return String(format: "%.2f/1Hr", self)
    }
}
