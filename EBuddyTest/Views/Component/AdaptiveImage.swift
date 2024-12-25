//
//  AdaptiveImage.swift
//  EBuddyTest
//
//  Created by Dicky Geraldi on 25/12/24.
//

import SwiftUI

struct AdaptiveImage: View {
    @Environment(\.colorScheme) var colorScheme
    let imageName: String

    @ViewBuilder var body: some View {
        Image("\(imageName)-\(colorScheme == .light ? "light" : "dark")")
            .resizable()
    }
}
