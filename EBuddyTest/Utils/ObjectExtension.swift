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
}

extension Double {
    func formattedRateString() -> String {
        return String(format: "%.2f/1Hr", self)
    }
}
