//
//  UserViewModel.swift
//  EBuddyTest
//
//  Created by Dicky Geraldi on 25/12/24.
//


import Combine
import FirebaseFirestore

class UserViewModel: ObservableObject {
    // MARK: - Properties
    @Published var isLoading: Bool = true
    @Published var isShowAlert: Bool = false
    @Published var arrayOfUsers: [UsersModel] = []
    @Published var sortFilter: [SortModel] = []
    @Published var filters: [FilterModel] = []
    @Published var sort: [(String, Bool)] = []

    func getAllUsersData() {
        isLoading = true
        FirebaseManager.shared.getDataByCollection(collectionName: "USERS") { [weak self] data, err in
            if let weakSelf = self {
                weakSelf.isLoading = false
                if err != nil {
                    weakSelf.isShowAlert = true
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

    func getUsersByQuery() {
        sortFilter.append(SortModel(sortBy: "lastActive", sortValue: .Desc))
        sortFilter.append(SortModel(sortBy: "rating", sortValue: .Desc))
        sortFilter.append(SortModel(sortBy: "pricePerHour", sortValue: .Asc))
        filters.append(FilterModel(filterName: "ge", filterValue: 0))

        isLoading = true
        FirebaseManager.shared.getDataByQuery("USERS", filters: filters, sortFilter: sortFilter) { [weak self] data, err in
            if let weakSelf = self {
                weakSelf.isLoading = false
                if err != nil {
                    weakSelf.isShowAlert = true
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
