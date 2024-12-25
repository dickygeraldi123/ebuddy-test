//
//  UtilsModel.swift
//  EBuddyTest
//
//  Created by Dicky Geraldi on 25/12/24.
//

import Foundation

class UserSession: ObservableObject {
    @Published var isAuthenticated: Bool = false
    @Published var userModel: UsersModel = UsersModel.createObject([:])
}

enum GenderEnum: Int {
    case female = 0
    case male = 1
}

enum SortValue {
    case Desc
    case Asc
}

struct FilterModel {
    var filterName: String = ""
    var filterValue: Any?
}

struct SortModel {
    var sortBy: String = ""
    var sortValue: SortValue = .Asc
}
