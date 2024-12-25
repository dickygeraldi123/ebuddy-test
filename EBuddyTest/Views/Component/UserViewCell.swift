//
//  UserViewCell.swift
//  EBuddyTest
//
//  Created by Dicky Geraldi on 25/12/24.
//

import SwiftUI
import Kingfisher

struct UserViewCell: View {
    var userData: UsersModel!

    var body: some View {
        VStack(spacing: 4) {
            HStack {
                Text(userData.email ?? "")
                    .font(AppFont.bold.with(size: 16))
                    .foregroundColor(Color("primary-text"))
                Circle()
                    .fill(Color(UIColor(hex: userData.isActive! ? "5CB85F" : "808080")))
                    .frame(width: 8, height: 8)
                Spacer()
                Image("ic-verified")
                    .resizable()
                    .frame(width: 20, height: 20)
                AdaptiveImage(imageName: "ic-instagram")
                    .frame(width: 20, height: 20)
            }
            .padding(.bottom, 12)
            KFImage(URL(string: userData.photoProfileUrl ?? ""))
                .resizable()
                .scaledToFill()
                .frame(width: 158, height: 180)
                .cornerRadius(12)
                .padding(.bottom, 24)
            HStack(spacing: 4) {
                Image("ic-star")
                    .resizable()
                    .frame(width: 20, height: 20)
                Text("\(String(format: "%.2f", userData.rating ?? 0))")
                    .font(AppFont.bold.with(size: 14))
                    .foregroundColor(Color("primary-text"))
                Text("(\(userData.totalRating ?? 0))")
                    .font(AppFont.bold.with(size: 14))
                    .foregroundColor(Color("secondary-text"))
                Spacer()
            }
            HStack(spacing: 4) {
                AdaptiveImage(imageName: "ic-mana")
                    .frame(width: 20, height: 20)
                Text(userData.pricePerHour?.formattedRateString() ?? "")
                    .font(AppFont.bold.with(size: 14))
                    .foregroundColor(Color("primary-text"))
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
