//
//  ViewKitExtension.swift
//  EBuddyTest
//
//  Created by Dicky Geraldi on 25/12/24.
//

import UIKit
import SwiftUI

public extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")

        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }

    convenience init(netHex: Int) {
        self.init(red: (netHex >> 16) & 0xff, green: (netHex >> 8) & 0xff, blue: netHex & 0xff)
    }

    convenience init(hex: String) {
        let string = hex
        var chars = Array(string.hasPrefix("#") ? "\(string.dropFirst())": string)
        var red: CGFloat = 0, green: CGFloat = 0, blue: CGFloat = 0, alpha: CGFloat = 1
        switch chars.count {
        case 3:
            chars = [chars[0], chars[0], chars[1], chars[1], chars[2], chars[2]]
            fallthrough
        case 6:
            chars = ["F", "F"] + chars
            fallthrough
        case 8:
            alpha = CGFloat(strtoul(String(chars[0...1]), nil, 16)) / 255
            red   = CGFloat(strtoul(String(chars[2...3]), nil, 16)) / 255
            green = CGFloat(strtoul(String(chars[4...5]), nil, 16)) / 255
            blue  = CGFloat(strtoul(String(chars[6...7]), nil, 16)) / 255
        default:
            alpha = 0
        }
        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }
}

public enum AppFont: String {
    case black = "Black"
    case bold = "Bold"
    case extraBold = "ExtraBold"
    case extraLight = "ExtraLight"
    case light = "Light"
    case medium = "Medium"
    case regular = "Regular"
    case semiBold = "SemiBold"
    case thin = "thin"

    public func with(size: CGFloat) -> Font {
        let font = Font.custom("Inter-\(self.rawValue.capitalizingFirstLetter())", fixedSize: size)
        return font
    }
}

public extension View {
    func endEditing() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    func hideNavigationBar() -> some View {
        self
            .navigationBarTitle("", displayMode: .inline)
            .navigationBarHidden(true)
    }
    func isHidden(remove: Bool = false) -> some View {
        modifier(IsHidden(remove: remove))
    }
}

public struct IsHidden: ViewModifier {
    var remove = false
    public func body(content: Content) -> some View {
        if remove {
        } else {
            content
        }
    }
}
