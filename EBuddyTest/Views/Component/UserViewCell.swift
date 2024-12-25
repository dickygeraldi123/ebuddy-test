//
//  UserViewCell.swift
//  EBuddyTest
//
//  Created by Dicky Geraldi on 25/12/24.
//

import SwiftUI
import Kingfisher

struct UserViewCell: View {
    var body: some View {
        VStack(spacing: 4) {
            HStack {
                Text("Zynx")
                    .font(AppFont.bold.with(size: 16))
                    .foregroundColor(Color("primary-text"))
                Circle()
                    .frame(width: 8, height: 8)
                    .background(Circle().foregroundColor(Color(UIColor(hex: "5CB85F"))))
                Spacer()
                Image("ic-verified")
                    .resizable()
                    .frame(width: 20, height: 20)
                AdaptiveImage(imageName: "ic-instagram")
                    .frame(width: 20, height: 20)
            }
            .padding(.bottom, 12)
            KFImage(URL(string: "https://pics.craiyon.com/2023-11-26/oMNPpACzTtO5OVERUZwh3Q.webp"))
                .resizable()
                .scaledToFill()
                .frame(width: 158, height: 180)
                .cornerRadius(12)
                .padding(.bottom, 24)
            HStack(spacing: 4) {
                Image("ic-star")
                    .resizable()
                    .frame(width: 20, height: 20)
                Text("4.9")
                    .font(AppFont.bold.with(size: 14))
                    .foregroundColor(Color("primary-text"))
                Text("(61)")
                    .font(AppFont.bold.with(size: 14))
                    .foregroundColor(Color("secondary-text"))
                Spacer()
            }
            HStack(spacing: 4) {
                AdaptiveImage(imageName: "ic-mana")
                    .frame(width: 20, height: 20)
                Text("110.00")
                    .font(AppFont.bold.with(size: 14))
                    .foregroundColor(Color("primary-text"))
                Text("/1Hr")
                    .font(AppFont.bold.with(size: 14))
                    .foregroundColor(Color("secondary-text"))
                Spacer()
            }
        }
        .padding(
            .all, 8
        )
        .frame(height: 312)
    }
}

#Preview {
    UserViewCell()
}
