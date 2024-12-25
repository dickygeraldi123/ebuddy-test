//
//  UserViewModel.swift
//  EBuddyTest
//
//  Created by Dicky Geraldi on 25/12/24.
//


import Combine
import FirebaseFirestore

class MyPlaylistViewModel: ObservableObject {
    // MARK: - Properties
    @Published var arrayOfUsers: [UsersModel] = []
    @Published var sortFilter: [SortModel] = []
    @Published var filters: [FilterModel] = []
    @Published var sort: [(String, Bool)] = []

    func getAllUsersData() {
        FirebaseManager.shared.getDataByCollection(collectionName: "USERS") { [weak self] data, err in
            if let weakSelf = self {
                if err != nil {
                    // Show alert
                } else {
                    if let data = data {
                        for document in data {
                            weakSelf.arrayOfUsers.append(UsersModel.createObject(document.data()))
                        }
                    }
                }
            }
        }
    }

    func getUsersByQuery() async {
        FirebaseManager.shared.getDataByQuery("USERS", filters: filters, sortFilter: sortFilter) { [weak self] data, err in
            if let weakSelf = self {
                if err != nil {
                    // Show alert
                } else {
                    if let data = data {
                        for document in data {
                            weakSelf.arrayOfUsers.append(UsersModel.createObject(document.data()))
                        }
                    }
                }
            }
        }
    }
}
