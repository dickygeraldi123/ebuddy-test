//
//  HomeUserView.swift
//  EBuddyTest
//
//  Created by Dicky Geraldi on 25/12/24.
//

import SwiftUI

struct HomeUserView: View {
    @StateObject var userViewModel = UserViewModel()
    let columns: [GridItem] = Array(repeating: .init(.flexible()), count: 2)

    var body: some View {
        ZStack {
            Color.gray
                .ignoresSafeArea()

            VStack {
                VStack {
                    HStack {
                        Text("List Users")
                            .font(AppFont.bold.with(size: 20))
                            .multilineTextAlignment(.leading)
                            .foregroundColor(Color("primary-text"))
                            .frame(maxWidth: .infinity)
                        Spacer()
                    }
                }
                if userViewModel.isLoading {
                    Spacer()
                    ProgressView()
                      .progressViewStyle(CircularProgressViewStyle(tint: .blue))
                      .scaleEffect(2.0, anchor: .center)
                    Spacer()
                } else {
                    ScrollView(showsIndicators: false) {
                        LazyVGrid(columns: columns, alignment: .leading, spacing: 12) {
                            ForEach(userViewModel.arrayOfUsers, id: \.email) { data in
                                UserViewCell(userData: data)
                                    .background(Color("primary-bg"))
                                    .cornerRadius(12)
                                    .padding(.bottom, 12)
                            }
                        }
                    }
                    .padding(.horizontal, 16)
                }
            }
        }
        .alert("Opps, there is something when wrong", isPresented: $userViewModel.isShowAlert) {
            Button("OK", role: .cancel) { }
        }
        .onAppear() {
            userViewModel.getAllUsersData()
//            userViewModel.getUsersByQuery()
        }
        .navigationBarHidden(true)
    }
}

#Preview {
    HomeUserView()
}
