//
//  AlertView.swift
//  EBuddyTest
//
//  Created by Dicky Geraldi on 25/12/24.
//

import SwiftUI

struct AlertModifier: ViewModifier {
    @Binding var isPresented: Bool
    let title: String
    let message: String

    func body(content: Content) -> some View {
        content
            .alert(isPresented: $isPresented) {
                Alert(
                    title: Text(title),
                    message: Text(message),
                    dismissButton: .default(Text("OK"))
                )
            }
    }
}

extension View {
    func customAlert(isPresented: Binding<Bool>, title: String, message: String) -> some View {
        self.modifier(AlertModifier(isPresented: isPresented, title: title, message: message))
    }
}
